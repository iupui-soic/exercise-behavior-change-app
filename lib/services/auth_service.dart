import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart' as app_user;

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService._internal();

  // Get current Firebase user
  User? get currentUser => _auth.currentUser;

  // Get user data from Firestore
  Future<app_user.User?> getCurrentUserData() async {
    if (currentUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        return app_user.User(
          doc['email'] as String,
          '', // We don't store passwords in Firestore
          name: doc['name'] as String?,
        );
      }
    } catch (e) {
      developer.log('Error getting user data: $e');
    }

    return null;
  }

  // Login with email and password
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    } catch (e) {
      developer.log('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(String name, String email, String password, BuildContext context) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update user profile with display name
        await userCredential.user!.updateDisplayName(name);

        // Save additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    } catch (e) {
      developer.log('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: $e')),
      );
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return false; // User canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if this is a new user (first time sign-in)
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          // Save user data to Firestore for new users
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        return true;
      }
      return false;
    } catch (e) {
      developer.log('Google sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign in error: $e')),
      );
      return false;
    }
  }

  // Sign in with Apple
  Future<bool> signInWithApple(BuildContext context) async {
    try {
      // Get Apple ID credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential from the credential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        // Check if this is a new user (first time sign-in)
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        // For Apple Sign In, name might be null or not provided after the first sign-in
        String? fullName;
        if (credential.givenName != null && credential.familyName != null) {
          fullName = '${credential.givenName} ${credential.familyName}';
        }

        if (isNewUser) {
          // Save user data to Firestore for new users
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'name': fullName ?? userCredential.user!.displayName ?? 'Apple User',
            'email': credential.email ?? userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Update display name if available
          if (fullName != null && fullName.isNotEmpty) {
            await userCredential.user!.updateDisplayName(fullName);
          }
        }

        return true;
      }
      return false;
    } catch (e) {
      developer.log('Apple sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple sign in error: $e')),
      );
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Sign out from Google as well
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return currentUser?.email;
  }

  // Update user info
  Future<void> updateUser(app_user.User user) async {
    try {
      if (currentUser != null) {
        // Update user display name if different
        if (user.name != null && user.name != currentUser!.displayName) {
          await currentUser!.updateDisplayName(user.name);
        }

        // Update user data in Firestore
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'name': user.name,
          // Add any other fields that need updating
        });
      }
    } catch (e) {
      developer.log('Update user error: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return currentUser != null;
  }

  // Password reset
  Future<bool> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
      return true;
    } catch (e) {
      developer.log('Password reset error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset error: $e')),
      );
      return false;
    }
  }

  getCurrentUser() {}
}
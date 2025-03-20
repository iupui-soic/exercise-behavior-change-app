import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  // Firebase instances
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Current user
  User? currentUser;

  AuthService._internal();

  // Get users box (keeping for backward compatibility)
  Future<Box<User>> _getUsersBox() async {
    return await Hive.openBox<User>('users');
  }

  // Get current Firebase user
  firebase_auth.User? get firebaseUser => _auth.currentUser;

  // Login with email and password
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      // Attempt Firebase login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        await _fetchAndSetCurrentUser(userCredential.user!.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
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

        // Create a User object with email
        final user = User(email, '');

        // Save user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Set as current user
        currentUser = user;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );

        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
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
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if this is a new user
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          // Save basic user data to Firestore for new users
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // Fetch and set current user
        await _fetchAndSetCurrentUser(userCredential.user!.uid);

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
      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        // Check if this is a new user
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        // For Apple Sign In, name might be null after the first sign-in
        String? fullName;
        if (credential.givenName != null && credential.familyName != null) {
          fullName = '${credential.givenName} ${credential.familyName}';
        }

        if (isNewUser) {
          // Save basic user data to Firestore for new users
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': credential.email ?? userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Update display name if available
          if (fullName != null && fullName.isNotEmpty) {
            await userCredential.user!.updateDisplayName(fullName);
          }
        }

        // Fetch and set current user
        await _fetchAndSetCurrentUser(userCredential.user!.uid);

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

  // Fetch user data from Firestore and set as current user
  Future<void> _fetchAndSetCurrentUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        currentUser = User.fromFirestore(doc);
      } else {
        // If no Firestore data yet, create a basic user from Firebase Auth
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null && firebaseUser.email != null) {
          currentUser = User(firebaseUser.email!, '');
        }
      }
    } catch (e) {
      developer.log('Error fetching user data: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut(); // Sign out from Google as well
      currentUser = null;
    } catch (e) {
      developer.log('Logout error: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return currentUser;
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return firebaseUser?.email ?? currentUser?.email;
  }

  // Update user info
  Future<void> updateUser(User user) async {
    try {
      if (firebaseUser != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(firebaseUser!.uid).update(
            user.toFirestore()
        );

        // Update the current user
        currentUser = user;
      }
    } catch (e) {
      developer.log('Update user error: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return firebaseUser != null;
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
}
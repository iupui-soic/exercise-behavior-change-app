import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../config/app_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Firebase instances
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? currentUser;

  // Google Sign In initialization flag
  bool _isGoogleSignInInitialized = false;

  // Initialize Google Sign In
  Future<void> initializeGoogleSignIn() async {
    if (_isGoogleSignInInitialized) return;

    try {
      // In v7.x, we use the singleton instance and initialize it
      await GoogleSignIn.instance.initialize(
        serverClientId: AppConfig.googleWebClientId,
      );

      _isGoogleSignInInitialized = true;
      developer.log('Google Sign In initialized successfully');
    } catch (e) {
      developer.log('Error initializing Google Sign In: $e');
      rethrow;
    }
  }

  // Get current Firebase user
  firebase_auth.User? get firebaseUser => _auth.currentUser;

  // Auth state stream
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Login with email and password
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await fetchAndSetCurrentUser(userCredential.user!.uid);
        _showSnackBar(context, 'Logged in successfully');
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthException(e, context);
      return false;
    } catch (e) {
      developer.log('Login error: $e');
      _showSnackBar(context, 'Login error: $e');
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(String name, String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);

        // Create user document in Firestore
        final user = User(
          email: email,
          uid: userCredential.user!.uid,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toFirestore());
        currentUser = user;

        _showSnackBar(context, 'Account created successfully');
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthException(e, context);
      return false;
    } catch (e) {
      developer.log('Registration error: $e');
      _showSnackBar(context, 'Registration error: $e');
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      // Initialize Google Sign In if not already done
      if (!_isGoogleSignInInitialized) {
        await initializeGoogleSignIn();
      }

      // Check if the platform supports authentication
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        _showSnackBar(context, 'Google Sign In not supported on this platform');
        return false;
      }

      // Use authenticate method for v7.x
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential - in v7.x, we only use idToken
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _handleNewUser(userCredential);
        await fetchAndSetCurrentUser(userCredential.user!.uid);
        _showSnackBar(context, 'Google sign in successful');
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Google sign in error: $e');
      _showSnackBar(context, 'Google sign in error: $e');
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

      // Create Firebase credential
      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in to Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        // Handle display name for Apple Sign In
        String? fullName;
        if (credential.givenName != null && credential.familyName != null) {
          fullName = '${credential.givenName} ${credential.familyName}';
        }

        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _createUserDocument(
            userCredential.user!.uid,
            credential.email ?? userCredential.user!.email ?? '',
            fullName,
          );

          if (fullName != null) {
            await userCredential.user!.updateDisplayName(fullName);
          }
        }

        await fetchAndSetCurrentUser(userCredential.user!.uid);
        _showSnackBar(context, 'Apple sign in successful');
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Apple sign in error: $e');
      _showSnackBar(context, 'Apple sign in error: $e');
      return false;
    }
  }

  // Helper method to handle new users
  Future<void> _handleNewUser(firebase_auth.UserCredential userCredential) async {
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserDocument(
        userCredential.user!.uid,
        userCredential.user!.email ?? '',
        userCredential.user!.displayName,
      );
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(String uid, String email, String? displayName) async {
    final user = User(
      email: email,
      uid: uid,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(user.toFirestore());
    currentUser = user; // Set the current user immediately
  }

  // Fetch user data from Firestore - NOW PUBLIC
  Future<void> fetchAndSetCurrentUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        currentUser = User.fromFirestore(doc);
        developer.log('User data loaded from Firestore: ${currentUser?.uid}');
      } else {
        // Create basic user if no Firestore document exists
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
          currentUser = User(
            email: firebaseUser.email ?? '',
            uid: firebaseUser.uid,
            createdAt: DateTime.now(),
          );
          // Save this basic user to Firestore
          await _firestore.collection('users').doc(uid).set(currentUser!.toFirestore());
          developer.log('Created basic user document for: ${currentUser?.uid}');
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

      // Sign out from Google as well
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        developer.log('Error signing out from Google: $e');
      }

      currentUser = null;
    } catch (e) {
      developer.log('Logout error: $e');
    }
  }

  // Update user
  Future<void> updateUser(User user) async {
    try {
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser!.uid).update(user.toFirestore());
        currentUser = user;
        developer.log('User updated successfully: ${user.uid}');
      }
    } catch (e) {
      developer.log('Update user error: $e');
      rethrow; // Re-throw to handle in UI
    }
  }

  // Password reset
  Future<bool> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar(context, 'Password reset email sent!');
      return true;
    } catch (e) {
      developer.log('Password reset error: $e');
      _showSnackBar(context, 'Password reset error: $e');
      return false;
    }
  }

  // Utility methods
  User? getCurrentUser() {
    developer.log('getCurrentUser called, current user: ${currentUser?.uid}');
    return currentUser;
  }

  String? getCurrentUserEmail() => firebaseUser?.email ?? currentUser?.email;
  bool isLoggedIn() => firebaseUser != null;

  // Helper method for showing snackbars
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Handle Firebase Auth exceptions
  void _handleAuthException(firebase_auth.FirebaseAuthException e, BuildContext context) {
    String message = 'Authentication failed';

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Wrong password provided.';
        break;
      case 'weak-password':
        message = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists for that email.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }

    _showSnackBar(context, message);
  }
}
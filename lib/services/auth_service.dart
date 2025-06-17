import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // Current user
  User? currentUser;

  // Get users box
  Future<Box<User>> _getUsersBox() async {
    return await Hive.openBox<User>('users');
  }

  // Login with email and password
  Future<bool> login(String email, String password, BuildContext context) async {
    try {
      final userBox = await _getUsersBox();

      // Find user with matching email
      final user = userBox.get(email);

      // Check if user exists
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found with this email.')),
        );
        return false;
      }

      // Check if password matches
      if (user.password == password) {
        currentUser = user;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password.')),
        );
        return false;
      }
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
      final userBox = await _getUsersBox();

      // Check if user already exists
      final bool userExists = userBox.values.any((user) => user.email == email);

      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User with this email already exists')),
        );
        return false;
      }

      // Create and save new user
      final user = User(email, password, name: name);
      await userBox.put(email, user);
      currentUser = user;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      return true;
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Here you would typically get the GoogleSignInAuthentication object
        // and use it to create a GoogleAuthCredential for Firebase

        // For this implementation, we'll just create a User with the email
        final userBox = await _getUsersBox();
        final email = googleUser.email;

        // Check if user exists, if not create one
        User? user = userBox.get(email);
        if (user == null) {
          user = User(email, ''); // Password empty for social auth
          await userBox.put(email, user);
        }

        currentUser = user;
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
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.authorizationCode != null) {
        // Here you would typically use the authorization code to get a session
        // For this implementation, we'll just create a User with the email if provided
        final userBox = await _getUsersBox();
        final email = credential.email ?? 'apple_user@example.com';

        // Check if user exists, if not create one
        User? user = userBox.get(email);
        if (user == null) {
          user = User(email, ''); // Password empty for social auth
          await userBox.put(email, user);
        }

        currentUser = user;
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
    currentUser = null;
  }

  // Get current user
  User? getCurrentUser() {
    return currentUser;
  }

  // Update user info
  Future<void> updateUser(User user) async {
    try {
      final userBox = await _getUsersBox();
      await userBox.put(user.email, user);
      currentUser = user;
    } catch (e) {
      developer.log('Update user error: $e');
    }
  }

  // Reset password
  Future<bool> resetPassword(String email, BuildContext context) async {
    try {
      final userBox = await _getUsersBox();

      // Check if user exists
      final bool userExists = userBox.values.any((user) => user.email == email);

      if (!userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No account found with this email address')),
        );
        return false;
      }

      // In a real app, you would send a password reset email here
      // For this demo, we'll just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset instructions have been sent to your email')),
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
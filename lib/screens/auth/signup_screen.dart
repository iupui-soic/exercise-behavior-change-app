import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import '../onboarding/demographics_screen.dart';
import 'package:exercise_behavior_change_app/screens/auth/login_screen.dart';
import 'package:exercise_behavior_change_app/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Following the pattern from the welcome screen
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top form area
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Let\'s get started!',
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30.0),

                            // Form fields
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Name field
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Name',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),

                                  // Email field
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email Address',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address';
                                      }
                                      final emailRegex = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),

                                  // Password field
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      hintText: 'Password (8+ characters)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacer to push content to top and bottom
                      const Spacer(),

                      // Bottom buttons and login link
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Apple Sign In button
                            AppButton(
                              text: 'Login with Apple',
                              onPressed: () => _handleAppleSignIn(context),
                              isLoading: _isLoading,
                              leadingIcon: const Icon(Icons.apple, color: Colors.black),
                              backgroundColor: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            const SizedBox(height: 10.0),

                            // Google Sign In button
                            AppButton(
                              text: 'Login with Google',
                              onPressed: () => _handleGoogleSignIn(context),
                              isLoading: _isLoading,
                              leadingIcon: const Icon(Icons.android, color: Colors.black),
                              backgroundColor: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            const SizedBox(height: 10.0),

                            // Email Sign In button
                            AppButton(
                              text: 'Sign up with Email',
                              onPressed: () => _handleSignup(context),
                              isLoading: _isLoading,
                              leadingIcon: const Icon(Icons.email, color: Colors.black),
                              backgroundColor: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),

                            // Login link - with margin for safery
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                              child: TextButton(
                                child: const Text(
                                  'Already have an account? Login',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const EmailLoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleSignup(BuildContext context) async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user using Firebase
      final success = await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        context,
      );

      if (success && context.mounted) {
        // Get the current user from Firebase
        final firebaseUser = _authService.firebaseUser;

        if (firebaseUser != null) {
          // Navigate to demographics page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DemographicsScreen(userEmail: _emailController.text),
            ),
          );
        }
      }
    } catch (e) {
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.signInWithApple(context);

      if (success && context.mounted) {
        // Navigate to demographics page if it's a new user or straight to dashboard if returning
        final firebaseUser = _authService.firebaseUser;
        if (firebaseUser != null) {
          // Check if user has completed demographics
          final email = _authService.getCurrentUserEmail() ?? '';

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DemographicsScreen(userEmail: email),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple sign in error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.signInWithGoogle(context);

      if (success && context.mounted) {
        // Navigate to demographics page if it's a new user or straight to dashboard if returning
        final firebaseUser = _authService.firebaseUser;
        if (firebaseUser != null) {
          // Check if user has completed demographics
          final email = _authService.getCurrentUserEmail() ?? '';

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DemographicsScreen(userEmail: email),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign in error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
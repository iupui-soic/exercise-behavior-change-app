import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../onboarding/demographics_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Social login buttons
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppButton(
                    text: 'Login with Apple',
                    onPressed: () {
                      _handleSignInWithApple(context);
                    },
                    leadingIcon: const Icon(Icons.apple, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppButton(
                    text: 'Login with Google',
                    onPressed: () {
                      _handleSignInWithGoogle(context);
                    },
                    leadingIcon: const Icon(Icons.android, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppButton(
                    text: 'Sign up with Email',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    leadingIcon: const Icon(Icons.email, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Login link with EXTRA bottom padding
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmailLoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Already have an account? Login',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignInWithApple(BuildContext context) async {
    final authService = AuthService();
    final success = await authService.signInWithApple(context);

    if (success && context.mounted) {
      await _navigateAfterAuth(context, authService);
    }
  }

  Future<void> _handleSignInWithGoogle(BuildContext context) async {
    final authService = AuthService();
    final success = await authService.signInWithGoogle(context);

    if (success && context.mounted) {
      await _navigateAfterAuth(context, authService);
    }
  }

  Future<void> _navigateAfterAuth(BuildContext context, AuthService authService) async {
    // Get current user data
    final currentUser = authService.getCurrentUser();

    // Check if user has completed onboarding (has demographics data)
    bool hasCompletedOnboarding = currentUser != null &&
        currentUser.gender != null &&
        currentUser.dateOfBirth != null &&
        currentUser.race != null;

    if (hasCompletedOnboarding) {
      // User has completed onboarding, go to dashboard
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
      );
    } else {
      // User needs to complete onboarding
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DemographicsScreen()),
            (route) => false,
      );
    }
  }
}

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email Address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    _handleForgotPassword(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            AppButton(
              text: 'Log in',
              isLoading: _isLoading,
              onPressed: () => _handleLogin(context),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: TextButton(
                    child: const Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = AuthService();
        final success = await authService.login(
          _emailController.text,
          _passwordController.text,
          context,
        );

        if (success && context.mounted) {
          await _navigateAfterAuth(context, authService);
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

  Future<void> _navigateAfterAuth(BuildContext context, AuthService authService) async {
    // Get current user data
    final currentUser = authService.getCurrentUser();

    // Check if user has completed onboarding (has demographics data)
    bool hasCompletedOnboarding = currentUser != null &&
        currentUser.gender != null &&
        currentUser.dateOfBirth != null &&
        currentUser.race != null;

    if (hasCompletedOnboarding) {
      // User has completed onboarding, go to dashboard
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
      );
    } else {
      // User needs to complete onboarding
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const DemographicsScreen()),
            (route) => false,
      );
    }
  }

  void _handleForgotPassword(BuildContext context) async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    final authService = AuthService();
    await authService.resetPassword(_emailController.text, context);
  }

  bool _validateForm() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return false;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return false;
    }
    return true;
  }
}
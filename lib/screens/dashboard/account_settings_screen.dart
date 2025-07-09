import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  bool _isResetPasswordFormVisible = false;
  
  @override
  void initState() {
    super.initState();
    // Pre-fill with current user's email if available
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      _emailController.text = currentUser.email;
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _resetPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }
    
    // Call auth service to reset password
    _authService.resetPassword(_emailController.text, context).then((success) {
      if (success) {
        setState(() {
          _isResetPasswordFormVisible = false;
        });
      }
    });
  }
  
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Log the user out
              _authService.logout();
              
              // Pop the dialog
              Navigator.pop(context);
              
              // Navigate back to login/welcome screen
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/', // Replace with your login/welcome route
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // Code to delete account would go here
              
              // For now, just log out
              _authService.logout();
              
              // Pop the dialog
              Navigator.pop(context);
              
              // Navigate back to login/welcome screen
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/', // Replace with your login/welcome route
                (route) => false,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 16),
              
              // Reset Password section
              Card(
                color: const Color(0xFF1E2021),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 46, 196, 234),
                        ),
                        title: const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        trailing: Icon(
                          _isResetPasswordFormVisible 
                              ? Icons.keyboard_arrow_up 
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            _isResetPasswordFormVisible = !_isResetPasswordFormVisible;
                          });
                        },
                      ),
                      
                      if (_isResetPasswordFormVisible) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Enter your email address to receive password reset instructions:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 46, 196, 234)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Send Reset Instructions',
                              style: TextStyle(fontFamily: 'Outfit'),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              const Text(
                'Account Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 16),
              
              // Logout button
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white70,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Outfit',
                  ),
                ),
                onTap: _logout,
              ),
              
              // Delete account button
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'Outfit',
                  ),
                ),
                onTap: _deleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
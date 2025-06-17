import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Auth service to get and update user data
  final AuthService _authService = AuthService();
  
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isChangingPassword = false;
  
  @override
  void initState() {
    super.initState();
    // Load user data
    _loadUserData();
  }
  
  void _loadUserData() {
    final User? user = _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _emailController.text = user.email;
        _heightFeetController.text = user.heightFeet?.toString() ?? '';
        _heightInchesController.text = user.heightInches?.toString() ?? '';
        _weightController.text = user.weight?.toString() ?? '';
      });
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final User? user = _authService.getCurrentUser();
      
      if (user != null) {
        // Only update email if it has changed
        if (_emailController.text.trim() != user.email) {
          user.email = _emailController.text.trim();
        }
        
        // Update password if user is changing it
        if (_isChangingPassword && _passwordController.text.isNotEmpty) {
          user.password = _passwordController.text;
        }
        
        // Update height and weight
        if (_heightFeetController.text.isNotEmpty) {
          user.heightFeet = int.tryParse(_heightFeetController.text);
        }
        
        if (_heightInchesController.text.isNotEmpty) {
          user.heightInches = int.tryParse(_heightInchesController.text);
        }
        
        if (_weightController.text.isNotEmpty) {
          user.weight = int.tryParse(_weightController.text);
        }
        
        // Save changes
        await _authService.updateUser(user);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context, true); // Return true to indicate changes were made
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final User? user = _authService.getCurrentUser();
    final String? profileImagePath = user?.profileImagePath;

    Future<void> _pickProfileImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && user != null) {
        setState(() {
          user.profileImagePath = pickedFile.path;
        });
        await _authService.updateUser(user);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Toggle for password change
                SwitchListTile(
                  title: const Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white, fontFamily: 'Outfit'),
                  ),
                  value: _isChangingPassword,
                  activeColor: const Color.fromARGB(255, 46, 196, 234),
                  onChanged: (value) {
                    setState(() {
                      _isChangingPassword = value;
                      if (!value) {
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      }
                    });
                  },
                ),
                
                // Password fields (only shown if changing password)
                if (_isChangingPassword) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 46, 196, 234)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (_isChangingPassword) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 46, 196, 234)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (_isChangingPassword) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 32),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 16),
                
                // Height fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightFeetController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Feet'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _heightInchesController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Inches'),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final inches = int.tryParse(value);
                            if (inches == null || inches < 0 || inches > 11) {
                              return 'Invalid inches (0-11)';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Weight field
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Weight (lbs)'),
                ),
                const SizedBox(height: 32),
                
                // Profile image picker
                Center(
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                      backgroundImage: (profileImagePath != null && profileImagePath.isNotEmpty)
                          ? FileImage(File(profileImagePath))
                          : null,
                      child: (profileImagePath == null || profileImagePath.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 196, 234),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16, fontFamily: 'Outfit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 46, 196, 234)),
      ),
    );
  }
} 
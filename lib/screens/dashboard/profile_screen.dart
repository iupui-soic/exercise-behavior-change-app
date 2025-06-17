import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'account_settings_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Get auth service
  final AuthService _authService = AuthService();
  
  // User data
  late User? currentUser;
  
  // Stats
  final int totalWorkouts = 42;
  final int achievementsEarned = 12;
  final double successRate = 87.5;

  @override
  void initState() {
    super.initState();
    // Get current user from auth service
    currentUser = _authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildStats(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildPreferencesSection(),
              const SizedBox(height: 24),
              _buildAppSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final String email = currentUser?.email ?? 'No email';
    final String username = currentUser?.name ?? email.split('@').first;
    final String displayName = username
        .split(RegExp(r'[._-]'))
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
    final String? profileImagePath = currentUser?.profileImagePath;

    Future<void> _pickProfileImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && currentUser != null) {
        setState(() {
          currentUser!.profileImagePath = pickedFile.path;
        });
        await _authService.updateUser(currentUser!);
      }
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
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
          const SizedBox(height: 16),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB6BDCC),
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2021),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.fitness_center,
                value: totalWorkouts.toString(),
                label: 'Total Workouts',
              ),
              _buildStatItem(
                icon: Icons.star,
                value: (currentUser?.workoutPoints ?? 0).toString(),
                label: 'Total Points',
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: '$successRate%',
                label: 'Success Rate',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color.fromARGB(255, 46, 196, 234),
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB6BDCC),
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      items: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () async {
            // Navigate to edit profile screen
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
            
            // If changes were made, refresh the profile screen
            if (result == true) {
              setState(() {
                currentUser = _authService.getCurrentUser();
              });
            }
          },
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Account Settings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountSettingsScreen(),
              ),
            );
          },
        ),
        _buildMenuItem(
          icon: Icons.fitness_center,
          title: 'My Workout History',
          onTap: () {
            // Handle navigation to workout history
          },
        ),
        _buildMenuItem(
          icon: Icons.star_outline,
          title: 'My Achievements',
          onTap: () {
            // Handle navigation to achievements
          },
        ),
        _buildMenuItem(
          icon: Icons.timeline,
          title: 'My Statistics',
          onTap: () {
            // Handle navigation to statistics
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: 'Preferences',
      items: [
        _buildMenuItem(
          icon: Icons.notifications_none,
          title: 'Notifications',
          onTap: () {
            // Handle navigation to notifications settings
          },
        ),
        _buildMenuItem(
          icon: Icons.language,
          title: 'Language',
          value: 'English',
          onTap: () {
            // Handle navigation to language settings
          },
        ),
        _buildMenuItem(
          icon: Icons.accessibility_new,
          title: 'Workout Preferences',
          onTap: () {
            // Handle navigation to workout preferences
          },
        ),
      ],
    );
  }

  Widget _buildAppSection() {
    return _buildSection(
      title: 'App',
      items: [
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {
            // Handle navigation to privacy policy
          },
        ),
        _buildMenuItem(
          icon: Icons.article_outlined,
          title: 'Terms of Use',
          onTap: () {
            // Handle navigation to terms of use
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            // Handle navigation to help and support
          },
        ),
        _buildMenuItem(
          icon: Icons.exit_to_app,
          title: 'Log Out',
          titleColor: Colors.red,
          onTap: () {
            // Handle logout
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2021),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? value,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 46, 196, 234),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 16,
          fontFamily: 'Outfit',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFB6BDCC),
                fontSize: 14,
                fontFamily: 'Outfit',
              ),
            ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFB6BDCC),
            size: 16,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
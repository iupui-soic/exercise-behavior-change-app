import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  // TODO: Default values for stats - these would typically come from a workout/activity service
  final int totalWorkouts = 0; // TODO: This should be fetched from workout history
  final int achievementsEarned = 0; // TODO: This should be fetched from achievements service
  final double successRate = 0.0; // TODO: This should be calculated from workout completion

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error - maybe show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user data: $e')),
        );
      }
    }
  }

  String _formatMemberSince() {
    if (_currentUser?.createdAt != null) {
      final date = _currentUser!.createdAt!;
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[date.month - 1]} ${date.year}';
    }
    return 'Recently';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 46, 196, 234)),
          ),
        ),
      );
    }

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
    final userName = _currentUser?.displayName ?? 'User';
    final userEmail = _currentUser?.email ?? 'No email';
    final memberSince = _formatMemberSince();

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color.fromARGB(255, 46, 196, 234),
            child: _currentUser?.profileImageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                _currentUser!.profileImageUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black,
                  );
                },
              ),
            )
                : Text(
              _currentUser?.initials ?? 'U',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB6BDCC),
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Member since $memberSince',
            style: const TextStyle(
              fontSize: 14,
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
                value: achievementsEarned.toString(),
                label: 'Achievements',
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: '${successRate.toStringAsFixed(1)}%',
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
          onTap: () {
            // Navigate to edit profile screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
          },
        ),
        _buildMenuItem(
          icon: Icons.fitness_center,
          title: 'My Workout History',
          onTap: () {
            // Navigate to workout history screen
          },
        ),
        _buildMenuItem(
          icon: Icons.star_outline,
          title: 'My Achievements',
          onTap: () {
            // Navigate to achievements screen
          },
        ),
        _buildMenuItem(
          icon: Icons.timeline,
          title: 'My Statistics',
          onTap: () {
            // Navigate to statistics screen
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
            // Navigate to notifications settings
          },
        ),
        _buildMenuItem(
          icon: Icons.language,
          title: 'Language',
          value: 'English',
          onTap: () {
            // Navigate to language settings
          },
        ),
        _buildMenuItem(
          icon: Icons.accessibility_new,
          title: 'Workout Preferences',
          onTap: () {
            // Navigate to workout preferences
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
            // Navigate to privacy policy
          },
        ),
        _buildMenuItem(
          icon: Icons.article_outlined,
          title: 'Terms of Use',
          onTap: () {
            // Navigate to terms of use
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            // Navigate to help and support
          },
        ),
        _buildMenuItem(
          icon: Icons.exit_to_app,
          title: 'Log Out',
          titleColor: Colors.red,
          onTap: () {
            _handleLogout();
          },
        ),
      ],
    );
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2021),
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Color(0xFFB6BDCC)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFB6BDCC)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _authService.signOut();
        if (mounted) {
          // Navigate back to login screen
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', // Adjust route name as needed
                (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error logging out: $e')),
          );
        }
      }
    }
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
import 'package:flutter/material.dart';
import '../workout/program_details_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'dart:io';
import '../achievements/achievements_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  User? _currentUser;

  // Pages to display
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Exercise Page')),
    AchievementsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.getCurrentUser();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && _currentUser != null) {
      setState(() {
        _currentUser!.profileImagePath = pickedFile.path;
      });
      await _authService.updateUser(_currentUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // Handle special navigation cases
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgramDetailsScreen()),
        );
      }
    });
  }

  Widget _buildDrawer() {
    final user = _currentUser;
    final String email = user?.email ?? 'No email';
    final String username = email.split('@').first;
    final String displayName = username.isNotEmpty ? username[0].toUpperCase() + username.substring(1) : 'User';
    final String? profileImagePath = user?.profileImagePath;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: (profileImagePath != null && profileImagePath.isNotEmpty)
                        ? FileImage(File(profileImagePath))
                        : null,
                    child: (profileImagePath == null || profileImagePath.isEmpty)
                        ? const Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  displayName,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to notifications
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.20,
        ),
      ),
      onTap: onTap,
    );
  }
}
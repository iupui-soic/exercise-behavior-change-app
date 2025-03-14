import 'package:flutter/material.dart';
import '../workout/program_details_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Pages to display
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Exercise Page')),
    const Center(child: Text('Achievements Page')),
    const ProfileScreen(),
  ];

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  // backgroundImage: AssetImage('assets/profile_photo.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe', // Replace with actual user name
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.fitness_center,
            title: 'Exercise',
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProgramDetailsScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.star,
            title: 'Achievements',
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
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
            icon: Icons.arrow_upward,
            title: 'Above',
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to above
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
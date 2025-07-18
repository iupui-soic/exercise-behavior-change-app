import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import 'connect_friends_screen.dart';

class ExerciseLocationScreen extends StatefulWidget {
  const ExerciseLocationScreen({Key? key}) : super(key: key);

  @override
  _ExerciseLocationScreenState createState() => _ExerciseLocationScreenState();
}

class _ExerciseLocationScreenState extends State<ExerciseLocationScreen> {
  List<String> selectedLocations = [];
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final List<String> availableLocations = ['Home', 'YMCA', 'PlanetFitness'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load existing user data if available
  void _loadUserData() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        selectedLocations = currentUser.exerciseLocations ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise Location',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40.0),

            const Text(
              'Where do you usually exercise?',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            const SizedBox(height: 20.0),

            // Location options
            ListView.builder(
              shrinkWrap: true,
              itemCount: availableLocations.length,
              itemBuilder: (context, index) {
                return _buildLocationButton(availableLocations[index]);
              },
            ),

            const Spacer(),

            // Next button
            AppButton(
              text: 'Next',
              isLoading: _isLoading,
              onPressed: () => _handleNext(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(String location) {
    final isSelected = selectedLocations.contains(location);

    return GestureDetector(
      onTap: () => _toggleLocation(location),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 33, 219, 243)
                : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                color: Color.fromARGB(255, 33, 208, 243),
                size: 16.0,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLocation(String location) {
    setState(() {
      if (selectedLocations.contains(location)) {
        selectedLocations.remove(location);
      } else {
        selectedLocations.add(location);
      }
    });
  }

  Future<void> _handleNext(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        // Create updated user with new exercise locations data
        final updatedUser = currentUser.copyWith(
          exerciseLocations: selectedLocations.isNotEmpty ? selectedLocations : null,
        );

        // Update user in Firebase
        await _authService.updateUser(updatedUser);

        // Navigate to the next screen
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ConnectFriendsScreen(),
            ),
          );
        }
      } else {
        // Handle case where user is null
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User session not found. Please log in again.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving exercise locations: $e')),
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
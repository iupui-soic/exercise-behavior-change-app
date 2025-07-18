import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import 'exercise_location_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> selectedExercises = [];
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Sample exercises for demonstration
  final List<String> exercises = [
    'Pushups',
    'Deadlifts',
    'Lat Pulldown',
    'Crunches',
    'Mountain Climbers',
    'Lunges',
    'Bench Press',
    'Jumping Jacks',
    'Ball Squeeze',
    'Reverse Plank'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load existing user data if available
  void _loadUserData() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        selectedExercises = currentUser.exercisePreferences ?? [];
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
              'Preferences',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Exercise routine entry
            const Text(
              'What does your exercise routine include?',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your preference',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Search exercises
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search exercises',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),

            // Exercise selection
            Wrap(
              spacing: 10.0,
              children: exercises.map((exercise) => _buildExerciseButton(exercise)).toList(),
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

  Widget _buildExerciseButton(String exercise) {
    final bool isSelected = selectedExercises.contains(exercise);

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _toggleExercise(exercise);
        });
      },
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: isSelected ? const Color.fromARGB(255, 50, 223, 236) : Colors.grey,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        exercise,
        style: TextStyle(
          color: isSelected ? const Color.fromARGB(255, 50, 223, 236) : Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  void _toggleExercise(String exercise) {
    if (selectedExercises.contains(exercise)) {
      selectedExercises.remove(exercise);
    } else {
      selectedExercises.add(exercise);
    }
  }

  Future<void> _handleNext(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        // Create updated user with new exercise preferences data
        final updatedUser = currentUser.copyWith(
          exercisePreferences: selectedExercises.isNotEmpty ? selectedExercises : null,
        );

        // Update user in Firebase
        await _authService.updateUser(updatedUser);

        // Navigate to the next screen
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ExerciseLocationScreen(),
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
          SnackBar(content: Text('Error saving preferences: $e')),
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
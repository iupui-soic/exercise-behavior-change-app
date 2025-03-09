import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    try {
      final userBox = await Hive.openBox<User>('users');

      // In a real implementation, you'd get the current user email from somewhere
      // For now, we'll use a placeholder method
      final String? currentUserEmail = await _getCurrentUserEmail();

      if (currentUserEmail != null) {
        final User? user = userBox.get(currentUserEmail);

        if (user != null) {
          // Update the user object with selected preferences
          user.exercisePreferences = selectedExercises;

          // Save the updated user object back to Hive
          await user.save();

          // Navigate to the next page
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExerciseLocationScreen(),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
      }
    }
  }

  // Placeholder method to get current user email
  // In a real implementation, this would come from your auth service
  Future<String?> _getCurrentUserEmail() async {
    // This is a placeholder implementation
    final userBox = await Hive.openBox<User>('users');
    if (userBox.isNotEmpty) {
      return userBox.values.first.email;
    }
    return null;
  }
}
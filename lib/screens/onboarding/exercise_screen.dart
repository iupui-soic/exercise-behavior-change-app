import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';
import '../../widgets/app_button.dart';
import 'preferences_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String selectedTrackingFrequency = '';
  List<String> selectedDays = [];

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

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
              'Exercise',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Tracking frequency selection
            const Text(
              'How often do you track your fitness goals?',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedTrackingFrequency.isEmpty
                    ? null
                    : selectedTrackingFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTrackingFrequency = newValue!;
                  });
                },
                isExpanded: true,
                items: <String>['Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
              ),
            ),

            const SizedBox(height: 20.0),

            // Daily availability selection
            const Text(
              'Select your daily availability:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),

            Expanded(
              child: ListView.builder(
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  final day = daysOfWeek[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildDayButton(day),
                  );
                },
              ),
            ),

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

  Widget _buildDayButton(String day) {
    final bool isSelected = selectedDays.contains(day);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _toggleDay(day);
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.grey.shade800),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isSelected
                  ? Colors.cyanAccent
                  : Colors.grey.shade800,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
                color: isSelected
                    ? const Color.fromARGB(255, 101, 232, 237)
                    : Colors.white),
          ),
          const Text(
            'Select',
            style: TextStyle(
                color: Color.fromARGB(255, 73, 231, 234)),
          ),
        ],
      ),
    );
  }

  void _toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
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
          user.trackingFrequency = selectedTrackingFrequency;
          user.dailyAvailability = selectedDays;

          // Save the updated user object back to Hive
          await user.save();

          // Navigate to the next page
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PreferencesScreen(),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving exercise preferences: $e')),
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
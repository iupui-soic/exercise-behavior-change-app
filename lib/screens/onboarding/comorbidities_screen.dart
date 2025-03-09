import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';
import '../../widgets/app_button.dart';
import 'goals_screen.dart';

class ComorbiditiesScreen extends StatefulWidget {
  const ComorbiditiesScreen({Key? key}) : super(key: key);

  @override
  _ComorbiditiesScreenState createState() => _ComorbiditiesScreenState();
}

class _ComorbiditiesScreenState extends State<ComorbiditiesScreen> {
  bool? hasHealthCondition;
  List<String> selectedHealthConditions = [];

  // Sample health conditions for demo purposes
  final List<String> healthConditions = [
    'Hypertension',
    'Diabetes',
    'Asthma',
    'Heart Disease',
    'Arthritis',
    'Back Pain',
    'Obesity',
    'Depression',
    'Anxiety',
    'Other'
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
              'Comorbidities',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Health conditions question
            const Text(
              'Do you have any health conditions?',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: hasHealthCondition == null
                    ? null
                    : hasHealthCondition!
                    ? 'Yes'
                    : 'No',
                onChanged: (value) {
                  setState(() {
                    hasHealthCondition = value == 'Yes';
                  });
                },
                isExpanded: true,
                items: ['Yes', 'No']
                    .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                underline: Container(),
              ),
            ),

            const SizedBox(height: 20.0),

            // Health conditions selection (shown if Yes is selected)
            if (hasHealthCondition == true) ...[
              const Text(
                'Select appropriate options:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),

              // Search field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search health conditions',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 10.0),

              // Health conditions grid
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: healthConditions
                    .map((condition) => _buildHealthConditionButton(condition))
                    .toList(),
              ),
            ],

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

  Widget _buildHealthConditionButton(String condition) {
    final isSelected = selectedHealthConditions.contains(condition);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          toggleHealthCondition(condition);
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
          side: BorderSide(
            color: isSelected
                ? const Color.fromARGB(255, 33, 233, 243)
                : Colors.transparent,
          ),
        ),
      ),
      child: Text(
        condition,
        style: TextStyle(
          color: isSelected ? Colors.cyan[200] : Colors.white,
        ),
      ),
    );
  }

  void toggleHealthCondition(String condition) {
    if (selectedHealthConditions.contains(condition)) {
      selectedHealthConditions.remove(condition);
    } else {
      selectedHealthConditions.add(condition);
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
          // Update the user object with selected health conditions
          if (hasHealthCondition == true) {
            user.selectedHealthConditions = selectedHealthConditions;
          } else {
            user.selectedHealthConditions = [];
          }

          // Save the updated user object back to Hive
          await user.save();

          // Navigate to the next page
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GoalsScreen(),
              ),
            );
          }
        } else {
          // Handle case where user is null
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User not found')),
            );
          }
        }
      }
    } catch (e) {
      // Handle errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving health conditions: $e')),
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
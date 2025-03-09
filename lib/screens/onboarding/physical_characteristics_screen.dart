import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';
import '../../widgets/app_button.dart';
import 'comorbidities_screen.dart';

class PhysicalCharacteristicsScreen extends StatefulWidget {
  const PhysicalCharacteristicsScreen({Key? key}) : super(key: key);

  @override
  _PhysicalCharacteristicsScreenState createState() => _PhysicalCharacteristicsScreenState();
}

class _PhysicalCharacteristicsScreenState extends State<PhysicalCharacteristicsScreen> {
  int selectedHeightFeet = 0;
  int selectedHeightInches = 0;
  String weightValue = '';
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
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
              'Physical Characteristics',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Height selection
            const Text(
              'Select your height:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: _buildHeightFeetDropdown(),
                  ),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: _buildHeightInchesDropdown(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),

            // Weight selection
            const Text(
              'Select your weight (lbs):',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _weightController,
              onChanged: (value) {
                setState(() {
                  weightValue = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter weight',
                suffixText: 'lbs',
              ),
            ),

            const Spacer(),

            // Next button
            AppButton(
              text: 'Next',
              onPressed: () => _handleNext(context),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightFeetDropdown() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: DropdownButton<int>(
        value: selectedHeightFeet,
        onChanged: (value) {
          setState(() {
            selectedHeightFeet = value!;
          });
        },
        items: List.generate(
          9,
              (index) => DropdownMenuItem<int>(
            value: index,
            child: Text('$index ft'),
          ),
        ),
      ),
    );
  }

  Widget _buildHeightInchesDropdown() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: DropdownButton<int>(
        value: selectedHeightInches,
        onChanged: (value) {
          setState(() {
            selectedHeightInches = value!;
          });
        },
        items: List.generate(
          12,
              (index) => DropdownMenuItem<int>(
            value: index,
            child: Text('$index inches'),
          ),
        ),
      ),
    );
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
          user.heightFeet = selectedHeightFeet;
          user.heightInches = selectedHeightInches;
          if (weightValue.isNotEmpty) {
            user.weight = int.parse(weightValue);
          }
          await user.save();

          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ComorbiditiesScreen(),
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
          SnackBar(content: Text('Error saving physical characteristics: $e')),
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
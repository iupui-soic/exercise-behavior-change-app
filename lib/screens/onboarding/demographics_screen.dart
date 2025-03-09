import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';
import '../../widgets/app_button.dart';
import '../../utils/theme.dart';
import 'physical_characteristics_screen.dart';

class DemographicsScreen extends StatefulWidget {
  final String userEmail;

  const DemographicsScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _DemographicsScreenState createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  String? selectedGender;
  String? selectedDateOfBirth;
  String? selectedRace;
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('User email passed to DemographicsPage: ${widget.userEmail}');

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demographics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Gender selection
            _buildGenderSelection(),
            const SizedBox(height: 20),

            // Date of birth
            _buildDateOfBirthSelection(),
            const SizedBox(height: 20),

            // Race selection
            _buildRaceSelection(),

            const Spacer(),

            // Next button
            AppButton(
              text: 'Next',
              onPressed: () => _handleNext(context),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton('Male'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildGenderButton('Female'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildGenderButton('Other'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    final bool isSelected = selectedGender == gender;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.grey[800]!,
        ),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      child: Text(
        gender,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateOfBirthSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your date of birth:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: _dobController,
          keyboardType: TextInputType.datetime,
          onChanged: (value) {
            selectedDateOfBirth = value;
          },
          decoration: const InputDecoration(
            hintText: 'MM/DD/YYYY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRaceSelection() {
    final List<String> raceOptions = [
      'Asian',
      'Black',
      'Hispanic',
      'White',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Race:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedRace,
          onChanged: (newValue) {
            setState(() {
              selectedRace = newValue;
            });
          },
          items: raceOptions.map((race) {
            return DropdownMenuItem(
              value: race,
              child: Text(race),
            );
          }).toList(),
          decoration: const InputDecoration(
            hintText: 'Select race',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleNext(BuildContext context) async {
    try {
      final userBox = await Hive.openBox<User>('users');
      final User? user = userBox.get(widget.userEmail);

      if (user != null) {
        // Update the demographics data fields in the user object
        user.gender = selectedGender;
        user.dateOfBirth = selectedDateOfBirth;
        user.race = selectedRace;

        // Save the updated user object back to Hive
        await user.save();

        // Navigate to the next page
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PhysicalCharacteristicsScreen(),
            ),
          );
        }
      } else {
        // Handle the case where user is null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found for email: ${widget.userEmail}')),
        );
      }
    } catch (e) {
      // Handle any errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving demographics: $e')),
        );
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import '../../utils/theme.dart';
import 'physical_characteristics_screen.dart';

class DemographicsScreen extends StatefulWidget {
  const DemographicsScreen({Key? key}) : super(key: key);

  @override
  _DemographicsScreenState createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  String? selectedGender;
  String? selectedDateOfBirth;
  String? selectedRace;
  final TextEditingController _dobController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  // Load existing user data if available
  Future<void> _loadUserData() async {
    try {
      // First check if Firebase user exists
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication error. Please log in again.')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return;
      }

      // Fetch user data from Firestore
      await _authService.fetchAndSetCurrentUser(firebaseUser.uid);

      // Get the current user
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        setState(() {
          selectedGender = currentUser.gender;
          selectedDateOfBirth = currentUser.dateOfBirth;
          selectedRace = currentUser.race;
          _dobController.text = currentUser.dateOfBirth ?? '';
        });
      }

    } catch (e) {
      print('Error loading user data: $e');
      // Continue anyway - they can still fill out the form
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUserData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              isLoading: _isLoading,
              onPressed: _isFormValid() ? () => _handleNext(context) : null,
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
            setState(() {
              selectedDateOfBirth = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'MM/DD/YYYY',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          onTap: () async {
            // Optional: Add date picker
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              final formattedDate = '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
              setState(() {
                _dobController.text = formattedDate;
                selectedDateOfBirth = formattedDate;
              });
            }
          },
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

  bool _isFormValid() {
    return selectedGender != null &&
        selectedDateOfBirth != null &&
        selectedDateOfBirth!.isNotEmpty &&
        selectedRace != null;
  }

  Future<void> _handleNext(BuildContext context) async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get Firebase user first
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication error. Please log in again.')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return;
      }

      // Get current user or create new one
      User? currentUser = _authService.getCurrentUser();

      if (currentUser == null) {
        // Create new user if none exists
        currentUser = User(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          gender: selectedGender,
          dateOfBirth: selectedDateOfBirth,
          race: selectedRace,
          createdAt: DateTime.now(),
        );
      } else {
        // Update existing user
        currentUser = currentUser.copyWith(
          gender: selectedGender,
          dateOfBirth: selectedDateOfBirth,
          race: selectedRace,
          updatedAt: DateTime.now(),
        );
      }

      // Update user in Firebase
      await _authService.updateUser(currentUser);

      print('Demographics saved successfully for user: ${firebaseUser.uid}');

      // Navigate to the next screen
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PhysicalCharacteristicsScreen(),
          ),
        );
      }

    } catch (e) {
      print('Error saving demographics: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving demographics: $e')),
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
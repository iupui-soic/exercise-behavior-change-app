import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
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
    _weightController.dispose();
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

      // Fetch user data from Firestore if not already loaded
      if (_authService.getCurrentUser() == null) {
        await _authService.fetchAndSetCurrentUser(firebaseUser.uid);
      }

      final currentUser = _authService.getCurrentUser();
      if (currentUser != null) {
        setState(() {
          selectedHeightFeet = currentUser.heightFeet ?? 0;
          selectedHeightInches = currentUser.heightInches ?? 0;
          if (currentUser.weight != null) {
            weightValue = currentUser.weight.toString();
            _weightController.text = weightValue;
          }
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
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
              isLoading: _isLoading,
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

      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        int? parsedWeight;
        if (weightValue.isNotEmpty) {
          parsedWeight = int.tryParse(weightValue);
          if (parsedWeight == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid weight')),
              );
            }
            return;
          }
        }

        // Create updated user with new physical characteristics data
        final updatedUser = currentUser.copyWith(
          heightFeet: selectedHeightFeet,
          heightInches: selectedHeightInches,
          weight: parsedWeight,
          updatedAt: DateTime.now(),
        );

        // Update user in Firebase
        await _authService.updateUser(updatedUser);

        print('Physical characteristics saved successfully for user: ${firebaseUser.uid}');

        // Navigate to the next screen
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
            const SnackBar(content: Text('User session not found. Please log in again.')),
          );
        }
      }
    } catch (e) {
      print('Error saving physical characteristics: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving physical characteristics: $e')),
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
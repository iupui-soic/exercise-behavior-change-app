import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
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
  List<String> filteredHealthConditions = [];
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Health conditions list
  final List<String> healthConditions = [
    'Hypertension',
    'Diabetes Type 1',
    'Diabetes Type 2',
    'Asthma',
    'Heart Disease',
    'Arthritis',
    'Osteoarthritis',
    'Rheumatoid Arthritis',
    'Back Pain',
    'Chronic Back Pain',
    'Obesity',
    'Depression',
    'Anxiety',
    'High Cholesterol',
    'Thyroid Disorders',
    'COPD',
    'Sleep Apnea',
    'Fibromyalgia',
    'Chronic Fatigue Syndrome',
    'Migraine',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    filteredHealthConditions = healthConditions;
    _loadUserData();
    _searchController.addListener(_filterHealthConditions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load existing user data if available
  void _loadUserData() {
    final currentUser = _authService.getCurrentUser();
    if (currentUser != null && currentUser.selectedHealthConditions != null) {
      setState(() {
        selectedHealthConditions = List<String>.from(currentUser.selectedHealthConditions!);
        hasHealthCondition = selectedHealthConditions.isNotEmpty;
      });
    }
  }

  void _filterHealthConditions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredHealthConditions = healthConditions
          .where((condition) => condition.toLowerCase().contains(query))
          .toList();
    });
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
              'Health Conditions',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),

            // Health conditions question
            const Text(
              'Do you have any health conditions or concerns?',
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
                    if (!hasHealthCondition!) {
                      selectedHealthConditions.clear();
                    }
                  });
                },
                isExpanded: true,
                hint: const Text('Select an option'),
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
                'Select all that apply:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10.0),

              // Search field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search health conditions',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 15.0),

              // Selected conditions count
              if (selectedHealthConditions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${selectedHealthConditions.length} condition(s) selected',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // Health conditions grid
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: filteredHealthConditions
                        .map((condition) => _buildHealthConditionButton(condition))
                        .toList(),
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
            ],

            const SizedBox(height: 20.0),

            // Next button
            AppButton(
              text: 'Next',
              isLoading: _isLoading,
              onPressed: _isFormValid() ? () => _handleNext(context) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionButton(String condition) {
    final isSelected = selectedHealthConditions.contains(condition);

    return GestureDetector(
      onTap: () {
        setState(() {
          toggleHealthCondition(condition);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 33, 233, 243)
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Text(
          condition,
          style: TextStyle(
            color: isSelected ? Colors.cyan[200] : Colors.white,
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void toggleHealthCondition(String condition) {
    setState(() {
      if (selectedHealthConditions.contains(condition)) {
        selectedHealthConditions.remove(condition);
      } else {
        selectedHealthConditions.add(condition);
      }
    });
  }

  bool _isFormValid() {
    return hasHealthCondition != null;
  }

  Future<void> _handleNext(BuildContext context) async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer the health conditions question')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        // Prepare health conditions list
        final List<String> healthConditionsToSave = hasHealthCondition == true
            ? selectedHealthConditions
            : [];

        // Create updated user with selected health conditions
        final updatedUser = currentUser.copyWith(
          selectedHealthConditions: healthConditionsToSave,
        );

        // Update user in Firebase
        await _authService.updateUser(updatedUser);

        // Navigate to the next screen
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
            const SnackBar(content: Text('User session not found. Please log in again.')),
          );
        }
      }
    } catch (e) {
      // Handle errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving health conditions: $e')),
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
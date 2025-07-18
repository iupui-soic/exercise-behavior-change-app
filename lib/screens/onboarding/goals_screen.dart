import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';
import 'exercise_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String selectedFitnessLevel = '';
  String selectedProgram = '';
  List<String> selectedFitnessGoals = [];
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Sample fitness goals for the demo
  final List<String> fitnessGoals = [
    'Improve Strength',
    'Increase Endurance',
    'Gain Muscle',
    'Feel Good',
    'Recover from Injury',
  ];

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
        selectedFitnessLevel = currentUser.fitnessLevel ?? '';
        selectedProgram = currentUser.workoutProgram ?? '';
        selectedFitnessGoals = currentUser.fitnessGoals ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Goals',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),

              // Fitness level section
              const Text(
                'Fitness Level',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  _buildFitnessLevelButton(
                      'Beginner',
                      'People who do not workout regularly'
                  ),
                  const SizedBox(height: 10.0),
                  _buildFitnessLevelButton(
                      'Intermediate',
                      'People who have some experience in workouts'
                  ),
                  const SizedBox(height: 10.0),
                  _buildFitnessLevelButton(
                      'Expert',
                      'People who are experienced and want to push limits'
                  ),
                ],
              ),

              const SizedBox(height: 20.0),

              // Fitness goals section
              const Text(
                'Fitness Goals',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: fitnessGoals.map((goal) {
                  return Column(
                    children: [
                      _buildFitnessGoalButton(goal),
                      const SizedBox(height: 10.0),
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20.0),

              // Programs section
              const Text(
                'Explore standard workout programs',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Choose a workout program from the options',
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 10.0),

              // ACSM Program
              _buildProgramButton(
                'ACSM',
                'American College of Sports Medicine',
                '150 minutes per week',
                'Moderate to vigorous intensity',
                'At least two days of strength training',
                'images/Americancollgeofmedicine.jpg',
              ),

              const SizedBox(height: 15),

              // AMA Program
              _buildProgramButton(
                'AMA',
                'American Heart Association',
                '120 minutes per week',
                'Easy to moderate intensity',
                'At least 3 days of endurance training',
                'images/american_heart_association_logo.png',
              ),

              const SizedBox(height: 20.0),

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
      ),
    );
  }

  Widget _buildFitnessLevelButton(String title, String description) {
    bool isSelected = selectedFitnessLevel == title;

    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFitnessLevel = title;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.cyan : Colors.transparent),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 16.0, color: isSelected ? Colors.cyan : null),
              ),
              const SizedBox(height: 5.0),
              Text(
                description,
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessGoalButton(String goal) {
    bool isSelected = selectedFitnessGoals.contains(goal);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _toggleFitnessGoal(goal);
          });
        },
        style: ButtonStyle(
          overlayColor:
          MaterialStateProperty.all<Color>(Colors.cyan.withOpacity(0.2)),
          side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: isSelected ? Colors.cyan : Colors.transparent)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              goal,
              style: TextStyle(
                  fontSize: 12.0,
                  color: isSelected ? Colors.cyan : Colors.white),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.grey,
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    _toggleFitnessGoal(goal);
                  });
                },
                checkColor: isSelected ? Colors.cyan : Colors.grey,
                activeColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramButton(
      String id,
      String title,
      String timePerWeek,
      String intensity,
      String additionalInfo,
      String imagePath,
      ) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedProgram = id;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 39, 39, 40)),
        side: MaterialStateProperty.resolveWith<BorderSide>((states) {
          return selectedProgram == id
              ? const BorderSide(color: Colors.cyan, width: 2.0)
              : BorderSide.none;
        }),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  timePerWeek,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white),
                ),
                Text(
                  intensity,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white),
                ),
                Text(
                  additionalInfo,
                  style: const TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFitnessGoal(String goal) {
    if (selectedFitnessGoals.contains(goal)) {
      selectedFitnessGoals.remove(goal);
    } else {
      selectedFitnessGoals.add(goal);
    }
  }

  Future<void> _handleNext(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.getCurrentUser();

      if (currentUser != null) {
        // Create updated user with new goals data
        final updatedUser = currentUser.copyWith(
          fitnessLevel: selectedFitnessLevel.isNotEmpty ? selectedFitnessLevel : null,
          fitnessGoals: selectedFitnessGoals.isNotEmpty ? selectedFitnessGoals : null,
          workoutProgram: selectedProgram.isNotEmpty ? selectedProgram : null,
        );

        // Update user in Firebase
        await _authService.updateUser(updatedUser);

        // Navigate to the next screen
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ExerciseScreen(),
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
          SnackBar(content: Text('Error saving goals: $e')),
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
import 'package:flutter/material.dart';
import 'workout_screen.dart';

class WorkoutSelectionScreen extends StatefulWidget {
  const WorkoutSelectionScreen({Key? key}) : super(key: key);

  @override
  _WorkoutSelectionScreenState createState() => _WorkoutSelectionScreenState();
}

class _WorkoutSelectionScreenState extends State<WorkoutSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Workout Duration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How long would you like to work out today?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildDurationButton('15 minutes', const Duration(minutes: 15)),
            const SizedBox(height: 20),
            _buildDurationButton('30 minutes', const Duration(minutes: 30)),
            const SizedBox(height: 20),
            _buildDurationButton('45 minutes', const Duration(minutes: 45)),
            const SizedBox(height: 20),
            _buildDurationButton('60 minutes', const Duration(minutes: 60)),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationButton(String text, Duration duration) {
    return ElevatedButton(
      onPressed: () {
        _startWorkout(context, duration);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(200, 60),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }

  void _startWorkout(BuildContext context, Duration selectedDuration) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutScreen(
          pausedDuration: selectedDuration,
          workoutName: 'Back Workout',
        ),
      ),
    );
  }
}
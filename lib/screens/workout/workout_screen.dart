import 'package:flutter/material.dart';
import 'dart:async';
import 'workout_completion_screen.dart';

class WorkoutScreen extends StatelessWidget {
  final Duration pausedDuration;
  final String workoutName;

  const WorkoutScreen({
    Key? key,
    required this.pausedDuration,
    required this.workoutName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Back to workout',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('$workoutName (${pausedDuration.inMinutes} min)',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PauseStopPage(
                            pausedDuration: pausedDuration,
                            workoutName: workoutName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(50),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: const Text('Start', style: TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PauseStopPage extends StatefulWidget {
  final Duration pausedDuration;
  final String workoutName;

  const PauseStopPage({
    Key? key,
    required this.pausedDuration,
    required this.workoutName,
  }) : super(key: key);

  @override
  _PauseStopPageState createState() => _PauseStopPageState();
}

class _PauseStopPageState extends State<PauseStopPage> {
  late Duration duration;
  late Timer timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    duration = Duration.zero;
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration += const Duration(seconds: 1);
      });
    });
  }

  void handlePause() {
    if (!isPaused) {
      timer.cancel();
      setState(() {
        isPaused = true;
      });
    } else {
      startTimer();
      setState(() {
        isPaused = false;
      });
    }
  }

  void handleStop() {
    timer.cancel();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutCompletionScreen(
          stoppedDuration: duration,
          selectedDuration: widget.pausedDuration,
          workoutName: widget.workoutName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Text(
            _displayTime(duration),
            style: const TextStyle(fontSize: 100, color: Colors.cyan),
          ),
          const SizedBox(height: 20),
          Text(
            widget.workoutName,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: handlePause,
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  iconSize: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 40),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: handleStop,
                  icon: const Icon(Icons.stop),
                  iconSize: 40,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, "0");
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    return '$minutes:$seconds';
  }
}
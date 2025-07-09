import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/achievement_model.dart';
import '../../services/achievement_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../../widgets/app_button.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class WorkoutCompletionScreen extends StatefulWidget {
  final Duration stoppedDuration;
  final Duration selectedDuration;
  final String workoutName;

  const WorkoutCompletionScreen({
    Key? key,
    required this.stoppedDuration,
    required this.selectedDuration,
    required this.workoutName,
  }) : super(key: key);

  @override
  _WorkoutCompletionScreenState createState() =>
      _WorkoutCompletionScreenState();
}

class _WorkoutCompletionScreenState extends State<WorkoutCompletionScreen> {
  final AchievementService _achievementService = AchievementService();
  final AuthService _authService = AuthService();
  int _pointsEarned = 0;

  @override
  void initState() {
    super.initState();
    _updateUserWorkoutData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowAchievements();
      if (widget.stoppedDuration < widget.selectedDuration) {
        _showFeedbackModal();
      }
    });
  }

  Future<void> _updateUserWorkoutData() async {
    // Calculate points
    final points = (widget.stoppedDuration.inMinutes * 10).toInt();
    setState(() {
      _pointsEarned = points;
    });

    // Update user's total points
    final User? currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      currentUser.workoutPoints = (currentUser.workoutPoints ?? 0) + points;
      await _authService.updateUser(currentUser);
    }
  }

  void _checkAndShowAchievements() async {
    List<Achievement> unlockedAchievements =
        await _achievementService.unlockAchievements(widget.stoppedDuration);

    if (unlockedAchievements.isNotEmpty && mounted) {
      // Calculate points from achievements
      int achievementPoints = unlockedAchievements.fold(0, (sum, a) => sum + a.points);

      // Update user's total points
      final User? currentUser = _authService.getCurrentUser();
      if (currentUser != null) {
        currentUser.workoutPoints = (currentUser.workoutPoints ?? 0) + achievementPoints;
        await _authService.updateUser(currentUser);
      }
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Achievement Unlocked!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...unlockedAchievements
                    .map((a) => ListTile(
                          leading: Icon(a.icon, color: Colors.amber),
                          title: Text(a.title),
                          subtitle: Text(a.description),
                          trailing: Text('+${a.points} pts'),
                        ))
                    .toList(),
                const SizedBox(height: 16),
                Text(
                  'Total Achievement Points: +$achievementPoints',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Awesome!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showFeedbackModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalFeedbackScreen(
          stoppedDuration: widget.stoppedDuration,
          selectedDuration: widget.selectedDuration,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool completed = widget.stoppedDuration >= widget.selectedDuration;
    bool endedEarly = widget.stoppedDuration < widget.selectedDuration;

    // Calculate success rate percentage
    double successRate = endedEarly
        ? (widget.stoppedDuration.inSeconds /
                widget.selectedDuration.inSeconds) *
            100
        : 100.0;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today - ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Workout title
            Text(
              'Today\'s ${widget.workoutName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Workout stats - Time and Points
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayTime(widget.stoppedDuration),
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Time', style: TextStyle(color: Colors.white)),
                  ],
                ),

                // Points
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$_pointsEarned',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: endedEarly ? Colors.red : Colors.blue,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: endedEarly ? Colors.red : Colors.blue,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text('Points Earned', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Workout details - Goal, Status, Success Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Goal time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayTime(widget.selectedDuration),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Goal', style: TextStyle(color: Colors.white)),
                  ],
                ),

                // Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      endedEarly ? 'Ended Early' : 'Workout Completed',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text('Status', style: TextStyle(color: Colors.white)),
                  ],
                ),

                // Success Rate
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${successRate.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Success Rate %',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Back to Dashboard button
            AppButton(
              text: 'Back to Dashboard',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _displayTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, "0");
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    return '$minutes:$seconds';
  }
}

class ModalFeedbackScreen extends StatefulWidget {
  final Duration stoppedDuration;
  final Duration selectedDuration;

  const ModalFeedbackScreen({
    Key? key,
    required this.stoppedDuration,
    required this.selectedDuration,
  }) : super(key: key);

  @override
  _ModalFeedbackScreenState createState() => _ModalFeedbackScreenState();
}

class _ModalFeedbackScreenState extends State<ModalFeedbackScreen> {
  List<String> selectedOptions = [];
  bool showMoreOptions = false;
  bool thumbsUpSelected = false;
  bool thumbsDownSelected = false;

  final List<String> feedbackOptions = [
    'Tired',
    'Equipment Issue',
    'Injured',
    'Equipment Not Found',
    'Not enough time',
    'Too difficult',
    'Too easy',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workout Ended Early',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'We see that the workout has ended early. How did you do?',
              ),
              const SizedBox(height: 20),

              // Thumbs up/down selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        thumbsUpSelected = !thumbsUpSelected;
                        thumbsDownSelected = false;
                        showMoreOptions = thumbsUpSelected;
                      });
                    },
                    icon: const Icon(Icons.thumb_up),
                    iconSize: 40,
                    color: thumbsUpSelected ? Colors.cyan : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        thumbsDownSelected = !thumbsDownSelected;
                        thumbsUpSelected = false;
                        showMoreOptions = thumbsDownSelected;
                      });
                    },
                    icon: const Icon(Icons.thumb_down),
                    iconSize: 40,
                    color: thumbsDownSelected ? Colors.cyan : Colors.grey,
                  ),
                ],
              ),

              // Additional options if thumbs up/down selected
              if (showMoreOptions) ...[
                const SizedBox(height: 20),
                const Text('Tell us more'),
                const SizedBox(height: 10),

                // Feedback options
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: feedbackOptions.map((option) => _buildOption(option)).toList(),
                ),

                const SizedBox(height: 20),

                // Submit button
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Submit',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    bool isSelected = selectedOptions.contains(option);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedOptions.remove(option);
          } else {
            selectedOptions.add(option);
          }
        });
      },
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>((states) {
          return isSelected
              ? const BorderSide(color: Colors.cyan, width: 2.0)
              : BorderSide.none;
        }),
      ),
      child: Text(
        option,
        style: TextStyle(color: isSelected ? Colors.cyan : Colors.white),
      ),
    );
  }
}
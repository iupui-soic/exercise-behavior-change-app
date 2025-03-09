import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dashboard/dashboard_screen.dart';
import '../../widgets/app_button.dart';

class WorkoutCompletionScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool completed = stoppedDuration >= selectedDuration;
    bool endedEarly = stoppedDuration < selectedDuration;

    // Calculate success rate percentage
    double successRate = endedEarly
        ? (stoppedDuration.inSeconds / selectedDuration.inSeconds) * 100
        : 100.0;

    if (endedEarly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ModalFeedbackScreen(
              stoppedDuration: stoppedDuration,
              selectedDuration: selectedDuration,
            );
          },
        );
      });
    }

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
              'Today\'s $workoutName',
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
                      _displayTime(stoppedDuration),
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
                          '100',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: endedEarly ? Colors.red : Colors.blue,
                          ),
                        ),
                        Icon(
                          completed ? Icons.arrow_upward : Icons.arrow_downward,
                          color: endedEarly ? Colors.red : Colors.blue,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text('Points', style: TextStyle(color: Colors.white)),
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
                      _displayTime(selectedDuration),
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
import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import 'workout_selection_screen.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: ShapeDecoration(
              color: const Color(0xFF1E2021),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Program image and description
                SizedBox(
                  width: double.infinity,
                  height: 314.91,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Program image
                      Container(
                        width: 334,
                        height: 220.91,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("images/ExercisePic.png"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Program title and description
                      Container(
                        width: double.infinity,
                        height: 72,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Built by Science',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFE9ECF5),
                                fontSize: 15,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                                height: 0.11,
                                letterSpacing: 0.20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                              'This two-week program is all about higher reps and short rest periods to help you build a ... ',
                                              style: TextStyle(
                                                color: Color(0xFFB6BDCC),
                                                fontSize: 12,
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                letterSpacing: 0.20,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'View more',
                                              style: TextStyle(
                                                color: Color(0xFFB6BDCC),
                                                fontSize: 12,
                                                fontFamily: 'Outfit',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: 0.20,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Exercise overview
                Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1E2021),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Exercise overview',
                          style: TextStyle(
                            color: Color(0xFFE9ECF5),
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            height: 0.11,
                            letterSpacing: 0.20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                      height: 0.08,
                                      letterSpacing: -0.20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Total Workouts',
                                    style: TextStyle(
                                      color: Color(0xFFB6BDCC),
                                      fontSize: 10,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                      height: 0.08,
                                      letterSpacing: -0.20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Number of weeks',
                                    style: TextStyle(
                                      color: Color(0xFFB6BDCC),
                                      fontSize: 10,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Moderate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                      height: 0.08,
                                      letterSpacing: -0.20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Intensity',
                                    style: TextStyle(
                                      color: Color(0xFFB6BDCC),
                                      fontSize: 10,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Avg. exercise duration',
                              style: TextStyle(
                                color: Color(0xFFB6BDCC),
                                fontSize: 12,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                height: 0.17,
                              ),
                            ),
                            Text(
                              '32 mins',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                height: 0.17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Equipment',
                              style: TextStyle(
                                color: Color(0xFFB6BDCC),
                                fontSize: 12,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                height: 0.17,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Required',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w500,
                                    height: 0.17,
                                  ),
                                ),
                                Container(
                                  width: 16,
                                  height: 16,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exercise category',
                              style: TextStyle(
                                color: Color(0xFFB6BDCC),
                                fontSize: 12,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                height: 0.17,
                              ),
                            ),
                            Text(
                              'Build muscle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w500,
                                height: 0.17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),

                // Workout schedule
                Container(
                  width: 366,
                  height: 382.91,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1E2021),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 334.91,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 52,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Workout schedule',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFE9ECF5),
                                      fontSize: 18,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                      height: 0.11,
                                      letterSpacing: 0.20,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tap a date to see workout program details',
                                          style: TextStyle(
                                            color: Color(0xFFB6BDCC),
                                            fontSize: 12,
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w400,
                                            height: 0.11,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 266.91,
                              decoration: ShapeDecoration(
                                color: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text('Calendar will appear here'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'You can select the start date when you start the program.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // Done button
                AppButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WorkoutSelectionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
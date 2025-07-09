import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import 'workout_selection_screen.dart';
import 'package:table_calendar/table_calendar.dart';

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
                  height: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        height: 260,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 40,
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
                                      fontSize: 14,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                      height: 0.11,
                                      letterSpacing: 0.20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
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
                                            fontSize: 10,
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
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: ShapeDecoration(
                                color: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _ProgramCalendar(),
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

// Simple calendar widget for program details
class _ProgramCalendar extends StatefulWidget {
  @override
  State<_ProgramCalendar> createState() => _ProgramCalendarState();
}

class _ProgramCalendarState extends State<_ProgramCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example: 10 workout days over 2 weeks, starting from next Monday
  late final List<DateTime> _workoutDays;
  late final Map<DateTime, List<String>> _events;

  @override
  void initState() {
    super.initState();
    _workoutDays = _generateWorkoutDays();
    _events = { for (var d in _workoutDays) d: ['Workout'] };
    // Set initial calendar format to make it smaller
    _calendarFormat = CalendarFormat.month;
  }

  List<DateTime> _generateWorkoutDays() {
    // Find next Monday
    DateTime start = DateTime.now();
    while (start.weekday != DateTime.monday) {
      start = start.add(const Duration(days: 1));
    }
    // Only generate a manageable number of workouts
    List<DateTime> days = [];
    // Just show one week of workouts to keep the calendar compact
    for (int day = 0; day < 5; day++) {
      days.add(start.add(Duration(days: day)));
    }
    return days;
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // Only allow scrolling if really needed
      child: Container(
        height: 200, // Fixed height
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            if (_getEventsForDay(selectedDay).isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Workout Day'),
                  content: Text('You have a workout scheduled on ${selectedDay.toLocal().toString().split(' ')[0]}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          // Use minimal settings
          calendarStyle: const CalendarStyle(
            isTodayHighlighted: false, // Disable today highlighting
            defaultTextStyle: TextStyle(fontSize: 9),
            weekendTextStyle: TextStyle(fontSize: 9),
            outsideTextStyle: TextStyle(fontSize: 9, color: Colors.grey),
            cellMargin: EdgeInsets.all(0.5),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontSize: 12),
            leftChevronIcon: Icon(Icons.chevron_left, size: 14),
            rightChevronIcon: Icon(Icons.chevron_right, size: 14),
            headerPadding: EdgeInsets.symmetric(vertical: 4),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontSize: 9),
            weekendStyle: TextStyle(fontSize: 9),
          ),
          rowHeight: 24,
          daysOfWeekHeight: 15,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
        ),
      ),
    );
  }
}
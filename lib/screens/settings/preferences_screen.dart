import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_preferences_provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<String> _workoutTypes = [
    'Cardio',
    'Strength',
    'Flexibility',
    'Balance',
    'HIIT',
    'Yoga',
    'Other'
  ];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> _fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserPreferencesProvider>().loadPreferences();
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final provider = context.read<UserPreferencesProvider>();
    final preferences = provider.preferences;
    if (preferences == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: preferences.preferredWorkoutTime,
    );

    if (picked != null && picked != preferences.preferredWorkoutTime) {
      await provider.updatePreferences(preferredWorkoutTime: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Consumer<UserPreferencesProvider>(
        builder: (context, provider, child) {
          final preferences = provider.preferences;
          if (preferences == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Days',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _daysOfWeek.map((day) {
                    final isSelected = preferences.availableDays.contains(day);
                    return FilterChip(
                      label: Text(day),
                      selected: isSelected,
                      onSelected: (selected) {
                        final updatedDays = List<String>.from(preferences.availableDays);
                        if (selected) {
                          updatedDays.add(day);
                        } else {
                          updatedDays.remove(day);
                        }
                        provider.updatePreferences(availableDays: updatedDays);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Preferred Workout Types',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _workoutTypes.map((type) {
                    final isSelected = preferences.preferredWorkoutTypes.contains(type);
                    return FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        final updatedTypes = List<String>.from(preferences.preferredWorkoutTypes);
                        if (selected) {
                          updatedTypes.add(type);
                        } else {
                          updatedTypes.remove(type);
                        }
                        provider.updatePreferences(preferredWorkoutTypes: updatedTypes);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ListTile(
                  title: const Text('Preferred Workout Time'),
                  subtitle: Text(preferences.preferredWorkoutTime.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Target Workouts per Week'),
                  subtitle: Slider(
                    value: preferences.targetWorkoutsPerWeek.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    label: preferences.targetWorkoutsPerWeek.toString(),
                    onChanged: (value) {
                      provider.updatePreferences(
                        targetWorkoutsPerWeek: value.round(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Target Workout Duration (minutes)'),
                  subtitle: Slider(
                    value: preferences.targetWorkoutDuration.toDouble(),
                    min: 15,
                    max: 120,
                    divisions: 7,
                    label: preferences.targetWorkoutDuration.toString(),
                    onChanged: (value) {
                      provider.updatePreferences(
                        targetWorkoutDuration: value.round(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Receive Reminders'),
                  trailing: Switch(
                    value: preferences.receiveReminders,
                    onChanged: (value) {
                      provider.updatePreferences(receiveReminders: value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Fitness Level'),
                  trailing: DropdownButton<String>(
                    value: preferences.fitnessLevel,
                    items: _fitnessLevels.map((level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        provider.updatePreferences(fitnessLevel: value);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/workout_event.dart';
import '../services/workout_service.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutService _workoutService = WorkoutService();
  Map<DateTime, List<WorkoutEvent>> _events = {};
  List<WorkoutEvent> _selectedDayEvents = [];
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<WorkoutEvent>> get events => _events;
  List<WorkoutEvent> get selectedDayEvents => _selectedDayEvents;
  DateTime get selectedDay => _selectedDay;

  Future<void> loadEvents(DateTime date) async {
    try {
      final events = await _workoutService.getWorkoutsForDate(date);
      _selectedDayEvents = events;
      _selectedDay = date;
      
      // Update the events map for the calendar
      final startOfMonth = DateTime(date.year, date.month, 1);
      final endOfMonth = DateTime(date.year, date.month + 1, 0);
      
      // Get all workouts for the current month
      final monthEvents = await _workoutService.getWorkoutsForDateRange(startOfMonth, endOfMonth);
      
      // Group events by date
      _events = {};
      for (var event in monthEvents) {
        final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
        if (!_events.containsKey(eventDate)) {
          _events[eventDate] = [];
        }
        _events[eventDate]!.add(event);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  Future<void> addWorkout(WorkoutEvent workout) async {
    try {
      await _workoutService.addWorkout(workout);
      await loadEvents(_selectedDay);
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

  Future<void> updateWorkout(WorkoutEvent workout) async {
    try {
      await _workoutService.updateWorkout(workout);
      await loadEvents(_selectedDay);
    } catch (e) {
      print('Error updating workout: $e');
      rethrow;
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _workoutService.deleteWorkout(workoutId);
      await loadEvents(_selectedDay);
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }

  Future<void> markWorkoutAsCompleted(String workoutId) async {
    try {
      await _workoutService.markWorkoutAsCompleted(workoutId);
      await loadEvents(_selectedDay);
    } catch (e) {
      print('Error marking workout as completed: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWorkoutStats() async {
    try {
      return await _workoutService.getWorkoutStats();
    } catch (e) {
      print('Error getting workout stats: $e');
      rethrow;
    }
  }
} 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_event.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  // Get all workout events for a specific date
  Future<List<WorkoutEvent>> getWorkoutsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThan: endOfDay.toIso8601String())
          .get();

      return snapshot.docs
          .map((doc) => WorkoutEvent.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting workouts: $e');
      return [];
    }
  }

  // Get all workout events for a date range
  Future<List<WorkoutEvent>> getWorkoutsForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThan: endDate.add(const Duration(days: 1)).toIso8601String())
          .get();

      return snapshot.docs
          .map((doc) => WorkoutEvent.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting workouts for date range: $e');
      return [];
    }
  }

  // Add a new workout event
  Future<void> addWorkout(WorkoutEvent workout) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .doc(workout.id)
          .set(workout.toJson());
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

  // Update an existing workout event
  Future<void> updateWorkout(WorkoutEvent workout) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .doc(workout.id)
          .update(workout.toJson());
    } catch (e) {
      print('Error updating workout: $e');
      rethrow;
    }
  }

  // Delete a workout event
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .doc(workoutId)
          .delete();
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }

  // Mark a workout as completed
  Future<void> markWorkoutAsCompleted(String workoutId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .doc(workoutId)
          .update({'isCompleted': true});
    } catch (e) {
      print('Error marking workout as completed: $e');
      rethrow;
    }
  }

  // Get workout statistics
  Future<Map<String, dynamic>> getWorkoutStats() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('workouts')
          .get();

      final workouts = snapshot.docs
          .map((doc) => WorkoutEvent.fromJson(doc.data()))
          .toList();

      final totalWorkouts = workouts.length;
      final completedWorkouts =
          workouts.where((workout) => workout.isCompleted).length;
      final totalDuration = workouts.fold<int>(
          0, (sum, workout) => sum + workout.duration);

      return {
        'totalWorkouts': totalWorkouts,
        'completedWorkouts': completedWorkouts,
        'totalDuration': totalDuration,
        'completionRate': totalWorkouts > 0
            ? (completedWorkouts / totalWorkouts) * 100
            : 0,
      };
    } catch (e) {
      print('Error getting workout stats: $e');
      return {
        'totalWorkouts': 0,
        'completedWorkouts': 0,
        'totalDuration': 0,
        'completionRate': 0,
      };
    }
  }
} 
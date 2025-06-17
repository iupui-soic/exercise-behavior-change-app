import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_preferences.dart';

class UserPreferencesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserPreferences? _preferences;

  UserPreferences? get preferences => _preferences;

  String get userId => _auth.currentUser?.uid ?? '';

  Future<void> loadPreferences() async {
    if (userId.isEmpty) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .get();

      if (doc.exists) {
        _preferences = UserPreferences.fromJson(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    if (userId.isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .set(preferences.toJson());

      _preferences = preferences;
      notifyListeners();
    } catch (e) {
      print('Error saving preferences: $e');
      rethrow;
    }
  }

  Future<void> updatePreferences({
    List<String>? availableDays,
    String? trackingFrequency,
    List<String>? preferredWorkoutTypes,
    int? targetWorkoutsPerWeek,
    int? targetWorkoutDuration,
    bool? receiveReminders,
    TimeOfDay? preferredWorkoutTime,
    String? fitnessLevel,
  }) async {
    if (_preferences == null) return;

    final updatedPreferences = _preferences!.copyWith(
      availableDays: availableDays,
      trackingFrequency: trackingFrequency,
      preferredWorkoutTypes: preferredWorkoutTypes,
      targetWorkoutsPerWeek: targetWorkoutsPerWeek,
      targetWorkoutDuration: targetWorkoutDuration,
      receiveReminders: receiveReminders,
      preferredWorkoutTime: preferredWorkoutTime,
      fitnessLevel: fitnessLevel,
    );

    await savePreferences(updatedPreferences);
  }

  Future<void> initializeDefaultPreferences() async {
    if (userId.isEmpty) return;

    final defaultPreferences = UserPreferences(
      userId: userId,
      availableDays: ['Monday', 'Wednesday', 'Friday'],
      trackingFrequency: 'Weekly',
      preferredWorkoutTypes: ['Cardio', 'Strength'],
      targetWorkoutsPerWeek: 3,
      targetWorkoutDuration: 30,
      receiveReminders: true,
      preferredWorkoutTime: const TimeOfDay(hour: 8, minute: 0),
      fitnessLevel: 'Beginner',
    );

    await savePreferences(defaultPreferences);
  }
} 
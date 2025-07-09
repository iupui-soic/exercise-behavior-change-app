import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 1)
class UserPreferences {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final List<String> availableDays;

  @HiveField(2)
  final String trackingFrequency;

  @HiveField(3)
  final List<String> preferredWorkoutTypes;

  @HiveField(4)
  final int targetWorkoutsPerWeek;

  @HiveField(5)
  final int targetWorkoutDuration;

  @HiveField(6)
  final bool receiveReminders;

  @HiveField(7)
  final TimeOfDay preferredWorkoutTime;

  @HiveField(8)
  final String fitnessLevel;

  UserPreferences({
    required this.userId,
    required this.availableDays,
    required this.trackingFrequency,
    required this.preferredWorkoutTypes,
    required this.targetWorkoutsPerWeek,
    required this.targetWorkoutDuration,
    required this.receiveReminders,
    required this.preferredWorkoutTime,
    required this.fitnessLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'availableDays': availableDays,
      'trackingFrequency': trackingFrequency,
      'preferredWorkoutTypes': preferredWorkoutTypes,
      'targetWorkoutsPerWeek': targetWorkoutsPerWeek,
      'targetWorkoutDuration': targetWorkoutDuration,
      'receiveReminders': receiveReminders,
      'preferredWorkoutTime': {
        'hour': preferredWorkoutTime.hour,
        'minute': preferredWorkoutTime.minute,
      },
      'fitnessLevel': fitnessLevel,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'],
      availableDays: List<String>.from(json['availableDays']),
      trackingFrequency: json['trackingFrequency'],
      preferredWorkoutTypes: List<String>.from(json['preferredWorkoutTypes']),
      targetWorkoutsPerWeek: json['targetWorkoutsPerWeek'],
      targetWorkoutDuration: json['targetWorkoutDuration'],
      receiveReminders: json['receiveReminders'],
      preferredWorkoutTime: TimeOfDay(
        hour: json['preferredWorkoutTime']['hour'],
        minute: json['preferredWorkoutTime']['minute'],
      ),
      fitnessLevel: json['fitnessLevel'],
    );
  }

  UserPreferences copyWith({
    String? userId,
    List<String>? availableDays,
    String? trackingFrequency,
    List<String>? preferredWorkoutTypes,
    int? targetWorkoutsPerWeek,
    int? targetWorkoutDuration,
    bool? receiveReminders,
    TimeOfDay? preferredWorkoutTime,
    String? fitnessLevel,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      availableDays: availableDays ?? this.availableDays,
      trackingFrequency: trackingFrequency ?? this.trackingFrequency,
      preferredWorkoutTypes: preferredWorkoutTypes ?? this.preferredWorkoutTypes,
      targetWorkoutsPerWeek: targetWorkoutsPerWeek ?? this.targetWorkoutsPerWeek,
      targetWorkoutDuration: targetWorkoutDuration ?? this.targetWorkoutDuration,
      receiveReminders: receiveReminders ?? this.receiveReminders,
      preferredWorkoutTime: preferredWorkoutTime ?? this.preferredWorkoutTime,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    );
  }
} 
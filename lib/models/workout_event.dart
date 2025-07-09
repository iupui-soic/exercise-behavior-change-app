import 'package:flutter/material.dart';

class WorkoutEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String type;
  final int duration;
  final bool isCompleted;

  WorkoutEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.type,
    required this.duration,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'type': type,
      'duration': duration,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutEvent.fromJson(Map<String, dynamic> json) {
    return WorkoutEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      time: TimeOfDay(
        hour: json['time']['hour'] as int,
        minute: json['time']['minute'] as int,
      ),
      type: json['type'] as String,
      duration: json['duration'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  WorkoutEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    String? type,
    int? duration,
    bool? isCompleted,
  }) {
    return WorkoutEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/achievement_model.dart';

class AchievementService {
  static const String _boxName = 'achievements';

  Future<void> initAchievements() async {
    final box = await Hive.openBox<Achievement>(_boxName);
    if (box.isEmpty) {
      final allAchievements = _getAllAchievements();
      for (var achievement in allAchievements) {
        box.put(achievement.title, achievement);
      }
    }
  }

  Future<List<Achievement>> getAchievements() async {
    final box = await Hive.openBox<Achievement>(_boxName);
    return box.values.toList();
  }

  Future<List<Achievement>> unlockAchievements(Duration workoutDuration) async {
    final box = await Hive.openBox<Achievement>(_boxName);
    List<Achievement> newlyUnlocked = [];

    final achievementsToUpdate = <Achievement>[];

    for (var achievement in box.values) {
      if (!achievement.isUnlocked) {
        bool unlocked = false;
        if (achievement.title == 'First Steps' && workoutDuration.inMinutes >= 1) {
          unlocked = true;
        } else if (achievement.title == 'Quick 5' && workoutDuration.inMinutes >= 5) {
          unlocked = true;
        } else if (achievement.title == 'Steady 7' && workoutDuration.inMinutes >= 7) {
          unlocked = true;
        } else if (achievement.title == 'Tenacious 10' && workoutDuration.inMinutes >= 10) {
          unlocked = true;
        } else if (achievement.title == 'Fierce 15' && workoutDuration.inMinutes >= 15) {
          unlocked = true;
        } else if (achievement.title == 'Vigorous 20' && workoutDuration.inMinutes >= 20) {
          unlocked = true;
        } else if (achievement.title == 'Half-Hour Hero' && workoutDuration.inMinutes >= 30) {
          unlocked = true;
        } else if (achievement.title == 'Focused 45' && workoutDuration.inMinutes >= 45) {
          unlocked = true;
        } else if (achievement.title == 'Hour of Power' && workoutDuration.inMinutes >= 60) {
          unlocked = true;
        } else if (achievement.title == 'Endurance Expert' && workoutDuration.inMinutes >= 90) {
          unlocked = true;
        }

        if (unlocked) {
          achievement.isUnlocked = true;
          achievementsToUpdate.add(achievement);
          newlyUnlocked.add(achievement);
        }
      }
    }

    for(var achievement in achievementsToUpdate) {
      await box.put(achievement.title, achievement);
    }

    return newlyUnlocked;
  }

  List<Achievement> _getAllAchievements() {
    return [
      Achievement(
        title: 'First Steps',
        description: 'Complete a 1-minute workout.',
        iconCodePoint: Icons.run_circle_outlined.codePoint,
        points: 10),
      Achievement(
        title: 'Quick 5',
        description: 'Complete a 5-minute workout.',
        iconCodePoint: Icons.timer_3_outlined.codePoint,
        points: 25),
      Achievement(
        title: 'Steady 7',
        description: 'Complete a 7-minute workout.',
        iconCodePoint: Icons.timer_10_outlined.codePoint,
        points: 35),
      Achievement(
        title: 'Tenacious 10',
        description: 'Complete a 10-minute workout.',
        iconCodePoint: Icons.whatshot.codePoint,
        points: 50),
      Achievement(
        title: 'Fierce 15',
        description: 'Complete a 15-minute workout.',
        iconCodePoint: Icons.directions_bike.codePoint,
        points: 75),
      Achievement(
        title: 'Vigorous 20',
        description: 'Complete a 20-minute workout.',
        iconCodePoint: Icons.pool.codePoint,
        points: 100),
      Achievement(
        title: 'Half-Hour Hero',
        description: 'Complete a 30-minute workout.',
        iconCodePoint: Icons.self_improvement.codePoint,
        points: 150),
      Achievement(
        title: 'Focused 45',
        description: 'Complete a 45-minute workout.',
        iconCodePoint: Icons.bolt.codePoint,
        points: 225),
      Achievement(
        title: 'Hour of Power',
        description: 'Complete a 60-minute workout.',
        iconCodePoint: Icons.local_fire_department.codePoint,
        points: 300),
      Achievement(
        title: 'Endurance Expert',
        description: 'Complete a 90-minute workout.',
        iconCodePoint: Icons.shield.codePoint,
        points: 450),
    ];
  }
} 
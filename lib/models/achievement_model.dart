import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 1)
class Achievement {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  // IconData is not directly storable in Hive. We will store a placeholder and handle it in the service.
  // For simplicity here, we'll make it non-persistent for now, but a better way is to store a string and map it to an icon.
  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  bool isUnlocked;

  @HiveField(4)
  final int points;

  Achievement({
    required this.title,
    required this.description,
    required this.iconCodePoint,
    this.isUnlocked = false,
    required this.points,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
} 
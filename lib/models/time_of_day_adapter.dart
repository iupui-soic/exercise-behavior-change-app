import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 2;

  @override
  TimeOfDay read(BinaryReader reader) {
    final map = reader.readMap();
    return TimeOfDay(
      hour: map['hour'] as int,
      minute: map['minute'] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeMap({
      'hour': obj.hour,
      'minute': obj.minute,
    });
  }
} 
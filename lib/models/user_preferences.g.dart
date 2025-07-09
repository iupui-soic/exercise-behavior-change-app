// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 1;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      userId: fields[0] as String,
      availableDays: (fields[1] as List).cast<String>(),
      trackingFrequency: fields[2] as String,
      preferredWorkoutTypes: (fields[3] as List).cast<String>(),
      targetWorkoutsPerWeek: fields[4] as int,
      targetWorkoutDuration: fields[5] as int,
      receiveReminders: fields[6] as bool,
      preferredWorkoutTime: fields[7] as TimeOfDay,
      fitnessLevel: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.availableDays)
      ..writeByte(2)
      ..write(obj.trackingFrequency)
      ..writeByte(3)
      ..write(obj.preferredWorkoutTypes)
      ..writeByte(4)
      ..write(obj.targetWorkoutsPerWeek)
      ..writeByte(5)
      ..write(obj.targetWorkoutDuration)
      ..writeByte(6)
      ..write(obj.receiveReminders)
      ..writeByte(7)
      ..write(obj.preferredWorkoutTime)
      ..writeByte(8)
      ..write(obj.fitnessLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

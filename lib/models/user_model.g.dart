// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as String,
      fields[1] as String,
      gender: fields[2] as String?,
      dateOfBirth: fields[3] as String?,
      race: fields[4] as String?,
      heightFeet: fields[5] as int?,
      heightInches: fields[6] as int?,
      weight: fields[7] as int?,
    )
      ..selectedHealthConditions = (fields[8] as List?)?.cast<String>()
      ..fitnessLevel = fields[9] as String?
      ..fitnessGoals = (fields[10] as List?)?.cast<String>()
      ..workoutProgram = fields[11] as String?
      ..trackingFrequency = fields[12] as String?
      ..dailyAvailability = (fields[13] as List?)?.cast<String>()
      ..exercisePreferences = (fields[14] as List?)?.cast<String>()
      ..exerciseLocations = (fields[15] as List?)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.dateOfBirth)
      ..writeByte(4)
      ..write(obj.race)
      ..writeByte(5)
      ..write(obj.heightFeet)
      ..writeByte(6)
      ..write(obj.heightInches)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.selectedHealthConditions)
      ..writeByte(9)
      ..write(obj.fitnessLevel)
      ..writeByte(10)
      ..write(obj.fitnessGoals)
      ..writeByte(11)
      ..write(obj.workoutProgram)
      ..writeByte(12)
      ..write(obj.trackingFrequency)
      ..writeByte(13)
      ..write(obj.dailyAvailability)
      ..writeByte(14)
      ..write(obj.exercisePreferences)
      ..writeByte(15)
      ..write(obj.exerciseLocations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

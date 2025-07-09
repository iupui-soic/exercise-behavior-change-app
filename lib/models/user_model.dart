import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password;

  @HiveField(2)
  String? gender;

  @HiveField(3)
  String? dateOfBirth;

  @HiveField(4)
  String? race;

  @HiveField(5)
  int? heightFeet;

  @HiveField(6)
  int? heightInches;

  @HiveField(7)
  int? weight;

  @HiveField(8)
  List<String>? selectedHealthConditions;

  @HiveField(9)
  String? fitnessLevel;

  @HiveField(10)
  List<String>? fitnessGoals;

  @HiveField(11)
  String? workoutProgram;

  @HiveField(12)
  String? trackingFrequency;

  @HiveField(13)
  List<String>? dailyAvailability;

  @HiveField(14)
  List<String>? exercisePreferences;

  @HiveField(15)
  List<String>? exerciseLocations;

  @HiveField(16)
  String? profileImagePath;

  @HiveField(17)
  int? workoutPoints;

  @HiveField(18)
  String? name;

  User(this.email, this.password, {this.gender, this.dateOfBirth, this.race, this.heightFeet,this.heightInches,this.weight, this.workoutPoints = 0, this.name});

  // Add Firestore serialization methods
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      data['email'] ?? '',
      data['password'] ?? '',
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      race: data['race'],
      heightFeet: data['heightFeet'],
      heightInches: data['heightInches'],
      weight: data['weight'],
      workoutPoints: data['workoutPoints'] ?? 0,
      name: data['name'],
    )
      ..selectedHealthConditions = (data['selectedHealthConditions'] as List?)?.cast<String>()
      ..fitnessLevel = data['fitnessLevel']
      ..fitnessGoals = (data['fitnessGoals'] as List?)?.cast<String>()
      ..workoutProgram = data['workoutProgram']
      ..trackingFrequency = data['trackingFrequency']
      ..dailyAvailability = (data['dailyAvailability'] as List?)?.cast<String>()
      ..exercisePreferences = (data['exercisePreferences'] as List?)?.cast<String>()
      ..exerciseLocations = (data['exerciseLocations'] as List?)?.cast<String>()
      ..profileImagePath = data['profileImagePath'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'password': password,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'race': race,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'weight': weight,
      'selectedHealthConditions': selectedHealthConditions,
      'fitnessLevel': fitnessLevel,
      'fitnessGoals': fitnessGoals,
      'workoutProgram': workoutProgram,
      'trackingFrequency': trackingFrequency,
      'dailyAvailability': dailyAvailability,
      'exercisePreferences': exercisePreferences,
      'exerciseLocations': exerciseLocations,
      'profileImagePath': profileImagePath,
      'workoutPoints': workoutPoints,
      'name': name,
    };
  }
}
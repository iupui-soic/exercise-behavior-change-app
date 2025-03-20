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

  User(this.email, this.password, {
    this.gender,
    this.dateOfBirth,
    this.race,
    this.heightFeet,
    this.heightInches,
    this.weight,
    this.selectedHealthConditions,
    this.fitnessLevel,
    this.fitnessGoals,
    this.workoutProgram,
    this.trackingFrequency,
    this.dailyAvailability,
    this.exercisePreferences,
    this.exerciseLocations
  });

  // Factory to create from Firebase Auth user with Firestore data
  factory User.fromFirebase(
      String email, {
        String? gender,
        String? dateOfBirth,
        String? race,
        int? heightFeet,
        int? heightInches,
        int? weight,
        List<String>? selectedHealthConditions,
        String? fitnessLevel,
        List<String>? fitnessGoals,
        String? workoutProgram,
        String? trackingFrequency,
        List<String>? dailyAvailability,
        List<String>? exercisePreferences,
        List<String>? exerciseLocations,
      }) {
    return User(
      email,
      '', // We don't store the actual password
      gender: gender,
      dateOfBirth: dateOfBirth,
      race: race,
      heightFeet: heightFeet,
      heightInches: heightInches,
      weight: weight,
      selectedHealthConditions: selectedHealthConditions,
      fitnessLevel: fitnessLevel,
      fitnessGoals: fitnessGoals,
      workoutProgram: workoutProgram,
      trackingFrequency: trackingFrequency,
      dailyAvailability: dailyAvailability,
      exercisePreferences: exercisePreferences,
      exerciseLocations: exerciseLocations,
    );
  }

  // Create a User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return User(
      data['email'] ?? '',
      '', // Password isn't stored in Firestore
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      race: data['race'],
      heightFeet: data['heightFeet'],
      heightInches: data['heightInches'],
      weight: data['weight'],
      selectedHealthConditions: data['selectedHealthConditions'] != null
          ? List<String>.from(data['selectedHealthConditions'])
          : null,
      fitnessLevel: data['fitnessLevel'],
      fitnessGoals: data['fitnessGoals'] != null
          ? List<String>.from(data['fitnessGoals'])
          : null,
      workoutProgram: data['workoutProgram'],
      trackingFrequency: data['trackingFrequency'],
      dailyAvailability: data['dailyAvailability'] != null
          ? List<String>.from(data['dailyAvailability'])
          : null,
      exercisePreferences: data['exercisePreferences'] != null
          ? List<String>.from(data['exercisePreferences'])
          : null,
      exerciseLocations: data['exerciseLocations'] != null
          ? List<String>.from(data['exerciseLocations'])
          : null,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
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
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
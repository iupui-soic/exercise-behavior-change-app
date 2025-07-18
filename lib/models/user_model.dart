import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String? name;
  final String email;
  final String? profileImageUrl;
  final String? gender;
  final String? dateOfBirth;
  final String? race;
  final int? heightFeet;
  final int? heightInches;
  final int? weight;
  final List<String>? selectedHealthConditions;
  final String? fitnessLevel;
  final List<String>? fitnessGoals;
  final String? workoutProgram;
  final String? trackingFrequency;
  final List<String>? dailyAvailability;
  final List<String>? exercisePreferences;
  final List<String>? exerciseLocations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.uid,
    this.name,
    required this.email,
    this.profileImageUrl,
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
    this.exerciseLocations,
    this.createdAt,
    this.updatedAt,
  });

  // Create a User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return User(
      uid: doc.id,
      name: data['name'],
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
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
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Copy with method for creating updated instances
  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImageUrl,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      race: race ?? this.race,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      weight: weight ?? this.weight,
      selectedHealthConditions: selectedHealthConditions ?? this.selectedHealthConditions,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      workoutProgram: workoutProgram ?? this.workoutProgram,
      trackingFrequency: trackingFrequency ?? this.trackingFrequency,
      dailyAvailability: dailyAvailability ?? this.dailyAvailability,
      exercisePreferences: exercisePreferences ?? this.exercisePreferences,
      exerciseLocations: exerciseLocations ?? this.exerciseLocations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to check if user profile is complete
  bool get isProfileComplete {
    return name != null &&
        name!.isNotEmpty &&
        gender != null &&
        dateOfBirth != null &&
        heightFeet != null &&
        heightInches != null &&
        weight != null &&
        fitnessLevel != null;
  }

  // Helper method to get height in inches
  int? get totalHeightInches {
    if (heightFeet != null && heightInches != null) {
      return (heightFeet! * 12) + heightInches!;
    }
    return null;
  }

  // Helper method to get height as formatted string
  String? get heightString {
    if (heightFeet != null && heightInches != null) {
      return "${heightFeet!}'${heightInches!}\"";
    }
    return null;
  }

  // Helper method to get display name (falls back to email if name is empty)
  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return email.split('@').first; // Use part before @ as fallback
  }

  // Helper method to get user initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
      } else {
        return parts.first[0].toUpperCase();
      }
    }
    return email[0].toUpperCase();
  }
}
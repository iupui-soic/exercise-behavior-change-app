import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'app.dart';
import 'models/user_model.dart';
import 'models/achievement_model.dart';
import 'services/achievement_service.dart';
import 'services/firebase_options.dart'; // Updated import path

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive (still needed for offline caching and other data)
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AchievementAdapter());

  // Initialize achievements
  await AchievementService().initAchievements();

  // Run the app
  runApp(const MyApp());
}
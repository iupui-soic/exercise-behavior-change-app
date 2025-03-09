import 'package:flutter/material.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'utils/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behavior Change Exercise App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        // We will add our routes here
      },
    );
  }
}
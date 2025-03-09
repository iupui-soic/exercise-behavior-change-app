import 'package:flutter/material.dart';

class AppTheme {
  // App colors
  static const Color primaryColor = Color.fromARGB(255, 46, 196, 234);
  static const Color backgroundColor = Colors.black;
  static const Color cardColor = Color(0xFF1E2021);
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFB6BDCC);
  static const Color successColor = Color(0xFF94EB19);

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimaryColor),
      bodyMedium: TextStyle(color: textSecondaryColor),
    ),
    useMaterial3: true,
  );
}
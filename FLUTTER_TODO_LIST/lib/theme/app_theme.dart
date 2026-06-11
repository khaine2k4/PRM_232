import 'package:flutter/material.dart';

class AppTheme {
  // Common Colors (TaskFlow Custom Palette)
  static const Color priorityLow = Color(0xFF8C919E);     // Outline / Low Priority
  static const Color priorityMedium = Color(0xFFADC6FF);  // Primary / Med Priority
  static const Color priorityHigh = Color(0xFFFFB3AD);    // Tertiary / High Priority
  static const Color completed = Color(0xFF4EDEA3);       // Secondary / Completed Checkbox (Mint Green)

  // Custom Dark Theme (Navy/Blue Slate)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFADC6FF),       // Primary: Light Lavender Blue
        secondary: Color(0xFF4EDEA3),     // Secondary: Mint Green
        tertiary: Color(0xFFFFB3AD),      // Tertiary: Coral/Red
        surface: Color(0xFF0B1C30),       // Background/Surface: Deep Navy
        error: Color(0xFFE46962),
        primaryContainer: Color(0xFF004395), // Stats card background
        onPrimaryContainer: Color(0xFFD8E2FF),
        secondaryContainer: Color(0xFF005236),
        onSecondaryContainer: Color(0xFF6CF8BB),
      ),
      scaffoldBackgroundColor: Colors.transparent, // Allows custom gradient
      cardColor: const Color(0xFF182638), // Surface Container Low
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFFEAF1FF)),
      ),
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF182638), // Surface Container Low
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF424754), width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF424754), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFADC6FF), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF93000A)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFADC6FF),
        foregroundColor: const Color(0xFF002D6D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF182638),
        selectedColor: const Color(0xFFADC6FF),
        secondarySelectedColor: const Color(0xFFADC6FF),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFF424754), width: 0.8),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFFC2C6D6)),
        secondaryLabelStyle: const TextStyle(fontSize: 13, color: Color(0xFF002D6D), fontWeight: FontWeight.bold),
      ),
    );
  }

  // Custom Light Theme (Ocean Mist & Blue Slate)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0058BE),       // Darker Primary
        secondary: Color(0xFF00825B),     // Darker Secondary
        tertiary: Color(0xFFB91C1C),      // Darker Tertiary
        surface: Color(0xFFF0F4F8),       // Very light slate
        error: Color(0xFFBA1A1A),
        primaryContainer: Color(0xFFD8E2FF),
        onPrimaryContainer: Color(0xFF001A42),
        secondaryContainer: Color(0xFFE2F3EC),
        onSecondaryContainer: Color(0xFF003824),
      ),
      scaffoldBackgroundColor: Colors.transparent, // Allows custom gradient
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF0F1E31)),
      ),
      cardTheme: const CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0058BE), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF0058BE),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE2E8F0),
        selectedColor: const Color(0xFF0058BE),
        secondarySelectedColor: const Color(0xFF0058BE),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFCBD5E1), width: 0.8),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        secondaryLabelStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

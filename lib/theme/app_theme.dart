import 'package:flutter/material.dart';

/// Centralized theme definitions for the application.
class AppThemeData {
  /// The light theme configuration.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
    );
  }

  /// The dark theme configuration.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
    );
  }
}

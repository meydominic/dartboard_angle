import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A notifier that manages the application's theme mode (system, light, or dark).
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system; // Default to matching the system's theme settings.

  /// Updates the application theme mode.
  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

/// Provider for the theme mode state.
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  /// Updates the application locale preference.
  void setLocale(Locale? locale) {
    state = locale;
  }
}

/// Provider for the locale state.
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);
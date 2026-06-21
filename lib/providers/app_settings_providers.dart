import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_providers.g.dart';

// ==========================================
// PACKAGE INFO
// ==========================================
@Riverpod(keepAlive: true)
PackageInfo packageInfo(Ref ref) {
  throw UnimplementedError('packageInfoProvider wurde nicht im ProviderScope überschrieben.');
}

// ==========================================
// THEME
// ==========================================

/// A notifier that manages the application's theme mode (system, light, or dark).
@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() => ThemeMode.system; // Default to matching the system's theme settings.

  /// Updates the application theme mode.
  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

// ==========================================
// LOCALE
// ==========================================

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() => null;

  /// Updates the application locale preference.
  void setLocale(Locale? locale) {
    state = locale;
  }
}
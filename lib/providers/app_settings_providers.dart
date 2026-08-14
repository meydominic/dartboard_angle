import 'dart:convert';

import 'package:dartboard_angle/constants/shared_pref_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_settings_providers.g.dart';

// ==========================================
// SHARED PREFERENCES
// ==========================================
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider was not overridden in ProviderScope.');
}

// ==========================================
// PACKAGE INFO
// ==========================================
@Riverpod(keepAlive: true)
PackageInfo packageInfo(Ref ref) {
  throw UnimplementedError('packageInfoProvider was not overridden in ProviderScope.');
}

// ==========================================
// APP VERSION
// ==========================================

/// Returns the application version string.
///
/// On web builds deployed via GitHub Actions, the release version is injected
/// into `assets/version.json` at build time. If that file contains a non-"dev"
/// version it is used; otherwise the version from [PackageInfo] is used
/// (which reads `pubspec.yaml` or native build configuration).
@Riverpod(keepAlive: true)
Future<String> appVersion(Ref ref) async {
  try {
    final jsonStr = await rootBundle.loadString('assets/version.json');
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final version = json['version'] as String?;
    if (version != null && version != 'dev') {
      return version;
    }
  } catch (_) {
    // version.json not found — use PackageInfo fallback below.
  }

  final packageInfo = ref.watch(packageInfoProvider);
  return packageInfo.version;
}

// ==========================================
// THEME
// ==========================================

/// A notifier that manages the application's theme mode (system, light, or dark).
@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(SharedPrefKeys.themeMode) ?? 0;
    // Default to system theme if no preference is set.
    return ThemeMode.values[themeIndex];
  }

  /// Updates the application theme mode.
  void setTheme(ThemeMode mode) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt(SharedPrefKeys.themeMode, mode.index);
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
  Locale? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final languageCode = prefs.getString(SharedPrefKeys.appLocale);
    return languageCode != null ? Locale(languageCode) : null;
  }

  /// Updates the application locale preference.
  void setLocale(Locale? locale) {
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale != null) {
      prefs.setString(SharedPrefKeys.appLocale, locale.languageCode);
    } else {
      prefs.remove(SharedPrefKeys.appLocale);
    }
    state = locale;
  }
}

// ==========================================
// DARTBOARD COLOR
// ==========================================

/// A notifier that manages the color of the dartboard silhouette.
@Riverpod(keepAlive: true)
class DartboardColor extends _$DartboardColor {
  @override
  Color build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final colorValue = prefs.getInt(SharedPrefKeys.dartboardColor);
    // Default to pure white if no preference is set.
    return colorValue != null ? Color(colorValue) : const Color(0xFFFFFFFF);
  }

  /// Updates the dartboard color preference.
  void setColor(Color color) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setInt(SharedPrefKeys.dartboardColor, color.toARGB32());
    state = color;
  }
}

// ==========================================
// DARTBOARD THICKNESS
// ==========================================

/// A notifier that manages whether to display thicker dartboard lines.
@Riverpod(keepAlive: true)
class DartboardThickLines extends _$DartboardThickLines {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(SharedPrefKeys.dartboardThickLines) ?? false;
  }

  /// Updates the line thickness preference.
  void setThickLines(bool isThick) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool(SharedPrefKeys.dartboardThickLines, isThick);
    state = isThick;
  }
}
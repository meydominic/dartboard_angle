import 'package:dartboard_angle/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:dartboard_angle/screens/main_navigation_screen.dart';
import 'package:dartboard_angle/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The entry point of the application.
/// Initializes the widget binding and runs the application wrapped in a [ProviderScope]
/// to enable Riverpod state management.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const MyApp(),
    ),
  );
}

/// The root widget of the application.
/// Configures the global theme, localizations, and routing, and dynamically
/// reacts to changes in the theme and locale settings.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(appThemeProvider);
    final currentLocale = ref.watch(appLocaleProvider);
    final appInfo = ref.watch(packageInfoProvider);

    return MaterialApp(
      title: appInfo.appName,
      debugShowCheckedModeBanner: false,

      // Register generated localization delegates and supported locales.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      
      // Apply the user's selected theme mode and locale dynamically.
      themeMode: currentThemeMode,
      locale: currentLocale, 

      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}
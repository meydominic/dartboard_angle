import 'package:dartboard_angle/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:dartboard_angle/screens/main_navigation_screen.dart';

/// The entry point of the application.
/// Initializes the widget binding and runs the application wrapped in a [ProviderScope]
/// to enable Riverpod state management.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is required for Riverpod to store and manage state.
    const ProviderScope(
      child: MyApp(),
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
    // Watch the theme and locale providers to rebuild the MaterialApp when state changes.
    final currentThemeMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Dartboard Angle',
      debugShowCheckedModeBanner: false,

      // Register generated localization delegates and supported locales.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      
      // Apply the user's selected theme mode and locale dynamically.
      themeMode: currentThemeMode,
      locale: currentLocale, 

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, 
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, 
          brightness: Brightness.dark,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
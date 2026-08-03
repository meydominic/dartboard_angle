import 'package:dartboard_angle/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// A screen that manages the bottom navigation bar and displays either the
/// [HomeScreen] or [SettingsScreen] using an [IndexedStack] to preserve state.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Keeps track of the currently selected navigation destination index.
  int _currentIndex = 0;

  // The list of screens accessible via the navigation bar.
  final List<Widget> _screens = [
    const HomeScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve localized strings for the UI elements.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // IndexedStack renders all screens but only displays the selected index,
      // preserving the state and layout of both screens when switching.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: l10n.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings),
            icon: const Icon(Icons.settings_outlined),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
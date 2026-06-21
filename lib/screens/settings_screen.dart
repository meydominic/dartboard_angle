import 'package:dartboard_angle/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';

/// A settings screen that allows users to configure the application's appearance
/// (light, dark, or system theme), select the UI language, and view information about the app.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final currentTheme = ref.watch(appThemeProvider);
    final currentLocale = ref.watch(appLocaleProvider);
    final appInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 2.0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // --- APPEARANCE SECTION ---
          _buildSectionHeader(context, l10n.appearance, Icons.palette_outlined),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
            ),
            color: colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            child: RadioGroup<ThemeMode>(
              groupValue: currentTheme,
              onChanged: (mode) {
                if (mode != null) ref.read(appThemeProvider.notifier).setTheme(mode);
              },
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.themeSystem, style: theme.textTheme.bodyLarge),
                    subtitle: Text(l10n.themeSystemSub, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    value: ThemeMode.system,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.themeLight, style: theme.textTheme.bodyLarge),
                    value: ThemeMode.light,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.themeDark, style: theme.textTheme.bodyLarge),
                    value: ThemeMode.dark,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- LANGUAGE SECTION ---
          _buildSectionHeader(context, l10n.language, Icons.translate_outlined),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
            ),
            color: colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            child: RadioGroup<Locale?>(
              groupValue: currentLocale,
              onChanged: (locale) => ref.read(appLocaleProvider.notifier).setLocale(locale),
              child: Column(
                children: [
                  RadioListTile<Locale?>(
                    title: Text(l10n.langSystem, style: theme.textTheme.bodyLarge),
                    value: null,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<Locale?>(
                    title: Text('Deutsch', style: theme.textTheme.bodyLarge),
                    value: const Locale('de'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<Locale?>(
                    title: Text('English', style: theme.textTheme.bodyLarge),
                    value: const Locale('en'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- ABOUT SECTION ---
          _buildSectionHeader(context, l10n.about, Icons.info_outline),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
            ),
            color: colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Icons.phone_android_outlined, color: colorScheme.primary),
              title: Text(appInfo.appName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text('Version ${appInfo.version}', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a section header with an icon and title.
  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
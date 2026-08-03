import 'package:dartboard_angle/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// A settings screen that allows users to configure the application's appearance
/// (light, dark, or system theme), select the UI language, and view information about the app.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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

          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
            ),
            color: colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.dartboardColor, style: theme.textTheme.bodyLarge),
                  subtitle: Text(l10n.dartboardColorSub, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  trailing: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ref.watch(dartboardColorProvider),
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outline, width: 1),
                    ),
                  ),
                  onTap: () async {
                    final currentColor = ref.read(dartboardColorProvider);
                    Color pickedColor = currentColor;

                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(l10n.pickColor),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: currentColor,
                              onColorChanged: (color) => pickedColor = color,
                              enableAlpha: true,
                              displayThumbColor: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(MaterialLocalizations.of(context).okButtonLabel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                            ),
                          ],
                        );
                      },
                    );

                    if (result == true) {
                      ref.read(dartboardColorProvider.notifier).setColor(pickedColor);
                    }
                  },
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                SwitchListTile(
                  title: Text(l10n.dartboardThickLines, style: theme.textTheme.bodyLarge),
                  subtitle: Text(l10n.dartboardThickLinesSub, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  value: ref.watch(dartboardThickLinesProvider),
                  onChanged: (isThick) => ref.read(dartboardThickLinesProvider.notifier).setThickLines(isThick),
                ),
              ],
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
                    title: Text(l10n.langGerman, style: theme.textTheme.bodyLarge),
                    value: const Locale('de'),
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  RadioListTile<Locale?>(
                    title: Text(l10n.langEnglish, style: theme.textTheme.bodyLarge),
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

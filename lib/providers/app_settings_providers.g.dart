// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Synchroner Zugriff auf die beim Start geladenen App-Informationen.
/// Wird in der main.dart beim App-Start überschrieben.

@ProviderFor(packageInfo)
final packageInfoProvider = PackageInfoProvider._();

/// Synchroner Zugriff auf die beim Start geladenen App-Informationen.
/// Wird in der main.dart beim App-Start überschrieben.

final class PackageInfoProvider
    extends $FunctionalProvider<PackageInfo, PackageInfo, PackageInfo>
    with $Provider<PackageInfo> {
  /// Synchroner Zugriff auf die beim Start geladenen App-Informationen.
  /// Wird in der main.dart beim App-Start überschrieben.
  PackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoHash();

  @$internal
  @override
  $ProviderElement<PackageInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PackageInfo create(Ref ref) {
    return packageInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackageInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackageInfo>(value),
    );
  }
}

String _$packageInfoHash() => r'77892c4c7025ecad594cfb80e7efaa0045e596b2';

/// A notifier that manages the application's theme mode (system, light, or dark).
/// Generiert automatisch den `themeProvider`.

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

/// A notifier that manages the application's theme mode (system, light, or dark).
/// Generiert automatisch den `themeProvider`.
final class AppThemeProvider extends $NotifierProvider<AppTheme, ThemeMode> {
  /// A notifier that manages the application's theme mode (system, light, or dark).
  /// Generiert automatisch den `themeProvider`.
  AppThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @$internal
  @override
  AppTheme create() => AppTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeHash() => r'f2d3d3ae477801101f98ba62b93ca9d8b1f71c2e';

/// A notifier that manages the application's theme mode (system, light, or dark).
/// Generiert automatisch den `themeProvider`.

abstract class _$AppTheme extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
///
/// HINWEIS: Klassenname ist 'AppLocale', um Konflikte mit Flutters 'Locale'-Klasse zu vermeiden.
/// Generiert automatisch den `appLocaleProvider`.

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
///
/// HINWEIS: Klassenname ist 'AppLocale', um Konflikte mit Flutters 'Locale'-Klasse zu vermeiden.
/// Generiert automatisch den `appLocaleProvider`.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale?> {
  /// A notifier that manages the application's locale settings.
  /// A value of `null` indicates that the device's default system language should be used.
  ///
  /// HINWEIS: Klassenname ist 'AppLocale', um Konflikte mit Flutters 'Locale'-Klasse zu vermeiden.
  /// Generiert automatisch den `appLocaleProvider`.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'bb136c03ecaa570acb2ff4ba1e73f3a2af7526fb';

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
///
/// HINWEIS: Klassenname ist 'AppLocale', um Konflikte mit Flutters 'Locale'-Klasse zu vermeiden.
/// Generiert automatisch den `appLocaleProvider`.

abstract class _$AppLocale extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

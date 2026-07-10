// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'43bedba89d040ef320b9c3554e46d0ad69b68545';

@ProviderFor(packageInfo)
final packageInfoProvider = PackageInfoProvider._();

final class PackageInfoProvider
    extends $FunctionalProvider<PackageInfo, PackageInfo, PackageInfo>
    with $Provider<PackageInfo> {
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

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

/// A notifier that manages the application's theme mode (system, light, or dark).
final class AppThemeProvider extends $NotifierProvider<AppTheme, ThemeMode> {
  /// A notifier that manages the application's theme mode (system, light, or dark).
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

String _$appThemeHash() => r'79c123092cb3ca1569adbc9c8be7a4267a5800bd';

/// A notifier that manages the application's theme mode (system, light, or dark).

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

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale?> {
  /// A notifier that manages the application's locale settings.
  /// A value of `null` indicates that the device's default system language should be used.
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

String _$appLocaleHash() => r'17153da4ef9def08100b0903a01721270d70e4f5';

/// A notifier that manages the application's locale settings.
/// A value of `null` indicates that the device's default system language should be used.

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

/// A notifier that manages the color of the dartboard silhouette.

@ProviderFor(DartboardColor)
final dartboardColorProvider = DartboardColorProvider._();

/// A notifier that manages the color of the dartboard silhouette.
final class DartboardColorProvider
    extends $NotifierProvider<DartboardColor, Color> {
  /// A notifier that manages the color of the dartboard silhouette.
  DartboardColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dartboardColorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dartboardColorHash();

  @$internal
  @override
  DartboardColor create() => DartboardColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$dartboardColorHash() => r'0f89976bb70ea03e0c1beec13750d85b65fe01df';

/// A notifier that manages the color of the dartboard silhouette.

abstract class _$DartboardColor extends $Notifier<Color> {
  Color build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Color, Color>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Color, Color>,
              Color,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// A notifier that manages whether to display thicker dartboard lines.

@ProviderFor(DartboardThickLines)
final dartboardThickLinesProvider = DartboardThickLinesProvider._();

/// A notifier that manages whether to display thicker dartboard lines.
final class DartboardThickLinesProvider
    extends $NotifierProvider<DartboardThickLines, bool> {
  /// A notifier that manages whether to display thicker dartboard lines.
  DartboardThickLinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dartboardThickLinesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dartboardThickLinesHash();

  @$internal
  @override
  DartboardThickLines create() => DartboardThickLines();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dartboardThickLinesHash() =>
    r'cc2329723e73fca57933ddb5b7c4d31155f946ed';

/// A notifier that manages whether to display thicker dartboard lines.

abstract class _$DartboardThickLines extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

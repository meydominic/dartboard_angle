// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dartboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a stream of accelerometer events, throttled to 200ms.
/// Automatically disposes of itself when no longer listened to.

@ProviderFor(throttledSensor)
final throttledSensorProvider = ThrottledSensorProvider._();

/// Provides a stream of accelerometer events, throttled to 200ms.
/// Automatically disposes of itself when no longer listened to.

final class ThrottledSensorProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccelerometerEvent>,
          AccelerometerEvent,
          Stream<AccelerometerEvent>
        >
    with
        $FutureModifier<AccelerometerEvent>,
        $StreamProvider<AccelerometerEvent> {
  /// Provides a stream of accelerometer events, throttled to 200ms.
  /// Automatically disposes of itself when no longer listened to.
  ThrottledSensorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'throttledSensorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$throttledSensorHash();

  @$internal
  @override
  $StreamProviderElement<AccelerometerEvent> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AccelerometerEvent> create(Ref ref) {
    return throttledSensor(ref);
  }
}

String _$throttledSensorHash() => r'f960289294e6da315a9d0061b4457127e7a132d8';

/// Calculates and exposes the rotational angle based on filtered accelerometer readings.
/// Automatically disposes of itself when no longer listened to.

@ProviderFor(dartboardRotation)
final dartboardRotationProvider = DartboardRotationProvider._();

/// Calculates and exposes the rotational angle based on filtered accelerometer readings.
/// Automatically disposes of itself when no longer listened to.

final class DartboardRotationProvider
    extends
        $FunctionalProvider<
          AsyncValue<double>,
          AsyncValue<double>,
          AsyncValue<double>
        >
    with $Provider<AsyncValue<double>> {
  /// Calculates and exposes the rotational angle based on filtered accelerometer readings.
  /// Automatically disposes of itself when no longer listened to.
  DartboardRotationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dartboardRotationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dartboardRotationHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<double>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<double> create(Ref ref) {
    return dartboardRotation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<double>>(value),
    );
  }
}

String _$dartboardRotationHash() => r'2fb46c8800646970fbd0faee969a27f475297482';

/// Manages the zoom scale factor for the dartboard graphic.

@ProviderFor(DartboardScale)
final dartboardScaleProvider = DartboardScaleProvider._();

/// Manages the zoom scale factor for the dartboard graphic.
final class DartboardScaleProvider
    extends $NotifierProvider<DartboardScale, double> {
  /// Manages the zoom scale factor for the dartboard graphic.
  DartboardScaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dartboardScaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dartboardScaleHash();

  @$internal
  @override
  DartboardScale create() => DartboardScale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$dartboardScaleHash() => r'cbc386b560749af994f3baad13426e880090d624';

/// Manages the zoom scale factor for the dartboard graphic.

abstract class _$DartboardScale extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

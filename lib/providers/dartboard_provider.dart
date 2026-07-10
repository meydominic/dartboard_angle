import 'package:dartboard_angle/constants/shared_pref_keys.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

part 'dartboard_provider.g.dart';

/// Provides a stream of accelerometer events, throttled to 200ms.
/// Automatically disposes of itself when no longer listened to.
@riverpod
Stream<AccelerometerEvent> throttledSensor(Ref ref) async* {
  await for (final event in accelerometerEventStream(
    samplingPeriod: SensorInterval.normalInterval,
  )) {
    yield event;
  }
}

/// Calculates and exposes the rotational angle based on filtered accelerometer readings.
/// Automatically disposes of itself when no longer listened to.
@riverpod
AsyncValue<double> dartboardRotation(Ref ref) {
  final sensorAsync = ref.watch(throttledSensorProvider);
  return sensorAsync.when(
    data: (event) => AsyncData(math.pi / 2 - math.atan2(event.y, event.x)),
    error: (e, s) => AsyncError('Sensor data stream error: $e', s),
    loading: () => const AsyncLoading(),
  );
}

/// Manages the zoom scale factor for the dartboard graphic.
@riverpod
class DartboardScale extends _$DartboardScale {
  @override
  double build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getDouble(SharedPrefKeys.dartboardScale) ?? 1.0; // Default scale is 1.0 (no zoom)
  }

  /// Updates the zoom scale factor dynamically.
  void setScale(double newScale) {
    final prefs = ref.watch(sharedPreferencesProvider);
    prefs.setDouble(SharedPrefKeys.dartboardScale, newScale);
    state = newScale;
  }

  /// Adjusts the zoom scale factor safely within boundaries.
  void adjustZoom(double delta, double maxScale) {
    final newZoom = (state + delta).clamp(0.5, maxScale);
    setScale(newZoom);
  }
}
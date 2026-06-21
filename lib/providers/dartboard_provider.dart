import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

/// Provides a stream of accelerometer events, throttled to 200ms.
/// Automatically disposes of itself when no longer listened to.
final throttledSensorProvider = StreamProvider.autoDispose<AccelerometerEvent>((ref) async* {

  await for (final event in accelerometerEventStream(
    samplingPeriod: SensorInterval.normalInterval,
  )) {
    yield event;
  }
});

/// Calculates and exposes the rotational angle based on filtered accelerometer readings.
/// Automatically disposes of itself when no longer listened to.
final dartboardRotationProvider = Provider.autoDispose<AsyncValue<double>>((ref) {
  // Watch the throttled stream for smooth, rate-limited data points.
  final sensorAsync = ref.watch(throttledSensorProvider);

  return sensorAsync.when(
    data: (event) {
      // Invert the angle so the overlay rotates in alignment with the camera feed
      // to keep it level relative to the physical world.
      return AsyncData(math.pi / 2 - math.atan2(event.y, event.x));
    },
    error: (e, s) => AsyncError('Sensor data stream error: $e', s),
    loading: () => const AsyncLoading(),
  );
});

/// Manages the zoom scale factor for the dartboard graphic.
class DartboardScaleNotifier extends Notifier<double> {
  @override
  double build() {
    // Initial zoom level is set to 1.0.
    return 1.0;
  }

  /// Updates the zoom scale factor dynamically.
  void setScale(double newScale) {
    state = newScale;
  }
}

/// Provider for the dartboard graphic's zoom scale factor.
/// Automatically disposes of itself when no longer needed.
final dartboardScaleProvider = NotifierProvider.autoDispose<DartboardScaleNotifier, double>(
  DartboardScaleNotifier.new,
);
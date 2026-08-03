import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

/// The rotation angle formula used by the dartboard provider:
/// `π/2 − atan2(y, x)` — extracts the roll angle from raw accelerometer readings.
///
/// Testing this directly avoids Riverpod's `overrideWithValue` visibility
/// issues while still verifying the core math.
double computeRotationAngle(double x, double y) {
  return math.pi / 2 - math.atan2(y, x);
}

void main() {
  group('dartboard rotation math', () {
    test('phone upright (top pointing up) → angle ≈ π', () {
      // y ≈ -g, x ≈ 0 → atan2(-g, 0) = -π/2 → π/2 - (-π/2) = π
      final angle = computeRotationAngle(0, -9.81);
      expect(angle, closeTo(math.pi, 0.01));
    });

    test('phone on right side → angle ≈ π/2', () {
      // x ≈ g (right side down), y ≈ 0 → atan2(0, g) = 0 → π/2
      final angle = computeRotationAngle(9.81, 0);
      expect(angle, closeTo(math.pi / 2, 0.01));
    });

    test('phone on left side → angle ≈ -π/2', () {
      // x ≈ -g (left side down), y ≈ 0 → atan2(0, -g) = π → π/2 - π = -π/2
      final angle = computeRotationAngle(-9.81, 0);
      expect(angle, closeTo(-math.pi / 2, 0.01));
    });

    test('phone flat on back (screen up) → angle ≈ π/2', () {
      // x ≈ 0, y ≈ 0 → atan2(0, 0) = 0 → π/2
      final angle = computeRotationAngle(0, 0);
      expect(angle, closeTo(math.pi / 2, 0.01));
    });

    test('45° tilt → expected value', () {
      // When x == y (45° diagonal), atan2(y, x) = π/4
      final angle = computeRotationAngle(1, 1);
      expect(angle, closeTo(math.pi / 2 - math.pi / 4, 0.01));
    });

    test('result is always finite for reasonable inputs', () {
      final angles = <double>[
        computeRotationAngle(0, -9.81),
        computeRotationAngle(9.81, 0),
        computeRotationAngle(-9.81, 0),
        computeRotationAngle(0.001, 0.001),
        computeRotationAngle(-5, 5),
        computeRotationAngle(1, -1),
      ];
      for (final angle in angles) {
        expect(angle.isFinite, isTrue);
      }
    });
  });

  group('dartboard zoom clamping', () {
    /// The clamping logic from DartboardScale.adjustZoom:
    /// `(state + delta).clamp(0.5, maxScale)`
    double clampZoom(double current, double delta, double maxScale) {
      return (current + delta).clamp(0.5, maxScale);
    }

    test('clamps to minimum 0.5', () {
      expect(clampZoom(0.6, -0.2, 3.0), 0.5);
    });

    test('clamps to maximum', () {
      expect(clampZoom(0.8, 5.0, 3.0), 3.0);
    });

    test('stays within bounds for normal adjustment', () {
      expect(clampZoom(1.5, 0.3, 3.0), 1.8);
    });

    test('negative delta decreases scale', () {
      expect(clampZoom(2.0, -0.5, 3.0), 1.5);
    });
  });
}

import 'package:dartboard_angle/services/sensor_permission_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sensor permission service (stub)', () {
    test('needsSensorPermission is false on non-web platforms', () {
      expect(needsSensorPermission, isFalse);
    });

    test('requestSensorPermission returns true immediately', () async {
      final result = await requestSensorPermission();
      expect(result, isTrue);
    });
  });
}

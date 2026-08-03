import 'package:dartboard_angle/constants/shared_pref_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SharedPrefKeys', () {
    test('themeMode key is not empty', () {
      expect(SharedPrefKeys.themeMode, isNotEmpty);
    });

    test('appLocale key is not empty', () {
      expect(SharedPrefKeys.appLocale, isNotEmpty);
    });

    test('dartboardScale key is not empty', () {
      expect(SharedPrefKeys.dartboardScale, isNotEmpty);
    });

    test('dartboardColor key is not empty', () {
      expect(SharedPrefKeys.dartboardColor, isNotEmpty);
    });

    test('dartboardThickLines key is not empty', () {
      expect(SharedPrefKeys.dartboardThickLines, isNotEmpty);
    });

    test('all keys are unique', () {
      final keys = [
        SharedPrefKeys.themeMode,
        SharedPrefKeys.appLocale,
        SharedPrefKeys.dartboardScale,
        SharedPrefKeys.dartboardColor,
        SharedPrefKeys.dartboardThickLines,
      ];
      expect(keys.toSet().length, keys.length);
    });
  });
}

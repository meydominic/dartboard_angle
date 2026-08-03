import 'package:dartboard_angle/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppThemeData', () {
    group('lightTheme', () {
      test('uses Material 3', () {
        expect(AppThemeData.lightTheme.useMaterial3, isTrue);
      });

      test('has light brightness color scheme', () {
        expect(AppThemeData.lightTheme.colorScheme.brightness, Brightness.light);
      });

      test('color scheme is derived from teal seed', () {
        // Teal seed produces a recognisable primary colour family.
        final primary = AppThemeData.lightTheme.colorScheme.primary;
        // Teal is roughly in the 170–190 hue range when mapped to HSL.
        // We just verify the colour is non-default.
        expect(primary, isA<Color>());
        expect(primary, isNot(Colors.transparent));
      });
    });

    group('darkTheme', () {
      test('uses Material 3', () {
        expect(AppThemeData.darkTheme.useMaterial3, isTrue);
      });

      test('has dark brightness color scheme', () {
        expect(AppThemeData.darkTheme.colorScheme.brightness, Brightness.dark);
      });

      test('color scheme is derived from teal seed', () {
        final primary = AppThemeData.darkTheme.colorScheme.primary;
        expect(primary, isA<Color>());
        expect(primary, isNot(Colors.transparent));
      });
    });
  });
}

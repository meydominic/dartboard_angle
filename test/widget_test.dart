import 'package:camera/camera.dart';
import 'package:dartboard_angle/l10n/app_localizations.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:dartboard_angle/providers/camera_provider.dart';
import 'package:dartboard_angle/providers/dartboard_provider.dart';
import 'package:dartboard_angle/screens/home_screen.dart';
import 'package:dartboard_angle/widgets/status_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test - shows error when no camera is found', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cameraListProvider.overrideWith(
            (Ref ref) => Future<List<CameraDescription>>.value([]),
          ),
          throttledSensorProvider.overrideWith(
            (Ref ref) => const Stream<AccelerometerEvent>.empty(),
          ),
          sharedPreferencesProvider.overrideWithValue(prefs),
          packageInfoProvider.overrideWithValue(
            PackageInfo(appName: 'Test', packageName: 'test', version: '0.1.0', buildNumber: '1'),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HomeScreen()),
        ),
      ),
    );

    // Pump a few frames to allow providers to settle.
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.textContaining('No camera found'), findsOneWidget);
  });
}

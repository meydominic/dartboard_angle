// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dartboard Angle';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'Automatic (System)';

  @override
  String get themeSystemSub => 'Follows your smartphone settings';

  @override
  String get themeLight => 'Light Design';

  @override
  String get themeDark => 'Dark Design';

  @override
  String get language => 'Language';

  @override
  String get langSystem => 'System Language';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langEnglish => 'English';

  @override
  String get about => 'About the App';

  @override
  String get noCamera => 'No camera found on this device.';

  @override
  String get tiltAngle => 'Tilt Angle';

  @override
  String get perfectAlignment => 'Perfectly Aligned';

  @override
  String get deviation => 'Deviation';

  @override
  String zoomScale(String scale) {
    return 'Zoom: ${scale}x';
  }

  @override
  String get waitingForSensorData => 'Waiting for sensor data...';

  @override
  String cameraError(String error) {
    return 'Camera Error: $error';
  }

  @override
  String sensorError(String error) {
    return 'Sensor Error: $error';
  }
}

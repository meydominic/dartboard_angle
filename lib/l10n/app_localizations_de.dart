// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dartboard Angle';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Anzeige';

  @override
  String get themeSystem => 'Automatisch (System)';

  @override
  String get themeSystemSub => 'Folgt den Einstellungen deines Smartphones';

  @override
  String get themeLight => 'Helles Design';

  @override
  String get themeDark => 'Dunkles Design';

  @override
  String get language => 'Sprache';

  @override
  String get langSystem => 'Systemsprache';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langEnglish => 'English';

  @override
  String get about => 'Über die App';

  @override
  String get noCamera => 'Keine Kamera auf dem Gerät gefunden.';

  @override
  String get tiltAngle => 'Neigungswinkel';

  @override
  String get perfectAlignment => 'Perfekt ausgerichtet';

  @override
  String get deviation => 'Abweichung';

  @override
  String zoomScale(String scale) {
    return 'Zoom: ${scale}x';
  }

  @override
  String get waitingForSensorData => 'Warte auf Sensordaten...';

  @override
  String cameraError(String error) {
    return 'Kamera-Fehler: $error';
  }

  @override
  String sensorError(String error) {
    return 'Sensor-Fehler: $error';
  }

  @override
  String get dartboardColor => 'Dartscheiben-Farbe';

  @override
  String get dartboardColorSub => 'Farbe der projizierten Silhouette';

  @override
  String get pickColor => 'Farbe wählen';

  @override
  String get dartboardThickLines => 'Dickere Linien anzeigen';

  @override
  String get dartboardThickLinesSub =>
      'Erhöht die Liniendicke der Silhouette für bessere Sichtbarkeit';
}

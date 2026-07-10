import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Dartboard Angle'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In de, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In de, this message translates to:
  /// **'Anzeige'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In de, this message translates to:
  /// **'Automatisch (System)'**
  String get themeSystem;

  /// No description provided for @themeSystemSub.
  ///
  /// In de, this message translates to:
  /// **'Folgt den Einstellungen deines Smartphones'**
  String get themeSystemSub;

  /// No description provided for @themeLight.
  ///
  /// In de, this message translates to:
  /// **'Helles Design'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkles Design'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @langSystem.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get langSystem;

  /// No description provided for @langGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @langEnglish.
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @about.
  ///
  /// In de, this message translates to:
  /// **'Über die App'**
  String get about;

  /// No description provided for @noCamera.
  ///
  /// In de, this message translates to:
  /// **'Keine Kamera auf dem Gerät gefunden.'**
  String get noCamera;

  /// No description provided for @tiltAngle.
  ///
  /// In de, this message translates to:
  /// **'Neigungswinkel'**
  String get tiltAngle;

  /// No description provided for @perfectAlignment.
  ///
  /// In de, this message translates to:
  /// **'Perfekt ausgerichtet'**
  String get perfectAlignment;

  /// No description provided for @deviation.
  ///
  /// In de, this message translates to:
  /// **'Abweichung'**
  String get deviation;

  /// No description provided for @zoomScale.
  ///
  /// In de, this message translates to:
  /// **'Zoom: {scale}x'**
  String zoomScale(String scale);

  /// No description provided for @waitingForSensorData.
  ///
  /// In de, this message translates to:
  /// **'Warte auf Sensordaten...'**
  String get waitingForSensorData;

  /// No description provided for @cameraError.
  ///
  /// In de, this message translates to:
  /// **'Kamera-Fehler: {error}'**
  String cameraError(String error);

  /// No description provided for @sensorError.
  ///
  /// In de, this message translates to:
  /// **'Sensor-Fehler: {error}'**
  String sensorError(String error);

  /// No description provided for @dartboardColor.
  ///
  /// In de, this message translates to:
  /// **'Dartscheiben-Farbe'**
  String get dartboardColor;

  /// No description provided for @dartboardColorSub.
  ///
  /// In de, this message translates to:
  /// **'Farbe der projizierten Silhouette'**
  String get dartboardColorSub;

  /// No description provided for @pickColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe wählen'**
  String get pickColor;

  /// No description provided for @dartboardThickLines.
  ///
  /// In de, this message translates to:
  /// **'Dickere Linien anzeigen'**
  String get dartboardThickLines;

  /// No description provided for @dartboardThickLinesSub.
  ///
  /// In de, this message translates to:
  /// **'Erhöht die Liniendicke der Silhouette für bessere Sichtbarkeit'**
  String get dartboardThickLinesSub;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

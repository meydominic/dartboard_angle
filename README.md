# Dartboard Angle 🎯📐

Eine moderne, performante Flutter-App zur präzisen und waagerechten Ausrichtung von Dartscheiben mithilfe der Smartphone-Kamera und den Lagesensoren (Beschleunigungssensor) des Geräts.

Die App projiziert eine digitale Silhouette einer Dartscheibe als SVG-Overlay über das Live-Bild der Kamera. Durch die Lagesensoren bleibt das SVG-Overlay stets perfekt waagerecht zur realen Welt ausgerichtet. So lässt sich die Kamera auf die physische Dartscheibe richten, um Abweichungen sofort zu erkennen und zu korrigieren.

---

## Features

- **Echtzeit-Wasserwaage & HUD**: Dynamische Anzeige des aktuellen Neigungswinkels mit einer visuellen Röhrenlibelle (Bubble Level). Signalisiert sofort durch Farbwechsel (Grün / Orange), wenn die Ausrichtung perfekt ist (< 1.0° Abweichung).
- **Verzerrungsfreie Kamera-Vorschau**: Intelligente Seitenverhältnis-Anpassung, die Verzerrungen des Kamerabildes auf unterschiedlichen Display-Größen verhindert.
- **Interaktiver Zoom**: Stufenlose Zoom-Möglichkeit der Dartscheiben-Silhouette (0.5x bis 3.0x), um sie perfekt an die Entfernung zur physischen Dartscheibe anzupassen.
- **Modernste Flutter APIs**: Nutzt Flutter `3.44.1`, Dart `3.12.1`, und moderne Framework-Features wie das neue native `RadioGroup` Widget.
- **Riverpod 3.x State Management**: Reaktive und modulare Zustandsverwaltung über moderne `Notifier` und `NotifierProvider`-Klassen.
- **Clean Code & Typisierung**: Keine Warnungen, keine veralteten Methoden (Nutzung von `Color.withValues(alpha: ...)` statt `withOpacity()`).
- **Mehrsprachigkeit (i18n)**: Volle Unterstützung für Deutsch (`de`) und Englisch (`en`) mittels nativer Flutter-Lokalisierung.

---

## Projektstruktur

```
lib/
├── l10n/                     # Übersetzungsdateien (.arb & generierte Dart-Klassen)
├── providers/                # Riverpod Notifiers & Providers (Zustand & Logik)
│   ├── app_settings_providers.dart  # Theme (Light/Dark) & Sprachauswahl
│   ├── camera_provider.dart         # Kamera-Initialisierung & Controller-Verwaltung
│   └── dartboard_provider.dart      # Sensordaten-Drosselung (30 FPS) & Mathematik-Korrektur
├── screens/                  # Benutzeroberfläche
│   ├── home_screen.dart             # Hauptbildschirm mit Kamera-Feed, SVG & HUD
│   ├── settings_screen.dart         # Einstellungen (Sprache, Design)
│   └── main_navigation_screen.dart  # Navigationsleiste
└── main.dart                 # App-Einstiegspunkt (MaterialApp & ProviderScope)
```

---

## Installation & Ausführung

### Voraussetzungen

Stelle sicher, dass du das Flutter SDK installiert hast.

```bash
flutter --version
```

### Setup & Start

1. **Abhängigkeiten installieren:**
   ```bash
   flutter pub get
   ```

2. **Lokalisierung generieren:**
   ```bash
   flutter gen-l10n
   ```

3. **App starten:**
   ```bash
   flutter run
   ```

---

## Technologie-Stack & Design-Entscheidungen

- **Sensordrosselung**: Die Sensordaten werden nativ über `samplingPeriod` auf etwa 30 FPS gedrosselt. Dies spart CPU-Leistung und Batterieladung auf Mobilgeräten.
- **Mathematische Korrektur**: Die Drehung der SVG-Silhouette verwendet die korrigierte Winkelfunktion `math.pi / 2 - math.atan2(event.y, event.x)`, damit das Overlay synchron mit dem Kamerabild rotiert und zur physischen Umwelt in Waage bleibt.
- **Wide-Gamut-Farbraum**: Die Verwendung von `withValues(alpha: ...)` verhindert Farbungenauigkeiten im Wide-Gamut-Farbraum und ist zukunftssicher.

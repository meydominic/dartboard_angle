# Dartboard Angle 🎯📐

A modern, high-performance Flutter application designed for precisely aligning and leveling dartboards using your smartphone's camera and accelerometer sensors.

The app overlays a digital SVG silhouette of a dartboard onto a live camera feed. By reading the device's accelerometer data, the SVG overlay dynamically rotates to remain perfectly level with the physical world (gravity). This allows you to point your phone at your physical dartboard to instantly recognize and correct any mounting deviations.

---

## Features

- **Distortion-Free Camera Preview:** Intelligent aspect ratio adjustments to prevent camera feed stretching on different display sizes.
- **Interactive & Smart Zoom:** Seamless zooming functionality for the dartboard silhouette. The zoom boundaries dynamically adjust based on the device's screen size and orientation (Portrait vs. Landscape), ensuring the dartboard never overlaps with the user interface.
- **Modern Flutter APIs:** Built with Flutter and Dart, utilizing the latest native framework features.
- **Robust State Management:** Reactive and modular state management powered by Riverpod Code Generation (`@riverpod`), ensuring clean architecture and type safety.
- **Advanced Camera Lifecycle:** Intelligently pauses the camera stream (`pausePreview`) when the app is moved to the background, saving significant battery life, and seamlessly resumes it upon return.
- **Optimized Sensor Handling:** Hardware-level sensor throttling using `SensorInterval.normalInterval` (200ms), reducing CPU overhead while keeping the rotation buttery smooth.
- **Clean Code & Theming:** Centralized theme configurations (`AppThemeData`) and fully extracted, reusable UI components.
- **Internationalization (i18n):** Full localization support for English (`en`) and German (`de`) via native Flutter ARB templates.

---

## Project Structure

```text
lib/
├── l10n/                     # Translation files (.arb) and generated Dart classes
├── providers/                # Riverpod Notifiers & Providers (State & Logic)
│   ├── app_settings_providers.dart  # Theme (Light/Dark) & Language selection
│   ├── camera_provider.dart         # Camera initialization & lifecycle management
│   └── dartboard_provider.dart      # Hardware-throttled sensor data & rotation math
├── screens/                  # User Interface
│   ├── home_screen.dart             # Main screen (Camera feed, SVG overlay, Zoom controls)
│   ├── settings_screen.dart         # Settings (Language, Theme)
│   └── main_navigation_screen.dart  # Bottom navigation bar logic
├── theme/
│   └── app_theme.dart               # Centralized light & dark theme definitions
├── widgets/
│   └── status_screens.dart          # Reusable loading and error screen components
└── main.dart                 # Application entry point
```

---

## Installation & Execution

### Prerequisites

Ensure you have the latest stable Flutter SDK installed.

```bash
flutter --version
```

### Setup & Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate Riverpod & Localization files:**
   ```bash
   dart run build_runner build -d
   flutter gen-l10n
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## Technology Stack & Design Decisions

- **Hardware Sensor Throttling:** Instead of filtering the data streams manually in software, the accelerometer is configured to report at `SensorInterval.normalInterval` (approx. 200ms) directly at the OS level. This greatly preserves device battery.
- **Mathematical Correction:** The rotation of the SVG silhouette relies on the corrected trigonometric formula `math.pi / 2 - math.atan2(event.y, event.x)`. This keeps the overlay perfectly level relative to gravity, independent of the phone's tilt.
- **Wide-Gamut Colors:** Utilizing the modern `withValues(alpha: ...)` API ensures precise color rendering across modern wide-gamut displays.
- **Code Generation:** Utilizing `riverpod_generator` reduces boilerplate code, guarantees consistency across providers, and eliminates common state-management errors.

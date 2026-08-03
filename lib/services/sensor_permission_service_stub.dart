/// Non-web stub: motion sensor permission is never required on native platforms
/// (Android / iOS) — the OS handles it at install time.
library;

/// Whether the platform requires an explicit user-gesture-triggered
/// permission dialog before the accelerometer will deliver real data.
/// Always `false` on native platforms.
const bool needsSensorPermission = false;

/// Checks at runtime whether a motion-sensor permission dialog is needed.
/// Always returns `false` on native platforms.
Future<bool> checkNeedsSensorPermission() async {
  return false;
}

/// Request motion sensor permission.
///
/// Always resolves to `true` on native platforms.
Future<bool> requestSensorPermission() async {
  return true;
}

/// Non-web stub: motion sensor permission is never required on native platforms
/// (Android / iOS) — the OS handles it at install time.
///
/// Whether the platform requires an explicit user-gesture-triggered
/// permission dialog before the accelerometer will deliver real data.
const bool needsSensorPermission = false;

/// Request motion sensor permission.
///
/// Always resolves to `true` on native platforms.
Future<bool> requestSensorPermission() async {
  return true;
}

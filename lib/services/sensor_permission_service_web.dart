/// Web implementation of the sensor permission service.
library;

import 'dart:js_interop';

@JS('__dartboardNeedsSensorPermission')
external JSBoolean _needsSensorPermission();

@JS('__dartboardRequestMotionPermission')
external JSPromise<JSString> _requestMotionPermission();

/// Whether the platform might require an explicit permission dialog before the
/// accelerometer will deliver real data.
///
/// On the web this is conservatively `true` because we cannot statically
/// determine whether the browser is Safari / WKWebView on iOS.
const bool needsSensorPermission = true;

/// Checks at runtime whether the current browser actually requires a
/// motion-sensor permission dialog (iOS 13+ Safari / WKWebView).
///
/// On Chrome / Android this returns `false` so no permission UI is shown.
Future<bool> checkNeedsSensorPermission() async {
  try {
    return _needsSensorPermission().toDart;
  } catch (_) {
    return false;
  }
}

/// Request motion sensor permission via the polyfill helper.
///
/// **Must be called from a user gesture** (e.g. a button `onTap` handler),
/// otherwise iOS will reject the promise.
///
/// Returns `true` if permission was granted or is not required.
Future<bool> requestSensorPermission() async {
  try {
    final result = await _requestMotionPermission().toDart;
    return result.toDart == 'granted';
  } catch (_) {
    // If the JS function is unavailable or throws, assume no permission needed.
    return true;
  }
}

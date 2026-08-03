/// Web implementation of the sensor permission service.
library;

import 'dart:js_interop';

@JS('__dartboardRequestMotionPermission')
external JSPromise<JSString> _requestMotionPermission();

/// Whether the platform might require an explicit permission dialog before the
/// accelerometer will deliver real data.
///
/// On the web this is conservatively `true` because we cannot statically
/// determine whether the browser is Safari / WKWebView on iOS.
const bool needsSensorPermission = true;

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

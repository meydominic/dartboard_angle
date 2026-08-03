/// Service that handles the iOS-Safari-specific DeviceMotion permission flow.
///
/// On iOS 13+ the browser blocks accelerometer data until the user explicitly
/// grants permission via a user-gesture-triggered dialog. This service wraps
/// the JavaScript polyfill helper [__dartboardRequestMotionPermission] and
/// exposes a uniform API across platforms.
///
/// ## Platform behaviour
///
/// | Platform            | Behaviour                                                    |
/// |---------------------|--------------------------------------------------------------|
/// | Android (native)    | `needsPermission` → `false`, `requestPermission` is a no-op  |
/// | iOS (native)        | `needsPermission` → `false`, `requestPermission` is a no-op  |
/// | Web – Chrome        | `needsPermission` → `false` (polyfill is inert)              |
/// | Web – Safari / WKWebView | `needsPermission` → `true`, must call `requestPermission` from a user gesture |
library;

export 'sensor_permission_service_stub.dart'
    if (dart.library.js_interop) 'sensor_permission_service_web.dart';

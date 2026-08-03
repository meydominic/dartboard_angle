/**
 * sensor_polyfill.js
 *
 * Provides a polyfill for the Generic Sensor API's Accelerometer class
 * using the older DeviceMotionEvent API, enabling accelerometer support
 * in browsers that lack the native Generic Sensor API (notably iOS Safari).
 *
 * The polyfill is intentionally minimal: it exposes only the subset of the
 * Accelerometer interface that sensors_plus actually consumes at runtime.
 *
 * Usage: load this script in <head> before Flutter's bootstrap script.
 */

(function () {
  // ---------------------------------------------------------------------------
  // Guard: do nothing if the browser ships the real Accelerometer (e.g. Chrome)
  // ---------------------------------------------------------------------------
  if (typeof window.Accelerometer !== 'undefined') {
    return;
  }

  // ---------------------------------------------------------------------------
  // Polyfill: Accelerometer backed by DeviceMotionEvent
  // ---------------------------------------------------------------------------
  class AccelerometerPolyfill {
    constructor(opts) {
      /** @type {number} Polling interval in ms derived from requested frequency */
      this._intervalMs = 1000 / ((opts && opts.frequency) || 60);
      /** @type {?Function} Callback invoked on each reading interval */
      this._onreading = null;
      /** @type {?Function} Callback invoked on error */
      this._onerror = null;
      /** @type {boolean} Whether the sensor is actively reading */
      this._active = false;
      /** @type {?number} setInterval handle */
      this._timer = null;

      // Latest acceleration values in m/s² – coordinate system matches the
      // Generic Sensor spec (x: left→right, y: bottom→top, z: back→front).
      this._x = 0;
      this._y = 0;
      this._z = 0;

      // Bound handler so we can add/remove the same listener reference.
      this._onDeviceMotion = this._onDeviceMotion.bind(this);
    }

    // -- Sensor interface (read by sensors_plus via dart:js_interop) ----------

    get x() {
      return this._x;
    }
    get y() {
      return this._y;
    }
    get z() {
      return this._z;
    }

    set onreading(fn) {
      this._onreading = fn;
    }
    set onerror(fn) {
      this._onerror = fn;
    }

    /**
     * Starts the sensor: listens to devicemotion and fires the onreading
     * callback at the requested frequency.
     */
    start() {
      if (this._active) return;
      this._active = true;

      window.addEventListener('devicemotion', this._onDeviceMotion, false);

      var self = this;
      this._timer = setInterval(function () {
        if (self._active && typeof self._onreading === 'function') {
          try {
            self._onreading(new Event('reading'));
          } catch (e) {
            if (typeof self._onerror === 'function') {
              self._onerror({ error: { message: e.message || 'Sensor polyfill error' } });
            }
          }
        }
      }, this._intervalMs);
    }

    /**
     * Stops the sensor and releases the devicemotion listener.
     * (Called by sensors_plus when the stream subscription is cancelled.)
     */
    stop() {
      this._active = false;
      window.removeEventListener('devicemotion', this._onDeviceMotion, false);
      if (this._timer != null) {
        clearInterval(this._timer);
        this._timer = null;
      }
    }

    // -- Internal helpers -----------------------------------------------------

    /**
     * Handler for the native devicemotion event.
     * Reads accelerationIncludingGravity (i.e. raw accelerometer values).
     * When permission has not been granted on iOS the values will be null,
     * so we fall back to 0.
     */
    _onDeviceMotion(event) {
      var acc = event.accelerationIncludingGravity;
      if (acc) {
        this._x = acc.x || 0;
        this._y = acc.y || 0;
        this._z = acc.z || 0;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Install the polyfill on the global scope
  // ---------------------------------------------------------------------------
  window.Accelerometer = AccelerometerPolyfill;

  // ---------------------------------------------------------------------------
  // iOS 13+ permission helper
  //
  // DeviceMotionEvent.requestPermission() must be called from a user gesture
  // (e.g. a button tap). We expose a convenience function so Flutter can
  // trigger it via JS interop when the user taps a "Start" / permission button.
  // ---------------------------------------------------------------------------
  if (
    typeof DeviceMotionEvent !== 'undefined' &&
    typeof DeviceMotionEvent.requestPermission === 'function'
  ) {
    /**
     * Requests DeviceMotion permission on iOS.
     * @returns {Promise<'granted'|'denied'>}
     */
    window.__dartboardRequestMotionPermission = function () {
      return DeviceMotionEvent.requestPermission();
    };
  } else {
    // On platforms that don't need a permission dialog, resolve immediately.
    window.__dartboardRequestMotionPermission = function () {
      return Promise.resolve('granted');
    };
  }
})();

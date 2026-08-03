import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:dartboard_angle/l10n/generated/app_localizations.dart';
import 'package:dartboard_angle/providers/dartboard_provider.dart';
import 'package:dartboard_angle/providers/camera_provider.dart';
import 'package:dartboard_angle/providers/app_settings_providers.dart';
import 'package:dartboard_angle/services/sensor_permission_service.dart';
import 'package:dartboard_angle/widgets/status_screens.dart';

/// The main dashboard screen containing a live camera preview, a level visualizer HUD,
/// and a rotatable overlay of a dartboard aligned dynamically using accelerometer sensor data.
///
/// Keeps the device screen awake while this screen is visible so the display
/// does not turn off during dartboard calibration.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double? _lastClampedMaxScale;

  static const double _uiChromeHeight = 180.0;
  static const double _minBoardSize = 150.0;
  static const double _svgIntrinsicSize = 300.0;

  /// `null` until the runtime browser check completes, then `false` when
  /// a permission dialog is needed, `true` otherwise.
  bool? _sensorPermissionGranted;
  bool _sensorPermissionPending = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable().catchError((e) {
      debugPrint('Failed to enable wakelock: $e');
    });
    _initSensorPermissionState();
  }

  Future<void> _initSensorPermissionState() async {
    final needsPermission = await checkNeedsSensorPermission();
    if (mounted) {
      setState(() => _sensorPermissionGranted = !needsPermission);
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable().catchError((e) {
      debugPrint('Failed to disable wakelock: $e');
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cameraAsync = ref.watch(appCameraControllerProvider);
    final sensorAsync = ref.watch(dartboardRotationProvider);
    final scaleValue = ref.watch(dartboardScaleProvider);
    final dartboardColor = ref.watch(dartboardColorProvider);
    final useThickLines = ref.watch(dartboardThickLinesProvider);

    final displaySize = MediaQuery.sizeOf(context);
    final maxDiameterFromWidth = displaySize.width;
    final maxDiameterFromHeight = displaySize.height - _uiChromeHeight;
    final safeDimension = math.max(_minBoardSize, math.min(maxDiameterFromWidth, maxDiameterFromHeight));
    final maxScale = safeDimension / _svgIntrinsicSize;

    if (scaleValue > maxScale && _lastClampedMaxScale != maxScale) {
      _lastClampedMaxScale = maxScale;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(dartboardScaleProvider.notifier).adjustZoom(0, maxScale);
      });
    }

    if (cameraAsync.hasError) {
      return _CameraErrorScreen(
        message: l10n.cameraError(cameraAsync.error.toString()),
        onRetry: () => ref.invalidate(appCameraControllerProvider),
      );
    }

    return cameraAsync.when(
      loading: () => LoadingScreen(title: '${l10n.home}...'),
      error: (err, _) => _CameraErrorScreen(
        message: l10n.cameraError(err.toString()),
        onRetry: () => ref.invalidate(appCameraControllerProvider),
      ),
      data: (controller) {
        // Show error screen if sensor stream has errored.
        if (sensorAsync.hasError) {
          return ErrorScreen(
            message: l10n.sensorError(sensorAsync.error.toString()),
          );
        }

        // Use real sensor angle when available, otherwise default to 0°.
        final hasSensorData = sensorAsync is AsyncData<double>;
        final safeAngle = switch (sensorAsync) {
          AsyncData(:final value) when value.isFinite => value,
          _ => 0.0,
        };

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            // Registering a user tap satisfies iOS's requirement that
            // DeviceMotionEvent must be triggered by a user gesture.
            // Without a tap, devicemotion events remain null on iOS Safari.
            onTap: () {},
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera preview – displayed at native 1.0 zoom without cropping.
                Center(
                  child: CameraPreview(controller),
                ),

                // Dartboard SVG overlay – always visible, rotates once sensor data arrives.
                Transform.scale(
                  scale: scaleValue,
                  child: AnimatedRotation(
                    turns: safeAngle / (2 * math.pi),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: SvgPicture.asset(
                      useThickLines
                          ? 'assets/dartboard_thick.svg'
                          : 'assets/dartboard.svg',
                      width: _svgIntrinsicSize,
                      height: _svgIntrinsicSize,
                      colorFilter: ColorFilter.mode(
                        dartboardColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                // Sensor activation prompt – shown while waiting for the first sensor event.
                // On iOS Safari the devicemotion API requires a user gesture before it
                // starts firing; tapping anywhere on the screen satisfies this.
                if (!hasSensorData && _sensorPermissionGranted != false)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              l10n.waitingForSensorData,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.sensorActivationPrompt,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Motion-sensor permission prompt (iOS Safari / WKWebView only).
                if (_sensorPermissionGranted == false)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.sensors,
                                  size: 48, color: Colors.white70),
                              const SizedBox(height: 16),
                              Text(
                                l10n.sensorPermissionTitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.sensorPermissionBody,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white60),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: _sensorPermissionPending
                                    ? null
                                    : _handleSensorPermissionRequest,
                                icon: _sensorPermissionPending
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                label: Text(l10n.sensorPermissionButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Zoom controls.
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildZoomButton(
                              context, Icons.remove, -0.1, maxScale),
                          const SizedBox(width: 24),
                          Text(
                            l10n.zoomScale(
                                math.min(scaleValue, maxScale).toStringAsFixed(1)),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 24),
                          _buildZoomButton(
                              context, Icons.add, 0.1, maxScale),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _handleSensorPermissionRequest() async {
    setState(() => _sensorPermissionPending = true);
    try {
      final granted = await requestSensorPermission();
      if (mounted) {
        setState(() {
          _sensorPermissionGranted = granted;
          _sensorPermissionPending = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _sensorPermissionGranted = true;
          _sensorPermissionPending = false;
        });
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Widget _buildZoomButton(BuildContext context, IconData icon, double delta, double maxScale) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(dartboardScaleProvider.notifier).adjustZoom(delta, maxScale),
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.9),
          ),
          child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Camera error screen with retry button
// ---------------------------------------------------------------------------

/// Displayed when the camera fails to initialise (e.g. because the browser
/// requires a user gesture before `getUserMedia()` is allowed on mobile).
///
/// The [onRetry] callback calls `ref.invalidate(appCameraControllerProvider)`
/// which triggers a fresh camera initialisation — this time with a user gesture
/// behind it.
class _CameraErrorScreen extends StatelessWidget {
  const _CameraErrorScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cameraswitch, size: 48, color: Color(0xFFFF6B6B)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 18),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.cameraRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

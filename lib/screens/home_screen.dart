import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:dartboard_angle/l10n/app_localizations.dart';
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
  /// Tracks the last maxScale value that triggered a clamp, preventing
  /// duplicate post-frame callbacks on consecutive rebuilds.
  double? _lastClampedMaxScale;

  /// Estimated combined height of the top and bottom UI chrome
  /// (AppBar / NavigationBar / zoom controls).
  static const double _uiChromeHeight = 180.0;

  /// Minimum meaningful dartboard overlay dimension in logical pixels.
  static const double _minBoardSize = 150.0;

  /// Intrinsic width and height of the SVG dartboard assets in logical pixels.
  static const double _svgIntrinsicSize = 300.0;

  /// Whether the device-motion permission dialog has been resolved.
  /// Starts `true` on platforms that never need a permission dialog.
  bool _sensorPermissionGranted = !needsSensorPermission;

  /// Whether a permission request is currently in flight (prevents double-tap).
  bool _sensorPermissionPending = false;

  @override
  void initState() {
    super.initState();
    // Prevent the screen from turning off while calibrating the dartboard.
    // Wrapped with catchError because the platform channel may not be available
    // in test environments or on platforms without wakelock support.
    WakelockPlus.enable().catchError((e) {
      debugPrint('Failed to enable wakelock: $e');
    });
  }

  @override
  void dispose() {
    // Allow the screen to turn off again when leaving the camera view.
    WakelockPlus.disable().catchError((e) {
      debugPrint('Failed to disable wakelock: $e');
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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

    // Automatically clamp scale if screen size changes (e.g., rotating to landscape).
    // Guarded to prevent scheduling duplicate callbacks on every rebuild.
    if (scaleValue > maxScale && _lastClampedMaxScale != maxScale) {
      _lastClampedMaxScale = maxScale;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(dartboardScaleProvider.notifier).adjustZoom(0, maxScale);
      });
    }

    // Check for error first, because Riverpod's AsyncNotifier may report
    // errors as AsyncLoading during retry (hasError=true, isLoading=true).
    if (cameraAsync.hasError) {
      return ErrorScreen(message: l10n.cameraError(cameraAsync.error.toString()));
    }

    return cameraAsync.when(
      loading: () => LoadingScreen(title: '${l10n.home}...'),
      error: (err, _) => ErrorScreen(message: l10n.cameraError(err.toString())),
      data: (controller) {
        return sensorAsync.when(
          loading: () => LoadingScreen(title: l10n.waitingForSensorData),
          error: (err, _) => ErrorScreen(message: l10n.sensorError(err.toString())),
          data: (rotationAngle) {

            final safeAngle = rotationAngle.isFinite ? rotationAngle : 0.0;

            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                alignment: Alignment.center,
                children: [
                  // Full-screen camera preview with aspect ratio correction.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final mediaSize = MediaQuery.of(context).size;
                      final deviceRatio = mediaSize.width / mediaSize.height;
                      final cameraRatio = 1 / controller.value.aspectRatio;

                      final scale = deviceRatio > cameraRatio
                          ? deviceRatio / cameraRatio
                          : cameraRatio / deviceRatio;

                      return ClipRect(
                        child: SizedBox.expand(
                          child: Transform.scale(
                            scale: scale,
                            child: Center(
                              child: CameraPreview(controller),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Dartboard SVG overlay that rotates dynamically in alignment with the physical world.
                  Transform.scale(
                    scale: scaleValue,
                    child: AnimatedRotation(
                      turns: safeAngle / (2 * math.pi),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      child: SvgPicture.asset(
                        useThickLines ? 'assets/dartboard_thick.svg' : 'assets/dartboard.svg',
                        width: _svgIntrinsicSize,
                        height: _svgIntrinsicSize,
                        colorFilter: ColorFilter.mode(
                          dartboardColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),

                  // iOS motion-sensor permission prompt (web only).
                  // Displayed when the browser requires an explicit user gesture
                  // before the accelerometer will deliver real values.
                  if (!_sensorPermissionGranted)
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
                                const Icon(
                                  Icons.sensors,
                                  size: 48,
                                  color: Colors.white70,
                                ),
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
                                      : () => _requestSensorPermission(),
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

                  // Zoom scale controls.
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildZoomButton(context, Icons.remove, -0.1, maxScale),
                            const SizedBox(width: 24),
                            Text(
                              l10n.zoomScale(math.min(scaleValue, maxScale).toStringAsFixed(1)),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 24),
                            _buildZoomButton(context, Icons.add, 0.1, maxScale),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Requests device-motion permission on platforms that require it
  /// (iOS Safari / WKWebView). Must be called from a user gesture.
  Future<void> _requestSensorPermission() async {
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
          _sensorPermissionGranted = true; // don't block the UI on error
          _sensorPermissionPending = false;
        });
      }
    }
  }

  /// Helper widget for the zoom scale adjustment buttons.
  Widget _buildZoomButton(BuildContext context, IconData icon, double delta, double maxScale) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(dartboardScaleProvider.notifier).adjustZoom(delta, maxScale);
        },
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

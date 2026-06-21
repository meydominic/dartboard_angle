import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dartboard_angle/l10n/app_localizations.dart';
import 'package:dartboard_angle/providers/dartboard_provider.dart'; 
import 'package:dartboard_angle/providers/camera_provider.dart';

/// The main dashboard screen containing a live camera preview, a level visualizer HUD,
/// and a rotatable overlay of a dartboard aligned dynamically using accelerometer sensor data.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cameraAsync = ref.watch(cameraControllerProvider);
    final sensorAsync = ref.watch(dartboardRotationProvider);
    final scaleValue = ref.watch(dartboardScaleProvider);

    return cameraAsync.when(
      loading: () => LoadingScreen(title: '${l10n.home}...'),
      error: (err, _) => ErrorScreen(message: 'Camera Error: $err'),
      data: (controller) {
        return sensorAsync.when(
          loading: () => const LoadingScreen(title: 'Waiting for sensor data...'),
          error: (err, _) => ErrorScreen(message: 'Sensor Error: $err'),
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
                        'assets/dartboard.svg',
                        width: 300,
                        height: 300,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withValues(alpha: 0.8),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),

                  // Zoom scale controls.
                  Positioned(
                    bottom: 60,
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
                            _buildZoomButton(context, ref, Icons.remove, -0.1),
                            const SizedBox(width: 24),
                            Text(
                              'Zoom: ${scaleValue.toStringAsFixed(1)}x',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 24),
                            _buildZoomButton(context, ref, Icons.add, 0.1),
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

  /// Helper widget for the zoom scale adjustment buttons.
  Widget _buildZoomButton(BuildContext context, WidgetRef ref, IconData icon, double delta) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final displaySize = MediaQuery.sizeOf(context);
          final minScreenDimension = math.min(displaySize.width, displaySize.height);
          final maxScale = minScreenDimension / 300;
          final currentZoom = ref.read(dartboardScaleProvider);
          final newZoom = (currentZoom + delta).clamp(0.5, maxScale);
          ref.read(dartboardScaleProvider.notifier).setScale(newZoom);
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

/// A custom spirit level representation of a floating bubble.
class BubbleLevel extends StatelessWidget {
  /// The current tilt angle in degrees.
  final double angleDegrees;

  const BubbleLevel({super.key, required this.angleDegrees});

  @override
  Widget build(BuildContext context) {
    final isLevel = angleDegrees.abs() < 1.0;
    // Map the tilt angle to Alignment X (-1.0 to 1.0).
    // The maximum mapped display range is set to +/- 15 degrees.
    final double alignX = (angleDegrees / 15.0).clamp(-1.0, 1.0);

    return Container(
      width: 220,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLevel ? Colors.greenAccent.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Stack(
        children: [
          // Center alignment target bracket.
          Center(
            child: Container(
              width: 32,
              height: 28,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                  right: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                ),
              ),
            ),
          ),
          // Center target point indicator.
          Center(
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // The sliding bubble indicator representing device tilt.
          Align(
            alignment: Alignment(alignX, 0),
            child: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLevel ? Colors.greenAccent : Colors.amberAccent,
                boxShadow: [
                  BoxShadow(
                    color: (isLevel ? Colors.greenAccent : Colors.amberAccent).withValues(alpha: 0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper loading screen.
class LoadingScreen extends StatelessWidget {
  /// The loading message to display.
  final String title;

  const LoadingScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.greenAccent),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

/// Helper error screen to show failures in camera or sensor systems.
class ErrorScreen extends StatelessWidget {
  /// The error message to display.
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          message, 
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 18)
        ),
      ),
    ),
  );
}
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

/// Provider that fetches the list of available cameras on the device.
/// Automatically disposes of itself when no longer listened to.
@riverpod
Future<List<CameraDescription>> cameraList(Ref ref) async {
  try {
    return await availableCameras();
  } catch (e) {
    debugPrint('Error initializing camera list: $e');
    return [];
  }
}

/// A notifier that manages the lifecycle and state of a [CameraController].
/// It listens to the app lifecycle state and recreates/refreshes the controller
/// when the app returns from the background to prevent a black screen preview.
@Riverpod(keepAlive: true)
class AppCameraController extends _$AppCameraController {
  @override
  Future<CameraController> build() async {
    // Watch the available cameras provider to get the hardware descriptions.
    final cameras = await ref.watch(cameraListProvider.future);

    if (cameras.isEmpty) {
      throw Exception('No camera found on the device');
    }

    // Prefer the back-facing camera. On web, the front camera is sometimes
    // listed first, which gives the wrong default for a dartboard-alignment app.
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    try {
      // Initialize the camera controller with maximum resolution preset.
      final controller = CameraController(camera, ResolutionPreset.max, enableAudio: false);
      await controller.initialize();

      // Ensure the controller is disposed of when the provider is disposed to release hardware resources.
      ref.onDispose(() => controller.dispose());

      // Set up a lifecycle listener to pause the camera when the app goes into the background
      // and resume it when the app returns to the foreground, saving battery.
      final lifecycleListener = AppLifecycleListener(
        onInactive: () {
          debugPrint('App inactive: pausing CameraController to save battery.');
          try {
            if (controller.value.isInitialized) controller.pausePreview();
          } catch (e) {
            debugPrint('Failed to pause camera preview: $e');
          }
        },
        onResume: () {
          debugPrint('App resumed: resuming CameraController to restore preview.');
          try {
            if (controller.value.isInitialized) controller.resumePreview();
          } catch (e) {
            debugPrint('Failed to resume camera preview: $e');
          }
        },
      );
      // Ensure the lifecycle listener is disposed when this notifier is disposed.
      ref.onDispose(() => lifecycleListener.dispose());

      return controller;
    } catch (e) {
      debugPrint('Error initializing CameraController: $e');
      rethrow;
    }
  }
}

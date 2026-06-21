import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that fetches the list of available cameras on the device.
/// Automatically disposes of itself when no longer listened to.
final cameraProvider = FutureProvider.autoDispose<List<CameraDescription>>((ref) async {
  try {
    return await availableCameras();
  } catch (e) {
    debugPrint('Error initializing camera list: $e');
    return [];
  }
});

/// A notifier that manages the lifecycle and state of a [CameraController].
/// It listens to the app lifecycle state and recreates/refreshes the controller
/// when the app returns from the background to prevent a black screen preview.
class CameraControllerNotifier extends AsyncNotifier<CameraController> {
  @override
  Future<CameraController> build() async {
    // Watch the available cameras provider to get the hardware descriptions.
    final cameras = await ref.watch(cameraProvider.future);
    
    if (cameras.isEmpty) {
      throw Exception('No camera found on the device');
    }

    // Set up a lifecycle listener to refresh the camera when the app returns to the foreground.
    // This prevents a black screen when starting in debug mode or returning from background/permissions.
    final lifecycleListener = AppLifecycleListener(
      onResume: () {
        debugPrint('App resumed: refreshing CameraController to restore preview.');
        ref.invalidateSelf();
      },
    );
    // Ensure the lifecycle listener is disposed when this notifier is disposed.
    ref.onDispose(() => lifecycleListener.dispose());

    try {
      // Initialize the camera controller using the first camera and maximum resolution preset.
      final controller = CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
      await controller.initialize();
      
      // Ensure the controller is disposed of when the provider is disposed to release hardware resources.
      ref.onDispose(() => controller.dispose());
      return controller;
    } catch (e) {
      debugPrint('Error initializing CameraController: $e');
      rethrow;
    }
  }
}

/// Provider for the [CameraController] state.
/// Automatically disposes when the UI screen using the camera is closed.
final cameraControllerProvider = AsyncNotifierProvider.autoDispose<CameraControllerNotifier, CameraController>(
  CameraControllerNotifier.new,
);
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that fetches the list of available cameras on the device.
/// Automatically disposes of itself when no longer listened to.

@ProviderFor(cameraList)
final cameraListProvider = CameraListProvider._();

/// Provider that fetches the list of available cameras on the device.
/// Automatically disposes of itself when no longer listened to.

final class CameraListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CameraDescription>>,
          List<CameraDescription>,
          FutureOr<List<CameraDescription>>
        >
    with
        $FutureModifier<List<CameraDescription>>,
        $FutureProvider<List<CameraDescription>> {
  /// Provider that fetches the list of available cameras on the device.
  /// Automatically disposes of itself when no longer listened to.
  CameraListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraListHash();

  @$internal
  @override
  $FutureProviderElement<List<CameraDescription>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CameraDescription>> create(Ref ref) {
    return cameraList(ref);
  }
}

String _$cameraListHash() => r'505ce03dd0a73ef5fcb54bf793822ce4cbebec67';

/// A notifier that manages the lifecycle and state of a [CameraController].
/// It listens to the app lifecycle state and recreates/refreshes the controller
/// when the app returns from the background to prevent a black screen preview.

@ProviderFor(AppCameraController)
final appCameraControllerProvider = AppCameraControllerProvider._();

/// A notifier that manages the lifecycle and state of a [CameraController].
/// It listens to the app lifecycle state and recreates/refreshes the controller
/// when the app returns from the background to prevent a black screen preview.
final class AppCameraControllerProvider
    extends $AsyncNotifierProvider<AppCameraController, CameraController> {
  /// A notifier that manages the lifecycle and state of a [CameraController].
  /// It listens to the app lifecycle state and recreates/refreshes the controller
  /// when the app returns from the background to prevent a black screen preview.
  AppCameraControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appCameraControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appCameraControllerHash();

  @$internal
  @override
  AppCameraController create() => AppCameraController();
}

String _$appCameraControllerHash() =>
    r'0e4440713471627c8db58bf48d71f6fa6481a16e';

/// A notifier that manages the lifecycle and state of a [CameraController].
/// It listens to the app lifecycle state and recreates/refreshes the controller
/// when the app returns from the background to prevent a black screen preview.

abstract class _$AppCameraController extends $AsyncNotifier<CameraController> {
  FutureOr<CameraController> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CameraController>, CameraController>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CameraController>, CameraController>,
              AsyncValue<CameraController>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

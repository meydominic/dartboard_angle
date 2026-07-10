import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:dartboard_angle/main.dart';
import 'package:dartboard_angle/providers/camera_provider.dart';
import 'package:dartboard_angle/widgets/status_screens.dart';

class FakeAppCameraController extends AppCameraController {
  @override
  Future<CameraController> build() async {
    throw Exception('No camera found');
  }
}

void main() {
  testWidgets('App smoke test - shows error when no camera is found', (WidgetTester tester) async {
    // Build the application within the test environment wrapped in a ProviderScope with mocked providers.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appCameraControllerProvider.overrideWith(FakeAppCameraController.new),
        ],
        child: const MyApp(),
      ),
    );
    
    // Pump a frame with a short duration to let the asynchronous notifier future complete and rebuild the tree.
    await tester.pump(const Duration(milliseconds: 100));

    // In a test environment, since the camera provider is mocked to fail,
    // we expect the error UI to be rendered.
    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.textContaining('No camera found'), findsOneWidget);
  });
}

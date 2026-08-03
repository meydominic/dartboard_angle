import 'package:dartboard_angle/widgets/status_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingScreen', () {
    testWidgets('displays CircularProgressIndicator and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingScreen(title: 'Loading…'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading…'), findsOneWidget);
    });

    testWidgets('has black background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingScreen(title: 'Test'),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });

    testWidgets('displays different titles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingScreen(title: 'Please wait'),
        ),
      );

      expect(find.text('Please wait'), findsOneWidget);
      expect(find.text('Something else'), findsNothing);
    });
  });

  group('ErrorScreen', () {
    testWidgets('displays error message with red styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ErrorScreen(message: 'Something went wrong'),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      final text = tester.widget<Text>(find.text('Something went wrong'));
      expect(text.style?.color, const Color(0xFFFF6B6B));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('has black background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ErrorScreen(message: 'Error'),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.black);
    });
  });
}

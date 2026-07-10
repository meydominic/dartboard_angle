import 'package:flutter/material.dart';

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

/// Helper error screen to show failures in systems.
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

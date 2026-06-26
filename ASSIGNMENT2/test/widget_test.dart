// Smoke test for TaskFlow Pro (Assignment 2).
//
// The app boots into a _RootGate that asynchronously initializes
// SharedPreferences + SQLite before routing to Login or Home. While that
// bootstrap future is pending, the branded SplashScreen is shown. We only pump
// a single frame (no pumpAndSettle) so we don't block on platform channels that
// aren't available in the test environment.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment2_todo/main.dart';

void main() {
  testWidgets('App boots and shows the TaskFlow Pro splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // First frame: branding + loading indicator are visible.
    expect(find.text('TaskFlow Pro'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // A MaterialApp drives the whole app.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:citoyen/app.dart'; // Import the App widget
// import 'package:citoyen/main.dart'; // main.dart is not needed directly for widget testing App

void main() {
  testWidgets('App builds and shows initial text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that our app shows the initial welcome text.
    // This text comes from the initial Scaffold in app.dart
    expect(find.text('Bienvenue à Citoyen App!'), findsOneWidget);
  });
}


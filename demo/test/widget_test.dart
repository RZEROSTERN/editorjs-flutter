import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Smoke test for the demo app shell.
// Full integration tests live in the package's own test/ directory.
void main() {
  testWidgets('MaterialApp renders without throwing', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

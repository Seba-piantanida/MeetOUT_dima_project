import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dima_project/create_event_page.dart';

void main() {
  group('CreateEventPage Widget Test', () {
    testWidgets('Renders CreateEventPage correctly',
        (WidgetTester tester) async {
      // Mock dependencies or external services (if any)

      // Provide the mocked dependencies to the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateEventPage(),
        ),
      );

      // Verify that the initial state is as expected
      expect(find.text('New event'), findsOneWidget);

      // Wait for the widget to rebuild after interactions
      await tester.pump();

      // Verify that the widget is in the desired state after interactions

      // Optionally, you can continue with more interactions and verifications
    });
  });
}

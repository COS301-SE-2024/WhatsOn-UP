import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';

// Sample EventCard with network image URL


void main() {
  testWidgets('RsvpEventsPage should display events and remove them correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RsvpEventsPage(),
      ),
    );

    // Verify that all event names are displayed
    for (int i = 0; i < 8; i++) {
      expect(find.text('something$i'), findsOneWidget);
    }

    // Tap the delete button of the first event and confirm the dialog
    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();  // Wait for the dialog to appear

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();  // Wait for the dialog to disappear

    // Verify that the first event was removed
    expect(find.text('something0'), findsNothing);
  });
}

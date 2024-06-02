import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  testWidgets('RsvpEventsPage should display events and remove them correctly using the popup modal', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RsvpEventsPage(),
      ),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel').first);
    await tester.pumpAndSettle();

  
    await tester.tap(find.widgetWithText(CupertinoDialogAction, 'Delete').first);
    await tester.pumpAndSettle();

    
      expect(find.text('Event name 1'), findsNothing);
      expect(find.text('Event name 2'), findsOneWidget);
      expect(find.text('Event name 3'), findsOneWidget);
      expect(find.text('Event name 4'), findsOneWidget);
      expect(find.text('Event name 5'), findsOneWidget);
   
 //when you check something6 something7 it fails
    
  });
}
// GitHub\WhatsOn-UP\src\Frontend> flutter test test/Event-card-and-cancelation.dart how you should run it
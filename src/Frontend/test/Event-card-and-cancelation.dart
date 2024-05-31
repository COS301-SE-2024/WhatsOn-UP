import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  testWidgets('RsvpEventsPage should display events and remove them correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RsvpEventsPage(),
      ),
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel').first);
    await tester.pumpAndSettle();

  
    await tester.tap(find.widgetWithText(CupertinoDialogAction, 'Delete').first);
    await tester.pumpAndSettle();

    
      expect(find.text('something1'), findsNothing);
      expect(find.text('something2'), findsOneWidget);
      expect(find.text('something3'), findsOneWidget);
      expect(find.text('something4'), findsOneWidget);
      expect(find.text('something5'), findsOneWidget);
 //when you check something6 something7 it fails
    
  });
}
// GitHub\WhatsOn-UP\src\Frontend> flutter test test/Event-card-and-cancelation.dart how you should run it
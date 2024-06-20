// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:firstapp/pages/home_page.dart';
//
//
// import 'package:firstapp/pages/rsvp_events_page.dart';
// import 'package:firstapp/pages/calendar_page.dart';
// import 'package:firstapp/pages/explore_page.dart';
// import 'package:firstapp/pages/settings_page.dart';
// import 'package:firstapp/widgets/nav_bar.dart';
// import 'package:firstapp/pages/profilePage.dart';
// import 'package:firstapp/pages/home_page.dart'; // Import your HomePage here
//
// void main() {
//   testWidgets('Navigation test', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: HomePage()));
//
//
//     expect(find.byType(HomePage), findsOneWidget);
//
//
//     await tester.tap(find.text('RSVP Events'));
//     await tester.pumpAndSettle();
//     expect(find.byType(RsvpEventsPage), findsOneWidget);
//
//
//     await tester.tap(find.text('Calendar'));
//     await tester.pumpAndSettle();
//     expect(find.byType(CalendarPage), findsOneWidget);
//
//
//     await tester.tap(find.text('Explore'));
//     await tester.pumpAndSettle();
//     expect(find.byType(ExplorePage), findsOneWidget);
//
//
//     await tester.tap(find.text('Settings'));
//     await tester.pumpAndSettle();
//     expect(find.byType(SettingsPage), findsOneWidget);
//
//
//     await tester.tap(find.text('Home'));
//     await tester.pumpAndSettle();
//     expect(find.byType(HomePage), findsOneWidget);
//   });
// }

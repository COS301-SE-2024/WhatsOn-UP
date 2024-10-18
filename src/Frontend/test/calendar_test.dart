import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firstapp/pages/calendar_page.dart';
import 'package:firstapp/widgets/event_card.dart';

import 'api_test.mocks.dart';

void main() {
  group('CalendarPage Widget Tests', () {
       late MockEventProvider mockEventProvider;
    late MockuserProvider mockUserProvider;
    // late MockApi mockApi;
    setUpAll(() async {
      // mockApi = MockApi();
      mockEventProvider = MockEventProvider();
      mockUserProvider = MockuserProvider();

  });
    testWidgets('CalendarPage should have AppBar and Calendar', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: const MaterialApp(
            home: CalendarPage(),
          ),
        ),
      );

      expect(find.text('Calendar'), findsOneWidget);

      expect(find.byType(TableCalendar), findsOneWidget);
    });


    testWidgets('Calendar day selection changes state', (WidgetTester tester) async {
      when(mockUserProvider.role).thenReturn('ADMIN');
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EventProvider>(create: (_) => mockEventProvider),
            ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
          ],
          child: const MaterialApp(
            home: CalendarPage(),
          ),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(find.text('15'), findsOneWidget);
   });

    
  });
}

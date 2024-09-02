import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/rate_event.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'api_test.mocks.dart';

void main() {
  late MockApi mockApi;
  late MockuserProvider mockUserProvider;

  setUp(() {
    mockApi = MockApi();
    mockUserProvider = MockuserProvider();
  });

  Widget createWidgetUnderTest(String eventId, String eventName) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<userProvider>(create: (_) => mockUserProvider),
        Provider<Api>(create: (_) => mockApi),
      ],
      child: MaterialApp(
        home: RateEventPage(eventId: eventId, eventName: eventName),
      ),
    );
  }

  testWidgets('Displays initial UI elements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('1', 'Sample Event'));

    expect(find.text('Rate Event'), findsOneWidget);
    expect(find.text('Please rate the event "Sample Event"'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Submit Rating'), findsOneWidget);
  });

  testWidgets('User can select a rating', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('1', 'Sample Event'));

    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();

    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));
  });

  testWidgets('User can enter feedback', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('1', 'Sample Event'));

    await tester.enterText(find.byType(TextField), 'Wow very cool event');
    expect(find.text('Wow very cool event'), findsOneWidget);
  });
}

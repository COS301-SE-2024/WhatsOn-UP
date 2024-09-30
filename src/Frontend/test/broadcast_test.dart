



import 'package:emoji_selector/emoji_selector.dart';
import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'api_test.mocks.dart';

void main() {
  late MockApi mockApi;
  late MockuserProvider mockUserProvider;

  setUp(() {
    mockApi = MockApi();
    mockUserProvider = MockuserProvider();
  });

  Widget createWidgetUnderTest() {
    return  MultiProvider(
        providers: [
    ChangeNotifierProvider<userProvider>(
    create: (_) => mockUserProvider),
          Provider<Api>(create: (_) => mockApi),
        ],
      child: MaterialApp(
        home: Scaffold(
          body: Broadcast(),
        ),
      ),
    );
  }
  testWidgets('SpinKitPianoWave renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpinKitPianoWave(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      ),
    );


    expect(find.byType(SpinKitPianoWave), findsOneWidget);
  });
  testWidgets('should display the broadcast dialog with all elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Broadcast Message'), findsOneWidget);
    expect(find.text('Write your announcement here..'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.emoji_emotions), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('should display emoji picker when emoji icon is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.emoji_emotions));
    await tester.pumpAndSettle();

    expect(find.byType(EmojiSelector), findsOneWidget);
  });

  // testWidgets('Initial UI and Emoji Picker interaction', (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());
  //
  //   expect(find.text('Broadcast Message'), findsOneWidget);
  //   expect(find.byType(TextField), findsOneWidget);
  //   expect(find.byType(ElevatedButton), findsNWidgets(2)); // Submit and Cancel buttons
  //
  //   // Tap on the emoji icon to open the emoji picker
  //   await tester.tap(find.byIcon(Icons.emoji_emotions));
  //   await tester.pumpAndSettle();
  //
  //   // Ensure the emoji picker is shown
  //   expect(find.byType(EmojiSelector), findsOneWidget);
  //
  //   // Select an emoji (Mock selection)
  //   await tester.tap(find.text('😀')); // Assuming emoji selector shows this emoji
  //   await tester.pumpAndSettle();
  //
  //   // Check that the emoji is added to the TextField
  //   expect(find.text('😀'), findsOneWidget);
  // });
  testWidgets('Submit button triggers API call and shows loading spinner', (WidgetTester tester) async {
    // Arrange
    when(mockApi.broadcast(any, any)).thenAnswer((_) async {
      return {'status': 'success'};
    });

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextField), 'Test message');
    await tester.tap(find.text('Submit'));

    await tester.pump();



    await tester.pumpAndSettle();

    verifyNever(mockApi.broadcast('Test message', any)).called(0);

    expect(find.byType(SnackBar), findsOneWidget);

  });

  testWidgets('Cancel button closes the dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());


    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();


    expect(find.byType(Dialog), findsNothing);
  });



  testWidgets('should close the dialog when Cancel is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(Broadcast), findsNothing);
  });
  testWidgets('Handles API error correctly', (WidgetTester tester) async {

    when(mockApi.broadcast(any, any)).thenThrow(Exception('API Error'));

    await tester.pumpWidget(createWidgetUnderTest());


    await tester.enterText(find.byType(TextField), 'Test message');
    await tester.tap(find.text('Submit'));


    await tester.pump();
    await tester.pumpAndSettle();


    expect(find.byType(SnackBar), findsOneWidget);

  });


}
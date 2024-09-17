


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/surveys/studentdetail_survey.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:mockito/annotations.dart';
import 'api_test.mocks.dart';


@GenerateMocks([Api, userProvider])
void main() {
  const String jsonCategories = '''
  [
    {"id": "1", "name": "Category 1", "rating": "3.0", "faculty": ""},
    {"id": "2", "name": "Category 2", "rating": "4.0", "faculty": ""}
  ]
  ''';

  group('StudentdetailSurvey Widget Tests', ()
  {
    late MockApi mockApi;
    late MockuserProvider mockUserProvider;

    setUp(() {
      mockApi = MockApi();
      mockUserProvider = MockuserProvider();
    });

    testWidgets('Initial state is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<userProvider>.value(
          value: mockUserProvider,
          child: const MaterialApp(
            home: StudentdetailSurvey(jsonCategories: jsonCategories),
          ),
        ),
      );


      expect(find.text('Are you a student?'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNothing);
    });

    testWidgets('Checkbox interaction and faculty selection', (
        WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<userProvider>.value(
          value: mockUserProvider,
          child: const MaterialApp(
            home: StudentdetailSurvey(jsonCategories: jsonCategories),
          ),
        ),
      );


      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();


      expect(find.byType(DropdownButton<String>), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Select a faculty'),
        100.0,
      );
      await tester.tap(find.text('Select a faculty'));
      await tester.tap(find.text('Select a faculty'), warnIfMissed: false);
      await tester.pumpAndSettle();
      final facultyOption = find.byKey(const Key('Faculty of Education'));
      await tester.tap(facultyOption);

      expect(find.text('Faculty of Education'), findsOneWidget);
    });

    //
    // testWidgets('Submit button works and navigates on success', (
    //     WidgetTester tester) async {
    //   when(mockUserProvider.userId).thenReturn('123');
    //   when(mockApi.postRecommendationData(
    //       userId: anyNamed('userId'), data: anyNamed('data')))
    //       .thenAnswer((_) async => {'status': 'success'});
    //   await mockNetworkImages(() async {
    //     await tester.pumpWidget(
    //       ChangeNotifierProvider<userProvider>.value(
    //         value: mockUserProvider,
    //         child: MaterialApp(
    //           home: StudentdetailSurvey(jsonCategories: jsonEncode([
    //             {
    //               "id": "1",
    //               "name": "Category 1",
    //               "rating": "3.0",
    //               "faculty": "Faculty of Engineering, Built Environment and Information Technology"
    //             },
    //             {
    //               "id": "2",
    //               "name": "Category 2",
    //               "rating": "4.0",
    //               "faculty": "Faculty of Engineering, Built Environment and Information Technology"
    //             }
    //           ])),
    //         ),
    //       ),
    //     );
    //
    //
    //     await tester.tap(find.byType(Checkbox));
    //     await tester.pump();
    //     await tester.tap(find.text('Select a faculty'));
    //     await tester.pumpAndSettle();
    //     await tester.tap(find
    //         .text(
    //         'Faculty of Engineering, Built Environment and Information Technology')
    //         .first);
    //     await tester.pump();
    //
    //
    //     await tester.tap(find.text('Submit'));
    //     await tester.pumpAndSettle();
    //
    //
    //
    //
    //     expect(find.byType(ThankYouScreen), findsOneWidget);
    //   });
    // });
    // testWidgets('Handles API failure gracefully', (WidgetTester tester) async {
    //   when(mockUserProvider.userId).thenReturn('123');
    //   when(mockApi.postRecommendationData(
    //     userId: anyNamed('userId'),
    //     data: anyNamed('data'),
    //   )).thenThrow(Exception('API Error'));
    //
    //   await mockNetworkImages(() async {
    //     await tester.pumpWidget(
    //       ChangeNotifierProvider<userProvider>.value(
    //         value: mockUserProvider,
    //         child: MaterialApp(
    //           home: StudentdetailSurvey(jsonCategories: jsonCategories),
    //         ),
    //       ),
    //     );
    //
    //
    //     await tester.tap(find.byType(Checkbox));
    //     await tester.pump();
    //     await tester.scrollUntilVisible(
    //       find.text('Select a faculty'),
    //       100.0,
    //     );
    //     await tester.tap(find.text('Select a faculty'));
    //     await tester.tap(find.text('Select a faculty'), warnIfMissed: true);
    //     await tester.pumpAndSettle();
    //     await tester.tap(find.text(
    //         'Faculty of Engineering, Built Environment and Information Technology'
    //     ).first);
    //     await tester.pump();
    //
    //     await tester.tap(find.text('Submit'));
    //     await tester.pumpAndSettle();
    //
    //     // Verify the API call
    //     verify(mockApi.postRecommendationData(
    //       userId: '123',
    //       data: anyNamed('data'),
    //     )).called(1);
    //
    //
    //     expect(find.byType(ThankYouScreen), findsNothing);
    //
    //
    //     expect(find.text('An error occurred while submitting your data. Please try again later.'), findsOneWidget);
    //   });
    // });


    });
  }

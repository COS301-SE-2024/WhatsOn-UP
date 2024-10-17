import 'package:firstapp/surveys/studentdetail_survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firstapp/surveys/SurveyRateCat_screen.dart';


void main() {
  group('SurveyratecatScreen Tests', () {
    const String jsonCategories = '''
    [
      {"id": "1", "name": "Category 1", "rating": "3.0", "faculty": "Engineering"},
      {"id": "2", "name": "Category 2", "rating": "4.0", "faculty": "Science"}
    ]
    ''';

    testWidgets('Categories are parsed and displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SurveyratecatScreen(jsonCategories: jsonCategories),
        ),
      );
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);
    });

    testWidgets('Rating is updated correctly', (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: SurveyratecatScreen(jsonCategories: jsonCategories),
        ),
      );


      await tester.tap(find.byIcon(Icons.star).first);
      await tester.pump();


      final updatedRatingBar = tester.widget<RatingBar>(find.byType(RatingBar).first);
      expect(updatedRatingBar.itemCount, equals(5));
    });

    testWidgets('saveSelectedCategories works and navigates to next screen', (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: SurveyratecatScreen(jsonCategories: jsonCategories),
        ),
      );


      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();


      expect(find.byType(StudentdetailSurvey), findsOneWidget);


      final StudentdetailSurvey studentdetailSurvey = tester.widget(find.byType(StudentdetailSurvey));
      expect(studentdetailSurvey.jsonCategories, contains('"id":"1"'));
      expect(studentdetailSurvey.jsonCategories, contains('"rating":"3.0"'));
    });

    testWidgets('Handles empty or malformed JSON gracefully', (WidgetTester tester) async {

      await tester.pumpWidget(
        const MaterialApp(
          home: SurveyratecatScreen(jsonCategories: '[]'),
        ),
      );
      expect(find.byType(ListTile), findsNothing);

      await tester.pumpWidget(
        const MaterialApp(
          home: SurveyratecatScreen(jsonCategories: 'invalid-json'),
        ),
      );
      expect(find.byType(ListTile), findsNothing);
    });
  });
}

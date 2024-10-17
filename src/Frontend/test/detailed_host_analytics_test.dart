import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/pages/detailed_host_analytics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  group('AnalyticsDetailPage Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('AnalyticsDetailPage displays user name in AppBar', (WidgetTester tester) async {
      final Map<String, dynamic> userData = {
        'monthlySummaries': [],
        'overallSummary': {
          'totalDuration': 0,
          'averageRating': 0.0,
          'medianRating': 0.0,
          'highestRating': 0,
          'lowestRating': 0,
          'mode': 0,
          'skewness': 0.0,
          'outliers': [],
          'rsvpRatio': 0.0,
          'capacityRatio': 0.0,
          'attendanceRatio': 0.0,
          'feedbackRatio': 0.0
        }
      };

      await tester.pumpWidget(MaterialApp(
        home: AnalyticsDetailPage(name: 'Test User', userData: userData),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('AnalyticsDetailPage displays "No monthly data available" when monthlySummaries is empty', (WidgetTester tester) async {
      final Map<String, dynamic> userData = {
        'monthlySummaries': [],
        'overallSummary': {
          'totalDuration': 0,
          'averageRating': 0.0,
          'medianRating': 0.0,
          'highestRating': 0,
          'lowestRating': 0,
          'mode': 0,
          'skewness': 0.0,
          'outliers': [],
          'rsvpRatio': 0.0,
          'capacityRatio': 0.0,
          'attendanceRatio': 0.0,
          'feedbackRatio': 0.0
        }
      };

      await tester.pumpWidget(MaterialApp(
        home: AnalyticsDetailPage(name: 'Test User', userData: userData),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('No monthly data available for Test User'), findsOneWidget);
    });

    testWidgets('AnalyticsDetailPage displays charts when monthlySummaries is not empty', (WidgetTester tester) async {
      final Map<String, dynamic> userData = {
        'monthlySummaries': [
          {
            'month': 'Jan',
            'averageRating': 4.5,
            'capacityRatio': 0.8,
            'attendanceRatio': 0.9,
            'feedbackRatio': 0.7,
            'rsvpRatio': 0.85,
            'duration': 2.5,
            'highestRating': 5.0,
            'medianRating': 4.0,
            'lowestRating': 3.0,
            'skewness': 0.1
          }
        ],
        'overallSummary': {
          'totalDuration': 0,
          'averageRating': 0.0,
          'medianRating': 0.0,
          'highestRating': 0,
          'lowestRating': 0,
          'mode': 0,
          'skewness': 0.0,
          'outliers': [],
          'rsvpRatio': 0.0,
          'capacityRatio': 0.0,
          'attendanceRatio': 0.0,
          'feedbackRatio': 0.0
        }
      };

      await tester.pumpWidget(MaterialApp(
        home: AnalyticsDetailPage(name: 'Test User', userData: userData),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(SfCartesianChart), findsNWidgets(3));
      // expect(find.byType(SfCircularChart), findsOneWidget);
    });

    testWidgets('AnalyticsChartPage displays correct data', (WidgetTester tester) async {
      final List<MonthlySummary> monthlySummaries = [
        MonthlySummary(
          month: 'Jan',
          averageRating: 4.5,
          capacityRatio: 0.8,
          attendanceRatio: 0.9,
          feedbackRatio: 0.7,
          rsvpRatio: 0.85,
          duration: 2.5,
          highestRating: 5.0,
          medianRating: 4.0,
          lowestRating: 3.0,
          skewness: 0.1
        )
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AnalyticsChartPage(monthlySummaries: monthlySummaries),
        ),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(SfCartesianChart), findsOneWidget);
      final SfCartesianChart chart = tester.widget(find.byType(SfCartesianChart));
      expect(chart.series.length, 1);
      expect(chart.series[0].dataSource, monthlySummaries);
    });
  });
}
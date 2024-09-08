import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsDetailPage extends StatelessWidget {
  final String name;
  final Map<String, dynamic> userData;

  AnalyticsDetailPage({required this.name, required this.userData});

  @override
  Widget build(BuildContext context) {
    final monthlySummaries = (userData['monthlySummaries'] as List)
        .map((summary) => MonthlySummary.fromJson(summary))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (monthlySummaries.isNotEmpty) ...[
              SizedBox(
                height: 300,
                child: AnalyticsChartPage(monthlySummaries: monthlySummaries),
              ),

            ] else
              Center(child: Text('No monthly data available for $name')),
          ],
        ),
      ),
    );
  }
}

class AnalyticsChartPage extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  AnalyticsChartPage({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Average Rating Over Time'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 5,
        interval: 1,
        title: AxisTitle(text: 'Average Rating'),
      ),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Average Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.averageRating,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}


class MonthlySummary {
  final String month;
  final double averageRating;
  final double capacityRatio;
  final double attendanceRatio;
  final double feedbackRatio;
  final double rsvpRatio;
  final double duration;
  final double highestRating;
  final double medianRating;
  final double lowestRating;
  final double skewness;

  MonthlySummary({
    required this.month,
    required this.averageRating,
    required this.capacityRatio,
    required this.attendanceRatio,
    required this.feedbackRatio,
    required this.rsvpRatio,
    required this.duration,
    required this.highestRating,
    required this.medianRating,
    required this.lowestRating,
    required this.skewness,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      month: json['month'],
      averageRating: json['averageRating'].toDouble(),
      capacityRatio: json['capacityRatio'].toDouble(),
      attendanceRatio: json['attendanceRatio'].toDouble(),
      feedbackRatio: json['feedbackRatio'].toDouble(),
      rsvpRatio: json['rsvpRatio'].toDouble(),
      duration: json['duration'].toDouble(),
      highestRating: json['highestRating'].toDouble(),
      medianRating: json['medianRating'].toDouble(),
      lowestRating: json['lowestRating'].toDouble(),
      skewness: json['skewness'].toDouble(),
    );
  }
}


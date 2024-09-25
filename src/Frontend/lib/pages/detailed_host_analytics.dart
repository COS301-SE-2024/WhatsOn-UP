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
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final monthlySummaries = (userData['monthlySummaries'] as List)
        .map((summary) => MonthlySummary.fromJson(summary))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (monthlySummaries.isNotEmpty) ...[
                _buildSectionHeader('Average Rating Over Time', Icons.star),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 300,
                    child: AnalyticsChartPage(monthlySummaries: monthlySummaries), // Average Rating Over Time
                  ),
                ),
              const SizedBox(height: 20),

                _buildSectionHeader('Rating Distrubtion', Icons.bar_chart),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 300,
                    child: RatingDistributionChart(monthlySummaries: monthlySummaries), // Rating Distribution
                  ),
                ),
              const SizedBox(height: 20),

                _buildSectionHeader('Feedback Distribution', Icons.pie_chart),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 300,
                    child: FeedbackDistributionChart(monthlySummaries: monthlySummaries), // Feedback Distribution
                  ),
                ),
                const SizedBox(height: 20),

                _buildSectionHeader('Event Duration vs Average Rating', Icons.scatter_plot),
                Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 300,
                    child: EventDurationVsRatingChart(monthlySummaries: monthlySummaries), // Event Duration vs Average Rating
                  ),
                ),
              ] else
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 64, color: Color.fromARGB(255, 119, 119, 119),),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'No monthly data available for $name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 119, 119, 119),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
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
      // title: const ChartTitle(text: 'Average Rating Over Time'),
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

class RatingDistributionChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  RatingDistributionChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // title: ChartTitle(text: 'Rating Distribution'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <ColumnSeries>[
        ColumnSeries<MonthlySummary, String>(
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.lowestRating,
          name: 'Lowest Rating',
        ),
        ColumnSeries<MonthlySummary, String>(
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.averageRating,
          name: 'Average Rating',
        ),
        ColumnSeries<MonthlySummary, String>(
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.highestRating,
          name: 'Highest Rating',
        ),
      ],
    );
  }
}

class FeedbackDistributionChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  FeedbackDistributionChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      // title: ChartTitle(text: 'Feedback Distribution'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<MonthlySummary, String>(
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.feedbackRatio,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class EventDurationVsRatingChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  EventDurationVsRatingChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // title: ChartTitle(text: 'Event Duration vs Average Rating'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: NumericAxis(title: AxisTitle(text: 'Duration (hours)')),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Average Rating')),
      series: <ScatterSeries>[
        ScatterSeries<MonthlySummary, double>(
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.duration,
          yValueMapper: (MonthlySummary summary, _) => summary.averageRating,
          name: 'Events',
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
      month: json['month'] ?? 'Unknown',
      averageRating: _roundNum(json['averageRating']?.toDouble() ?? 0.0),
      capacityRatio: _roundNum(json['capacityRatio']?.toDouble() ?? 0.0),
      attendanceRatio: _roundNum(json['attendanceRatio']?.toDouble() ?? 0.0),
      feedbackRatio: _roundNum(json['feedbackRatio']?.toDouble() ?? 0.0),
      rsvpRatio: _roundNum(json['rsvpRatio']?.toDouble() ?? 0.0),
      duration: _roundNum(json['duration']?.toDouble() ?? 0.0),
      highestRating: _roundNum(json['highestRating']?.toDouble() ?? 0.0),
      medianRating: _roundNum(json['medianRating']?.toDouble() ?? 0.0),
      lowestRating: _roundNum(json['lowestRating']?.toDouble() ?? 0.0),
      skewness: _roundNum(json['skewness']?.toDouble() ?? 0.0),
    );
  }


  static double _roundNum(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}


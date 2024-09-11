import 'package:firstapp/pages/detailed_host_analytics.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AdminAnalyticsPage extends StatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  _AdminAnalyticsPageState createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends State<AdminAnalyticsPage> with SingleTickerProviderStateMixin {
    bool isLoading = true;
    bool isNamesLoading = true;
    late TabController _tabController;
    Api api = Api();
    List<MonthlySummary> monthlySummaries = [];
    List<Map<String, dynamic>> userData = [];
    List<Map<String, dynamic>> filteredUserData = [];
    TextEditingController searchController = TextEditingController();


    Future<void> _getAllEventsAnalytics() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      final response = await api.getAllEventsAnalytics(userP.userId);
      // print('EVENTS ANALYTICS RESPONSE: $response');

      List<MonthlySummary> summaries = parseMonthlySummaries(response['data']);

      setState(() {
        monthlySummaries = summaries;
        isLoading = false;
      });
    } 
    catch (e) {
      print('Error getting events analytics: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchHostData() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      final response = await api.getAllHostsAnalytics(userP.userId);

      // print("HOST DATA: $response");

      setState(() {
        userData = List<Map<String, dynamic>>.from(response['data']);
        filteredUserData = userData;

        // print("USER DATA: $userData");
        // print("FILTERED USER DATA: $filteredUserData");

        isNamesLoading = false;
      });
    }
    catch (e) {
      print('Error getting host analytics: $e');
      setState(() {
        isNamesLoading = false;
      });
    }

  }

  void filterSearchResults(String query) {
    setState(() {
      filteredUserData = userData
        .where((user) => user.keys.first.toLowerCase().contains(query.toLowerCase()))
        .toList();
    });
  }


   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getAllEventsAnalytics();
    _fetchHostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 196, 179, 97),
            labelColor: const Color.fromARGB(255, 196, 179, 97),
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 4,
            indicatorPadding: const EdgeInsets.only(bottom: 12),
            tabs: const [
              Tab(text: 'All Events'),
              Tab(text: 'Host Data'),
            ],
          ),
        ),
        body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllEventsTab(),
          _buildHostData(),
        ],
      ),
    );
  }
  
  Widget _buildAllEventsTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (monthlySummaries.isEmpty) {
      return const Center(
        child: Text('No analytics data available.'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: AnalyticsChartPage(monthlySummaries: monthlySummaries), // Average Rating Over Time
          ),
          SizedBox(
            height: 300,
            child: CapacityAttendanceChart(monthlySummaries: monthlySummaries), // Capacity and Attendance Ratios
          ),
          SizedBox(
            height: 300,
            child: FeedbackChart(monthlySummaries: monthlySummaries), // Feedback Ratio Over Time
          ),
          SizedBox(
            height: 300,
            child: RSVPChart(monthlySummaries: monthlySummaries), // RSVP Ratio Over Time
          ),
          SizedBox(
            height: 300,
            child: DurationChart(monthlySummaries: monthlySummaries), // Event Duration Over Time
          ),
          SizedBox(
            height: 300,
            child: RatingDistributionChart(monthlySummaries: monthlySummaries), // Rating Distribution
          ),
          SizedBox(
            height: 300,
            child: SkewnessChart(monthlySummaries: monthlySummaries), // Skewness Over Time
          ),
        ],
      ),
    );   
  }

  Widget _buildHostData() {
    if (isNamesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: filterSearchResults,
            decoration: const InputDecoration(
              labelText: 'Search for a host',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUserData.length,
            itemBuilder: (context, index) {
              String name = filteredUserData[index].keys.first;
              // print("USER DATA: " + filteredUserData[index][name].toString());
              return ListTile(
                title: Text(name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnalyticsDetailPage(
                        name: name,
                        userData: filteredUserData[index][name],
                      ),
                    ),
                  );
                },
              );
            },
          ),
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
}

List<MonthlySummary> parseMonthlySummaries(dynamic data) {
  List<MonthlySummary> summaries = [];
  for (var summary in data['monthlySummaries']) {
    summaries.add(MonthlySummary(
      month: summary['month'] ?? 'Unknown',
      averageRating: _roundNum((summary['averageRating'] ?? 0).toDouble()),
      capacityRatio: _roundNum((summary['capacityRatio'] ?? 0).toDouble()),
      attendanceRatio: _roundNum((summary['attendanceRatio'] ?? 0).toDouble()),
      feedbackRatio: _roundNum(
        summary['feedbackRatio'] == "NaN" || summary['feedbackRatio'] == null
          ? 0.0
          : (double.tryParse(summary['feedbackRatio'].toString()) ?? 0.0),
      ),
      rsvpRatio: _roundNum(
        summary['rsvpRatio'] == "NaN" || summary['rsvpRatio'] == null
          ? 0.0
          : (double.tryParse(summary['rsvpRatio'].toString()) ?? 0.0),
      ),
      duration: _roundNum((summary['duration'] ?? 0).toDouble()),
      highestRating: _roundNum((summary['highestRating'] ?? 0).toDouble()),
      medianRating: _roundNum((summary['medianRating'] ?? 0).toDouble()),
      lowestRating: _roundNum((summary['lowestRating'] ?? 0).toDouble()),
      skewness: _roundNum((summary['skewness'] ?? 0).toDouble()),
    ));
  }
  return summaries;
}

double _roundNum(double value) {
  return double.parse(value.toStringAsFixed(2));
}



class AnalyticsChartPage extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const AnalyticsChartPage({super.key, required this.monthlySummaries});

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


class CapacityAttendanceChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const CapacityAttendanceChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Capacity & Attendance Ratios'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<MonthlySummary, String>(
          name: 'Capacity Ratio',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.capacityRatio,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<MonthlySummary, String>(
          name: 'Attendance Ratio',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.attendanceRatio,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class FeedbackChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const FeedbackChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Feedback Ratio Over Time'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 10,
        title: AxisTitle(text: 'Feedback Ratio (%)'),
      ),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Feedback Ratio',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.feedbackRatio,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}


class RSVPChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const RSVPChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'RSVP Ratio Over Time'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'RSVP Ratio',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.rsvpRatio,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class DurationChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const DurationChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Event Duration Over Time'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Duration',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.duration,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}


class RatingDistributionChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const RatingDistributionChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Rating Distribution'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<MonthlySummary, String>(
          name: 'Highest Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.highestRating,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<MonthlySummary, String>(
          name: 'Median Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.medianRating,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<MonthlySummary, String>(
          name: 'Lowest Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.lowestRating,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class SkewnessChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const SkewnessChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Skewness Over Time'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        minimum: -2,
        maximum: 2,
        interval: 0.5,
        title: AxisTitle(text: 'Skewness'),
      ),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Skewness',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.skewness,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

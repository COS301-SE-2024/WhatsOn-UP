import 'package:firstapp/pages/detailed_host_analytics.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AdminAnalyticsPage extends StatefulWidget {
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
      print('EVENTS ANALYTICS RESPONSE: $response');

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

      setState(() {
        userData = List<Map<String, dynamic>>.from(response['data']);
        filteredUserData = userData;

        print("USER DATA: $userData");
        print("FILTERED USER DATA: $filteredUserData");

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
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUserData.length,
            itemBuilder: (context, index) {
              String name = filteredUserData[index].keys.first;
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
  // final int outliers;


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
    // required this.outliers,
  });
}

List<MonthlySummary> parseMonthlySummaries(dynamic data) {
  List<MonthlySummary> summaries = [];
  for (var summary in data['monthlySummaries']) {
    summaries.add(MonthlySummary(
      month: summary['month'],
      averageRating: summary['averageRating'].toDouble(),
      capacityRatio: summary['capacityRatio'].toDouble(),
      attendanceRatio: summary['attendanceRatio'].toDouble(),
      feedbackRatio: summary['feedbackRatio'].toDouble(),
      rsvpRatio: summary['rsvpRatio'].toDouble(),
      duration: summary['duration'].toDouble(),
      highestRating: summary['highestRating'].toDouble(),
      medianRating: summary['medianRating'].toDouble(),
      lowestRating: summary['lowestRating'].toDouble(),
      skewness: summary['skewness'].toDouble(),
      // outliers: summary['outliers'],
    ));
  }
  return summaries;
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


class CapacityAttendanceChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  CapacityAttendanceChart({required this.monthlySummaries});

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

  FeedbackChart({required this.monthlySummaries});

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

  RSVPChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'RSVP Ratio Over Time'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'RSVP Ratio',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.rsvpRatio,
          markerSettings: MarkerSettings(isVisible: true),
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class DurationChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  DurationChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Event Duration Over Time'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Duration',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.duration,
          markerSettings: MarkerSettings(isVisible: true),
          dataLabelSettings: DataLabelSettings(isVisible: true),
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
      title: ChartTitle(text: 'Rating Distribution'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries>[
        ColumnSeries<MonthlySummary, String>(
          name: 'Highest Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.highestRating,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<MonthlySummary, String>(
          name: 'Median Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.medianRating,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<MonthlySummary, String>(
          name: 'Lowest Rating',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.lowestRating,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class SkewnessChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  SkewnessChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Skewness Over Time'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: -1,
        maximum: 1,
        interval: 0.5,
        title: AxisTitle(text: 'Skewness'),
      ),
      series: <LineSeries<MonthlySummary, String>>[
        LineSeries<MonthlySummary, String>(
          name: 'Skewness',
          dataSource: monthlySummaries,
          xValueMapper: (MonthlySummary summary, _) => summary.month,
          yValueMapper: (MonthlySummary summary, _) => summary.skewness,
          markerSettings: MarkerSettings(isVisible: true),
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

// class OutliersChart extends StatelessWidget {
//   final List<MonthlySummary> monthlySummaries;

//   OutliersChart({required this.monthlySummaries});

//   @override
//   Widget build(BuildContext context) {
//     return SfCartesianChart(
//       title: ChartTitle(text: 'Outliers Count Over Time'),
//       legend: Legend(isVisible: true),
//       tooltipBehavior: TooltipBehavior(enable: true),
//       primaryXAxis: CategoryAxis(),
//       series: <ColumnSeries<MonthlySummary, String>>[
//         ColumnSeries<MonthlySummary, String>(
//           name: 'Outliers Count',
//           dataSource: monthlySummaries,
//           xValueMapper: (MonthlySummary summary, _) => summary.month,
//           yValueMapper: (MonthlySummary summary, _) => summary.outliers.toDouble(),
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//         ),
//       ],
//     );
//   }
// }
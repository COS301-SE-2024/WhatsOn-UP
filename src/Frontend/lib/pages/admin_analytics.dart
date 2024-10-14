import 'package:firstapp/pages/detailed_host_analytics.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    bool isPopularEventsLoading = true;
    late TabController _tabController;
    Api api = Api();
    List<MonthlySummary> monthlySummaries = [];
    List<Map<String, dynamic>> userData = [];
    List<Map<String, dynamic>> filteredUserData = [];
    TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> popularEvents = [];


    Future<void> _getAllEventsAnalytics() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      final response = await api.getAllEventsAnalytics(userP.JWT);
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
      final response = await api.getAllHostsAnalytics(userP.JWT);

      setState(() {
        userData = List<Map<String, dynamic>>.from(response['data']);
        filteredUserData = userData;

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

  Future<void> _fetchPopularEvents() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      final response = await api.getAllPopularEvents(userP.JWT);
      // print('POPULAR EVENTS RESPONSE: $response');

      setState(() {
        popularEvents = List<Map<String, dynamic>>.from(response['data']);
        isPopularEventsLoading = false;
      });
    } 
    catch (e) {
      print('Error getting popular events: $e');
      setState(() {
        isPopularEventsLoading = false;
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
    _fetchPopularEvents();
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

    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

  if (monthlySummaries.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Color.fromARGB(255, 119, 119, 119),),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No analytics data available.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 119, 119, 119),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Top 5 Most Popular Events', Icons.trending_up),
          isPopularEventsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Card(
            color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: PopularEventsWidget(popularEvents: popularEvents), // Popular Events
          ),
          const SizedBox(height: 20),
          
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
          
          _buildSectionHeader('RSVP and Attendance Ratios', Icons.people),
          Card(
            color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 300,
              child: CapacityAttendanceChart(monthlySummaries: monthlySummaries), // RSVP and Attendance Ratios
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionHeader('Feedback Ratio Over Time', Icons.reviews),
          Card(
            color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 300,
              child: FeedbackChart(monthlySummaries: monthlySummaries), // Feedback Ratio Over Time
            ),
          ),
          // const SizedBox(height: 20),
          
          // _buildSectionHeader('RSVP Ratio Over Time', Icons.event_available),
          // Card(
          //   color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
          //   elevation: 4,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: SizedBox(
          //     height: 300,
          //     child: RSVPChart(monthlySummaries: monthlySummaries), // RSVP Ratio Over Time
          //   ),
          // ),
          // const SizedBox(height: 20),

          // _buildSectionHeader('Total Event Duration Per Month', Icons.timer),
          // Card(
          //   color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
          //   elevation: 4,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: SizedBox(
          //     height: 300,
          //     child: DurationChart(monthlySummaries: monthlySummaries), // Event Duration Over Time
          //   ),
          // ),
          // const SizedBox(height: 20),

          // _buildSectionHeader('Rating Distribution', Icons.bar_chart),
          // Card(
          //   color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
          //   elevation: 4,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: SizedBox(
          //     height: 300,
          //     child: RatingDistributionChart(monthlySummaries: monthlySummaries), // Rating Distribution
          //   ),
          // ),
          // const SizedBox(height: 20),

          // _buildSectionHeader('Skewness Over Time', Icons.insights),
          // Card(
          //   color: isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50,
          //   elevation: 4,
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   child: SizedBox(
          //     height: 300,
          //     child: SkewnessChart(monthlySummaries: monthlySummaries), // Skewness Over Time
          //   ),
          // ),
        ],
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
              String name = '';
              if (filteredUserData.isNotEmpty && filteredUserData[index].isNotEmpty) {

                name = filteredUserData[index].keys.first;

              } else {

                print('No user data available at index $index');

              }
              String profileImageUrl = filteredUserData[index][name]['profileImage'] ?? "";

              bool isValidNetworkImage = Uri.tryParse(profileImageUrl)?.hasAbsolutePath ?? false;

              ImageProvider profileImageProvider;

              if (!isValidNetworkImage) {
                profileImageProvider = const AssetImage('assets/images/user.png');
              } 
              else {
                profileImageProvider = NetworkImage(profileImageUrl);
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: profileImageProvider,
                  radius: 24,
                ),
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

String _getMonthAbbreviation(String month) {
  const monthAbbreviations = {
    'JANUARY': 'JAN',
    'FEBRUARY': 'FEB',
    'MARCH': 'MAR',
    'APRIL': 'APR',
    'MAY': 'MAY',
    'JUNE': 'JUN',
    'JULY': 'JUL',
    'AUGUST': 'AUG',
    'SEPTEMBER': 'SEP',
    'OCTOBER': 'OCT',
    'NOVEMBER': 'NOV',
    'DECEMBER': 'DEC',
  };

  return monthAbbreviations[month.toUpperCase()] ?? month;
}

class AnalyticsChartPage extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const AnalyticsChartPage({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
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
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.averageRating,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Average Rating Over Time'),
                    content: const Text(
                      'This chart displays the average rating over time for all events in the app. '
                      'Each point represents the average rating for all events for a specific month. '
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
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

class CapacityAttendanceChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const CapacityAttendanceChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'Capacity & Attendance Ratios'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 100,
          ),
          series: <CartesianSeries>[
            ColumnSeries<MonthlySummary, String>(
              name: 'RSVP Ratio',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.rsvpRatio,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            ColumnSeries<MonthlySummary, String>(
              name: 'Attendance Ratio',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.attendanceRatio,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RSVP & Attendance Ratios'),
          content: const Text(
            'This chart compares the rsvp ratio and attendance ratio over time for all events. '
            'The RSVP ratio represents the proportion of RSVPs relative to the total number of potential attendees, '
            'while the attendance ratio indicates the proportion of expected attendees who actually showed up.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}


class FeedbackChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const FeedbackChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'Feedback Ratio Over Time'),
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
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.feedbackRatio,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback Ratio Over Time'),
          content: const Text(
            'This chart displays the feedback ratio over time for all events. '
            'The feedback ratio represents the percentage of attendees who provided feedback after each event. '
            'A higher ratio indicates more engagement from the participants.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}


class RSVPChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const RSVPChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'RSVP Ratio Over Time'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: const CategoryAxis(),
          series: <LineSeries<MonthlySummary, String>>[
            LineSeries<MonthlySummary, String>(
              name: 'RSVP Ratio',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.rsvpRatio,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('RSVP Ratio Over Time'),
          content: const Text(
            'This chart shows the RSVP ratio over time for all events. '
            'The RSVP ratio represents the proportion of RSVPs relative to the total number of potential attendees. '
            'A lower ratio might indicate that users might not have been that interested in the events happening that month.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class DurationChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const DurationChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'Event Duration Over Time'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: const CategoryAxis(),
          series: <LineSeries<MonthlySummary, String>>[
            LineSeries<MonthlySummary, String>(
              name: 'Duration',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.duration,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total Event Duration Per Month'),
          content: const Text(
            'This chart displays the total duration of all events that occurred each month. '
            'The duration is measured in hours. '
            'This information can help in understanding trends in event length and planning future events.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}


class RatingDistributionChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const RatingDistributionChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'Rating Distribution'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            maximum: 5,
          ),
          series: <CartesianSeries>[
            ColumnSeries<MonthlySummary, String>(
              name: 'Highest Rating',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.highestRating,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            ColumnSeries<MonthlySummary, String>(
              name: 'Median Rating',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.medianRating,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            ColumnSeries<MonthlySummary, String>(
              name: 'Lowest Rating',
              dataSource: monthlySummaries,
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.lowestRating,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rating Distribution'),
          content: const Text(
            'This chart shows the distribution of ratings over time for all events. '
            'It displays the highest, median, and lowest ratings for each month. '
            'This helps in understanding the range and central tendency of event ratings.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class SkewnessChart extends StatelessWidget {
  final List<MonthlySummary> monthlySummaries;

  const SkewnessChart({super.key, required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          // title: const ChartTitle(text: 'Skewness Over Time'),
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
              xValueMapper: (MonthlySummary summary, _) =>  _getMonthAbbreviation(summary.month),
              yValueMapper: (MonthlySummary summary, _) => summary.skewness,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Skewness Over Time'),
          content: const Text(
            'This chart displays the skewness of ratings over time for all events. '
            'Skewness measures the asymmetry of the rating distribution. '
            'Positive skewness indicates that events received higher ratings, '
            'while negative skewness indicates that events received lower ratings. '
            'A skewness of 0 suggests a symmetrical distribution.'
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}


class PopularEventsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> popularEvents;

  const PopularEventsWidget({Key? key, required this.popularEvents}) : super(key: key);

  @override
  _PopularEventsWidgetState createState() => _PopularEventsWidgetState();
}

class _PopularEventsWidgetState extends State<PopularEventsWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_showArrow) {
        setState(() {
          _showArrow = false;
        });
      }
    } else {
      if (!_showArrow) {
        setState(() {
          _showArrow = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Padding(
        //   padding: EdgeInsets.all(16.0),
        //   child: Text(
        //     'Top 5 most Popular Events',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.popularEvents.length,
            itemBuilder: (context, index) {
              final event = widget.popularEvents[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        event: Event.fromJson(event),
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Host: ${event['hosts'][0]['fullName']}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Date: ${event['startDateTime'].split('T')[0]}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Attendees: ${event['attendees'].length}/${event['maxAttendees']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Avg. Rating: ${event['averageRating'].toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 24,
          child: Center(
            child: AnimatedOpacity(
              opacity: _showArrow ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Event Details', Icons.event),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.description, style: TextStyle(fontSize: 16, color: textColor)),
                    const SizedBox(height: 16),
                    _buildDetailRow("Hosts", event.hosts.map((host) => host['fullName']).join(', '), textColor),
                    _buildDetailRow('Date', DateFormat('dd MMM yyyy, HH:mm').format(event.startDateTime), textColor),
                    _buildDetailRow('Attendees', '${event.attendees.length}/${event.maxAttendees}', textColor),
                    _buildDetailRow('Average Rating', event.averageRating.toStringAsFixed(1), textColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Feedback Distribution', Icons.bar_chart),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    title: const ChartTitle(text: 'Feedback Distribution'),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: const CategoryAxis(
                      title: AxisTitle(text: 'Rating'),
                    ),
                    primaryYAxis: const NumericAxis(
                      minimum: 0,
                      interval: 1,
                      title: AxisTitle(text: 'Feedback Count'),
                    ),
                    series: <ColumnSeries>[
                      ColumnSeries<Map<String, dynamic>, String>(
                        dataSource: [1, 2, 3, 4, 5].map((rating) => {
                          'rating': rating.toString(),
                          'count': event.feedback.where((f) => f['rating'] == rating).length,
                        }).toList(),
                        xValueMapper: (data, _) => data['rating'],
                        yValueMapper: (data, _) => data['count'],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Event Statistics', Icons.insert_chart),
            Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatisticRow('Median Rating', event.medianRating.toString(), textColor),
                    _buildStatisticRow('Highest Rating', event.highestRating.toString(), textColor),
                    _buildStatisticRow('Lowest Rating', event.lowestRating.toString(), textColor),
                    _buildStatisticRow('RSVP Ratio', '${event.rsvpRatio.toStringAsFixed(2)}%', textColor),
                    _buildStatisticRow('Capacity Ratio', '${event.capacityRatio.toStringAsFixed(2)}%', textColor),
                    _buildStatisticRow('Attendance Ratio', '${event.attendanceRatio.toStringAsFixed(2)}%', textColor),
                    _buildStatisticRow('Feedback Ratio', '${event.feedbackRatio.toStringAsFixed(2)}%', textColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionHeader(String title, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 28, color: Colors.blueGrey),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ],
  );
}

Widget _buildDetailRow(String label, String value, Color textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: textColor)),
      ],
    ),
  );
}

Widget _buildStatisticRow(String label, String value, Color textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: textColor)),
      ],
    ),
  );
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final int maxAttendees;
  final List<dynamic> attendees;
  final double averageRating;
  final double medianRating;
  final int highestRating;
  final int lowestRating;
  final int mode;
  final double skewness;
  final double rsvpRatio;
  final double capacityRatio;
  final double attendanceRatio;
  final double feedbackRatio;
  final List<dynamic> feedback;
  final List<dynamic> hosts;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.maxAttendees,
    required this.attendees,
    required this.averageRating,
    required this.medianRating,
    required this.highestRating,
    required this.lowestRating,
    required this.mode,
    required this.skewness,
    required this.rsvpRatio,
    required this.capacityRatio,
    required this.attendanceRatio,
    required this.feedbackRatio,
    required this.feedback,
    required this.hosts,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: (json['title'] ?? 'Unknown'),
      description: (json['description'] ?? 'Unknown'),
      startDateTime: DateTime.parse(json['startDateTime'] ?? ''),
      maxAttendees: (json['maxAttendees'] ?? 0),
      attendees: (json['attendees'] ?? []),
      averageRating: _roundNum((json['averageRating'] ?? 0.0).toDouble()),
      medianRating: _roundNum((json['medianRating'] ?? 0.0).toDouble()),
      highestRating: (json['highestRating'] ?? 0),
      lowestRating: (json['lowestRating'] ?? 0),
      mode: (json['mode'] ?? 0),
      skewness: _roundNum((json['skewness'] ?? 0.0).toDouble()),
      rsvpRatio: _roundNum((json['rsvpRatio'] ?? 0.0).toDouble()),
      capacityRatio: _roundNum((json['capacityRatio'] ?? 0.0).toDouble()),
      attendanceRatio: _roundNum((json['attendanceRatio'] ?? 0.0).toDouble()),
      feedbackRatio: _roundNum((json['feedbackRatio'] ?? 0.0).toDouble()),
      feedback: (json['feedback'] ?? []),
      hosts: (json['hosts'] ?? []),
    );
  }
}
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
      final response = await api.getAllHostsAnalytics(userP.JWT);

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

  Future<void> _fetchPopularEvents() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      final response = await api.getAllPopularEvents(userP.JWT);
      // print('POPULAR EVENTS RESPONSE: $response');

      setState(() {
        popularEvents = List<Map<String, dynamic>>.from(response['data']);
      });
    } 
    catch (e) {
      print('Error getting popular events: $e');
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

    if (monthlySummaries.isEmpty) {
      return const Center(
        child: const Column(
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
      child: Column(
        children: [
          PopularEventsWidget(popularEvents: popularEvents), // Popular Events
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Popular Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
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
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
            Text('Host: ${event.hosts[0]['fullName']}'),
            Text('Date: ${DateFormat('dd MMM yyyy, HH:mm').format(event.startDateTime)}'),
            Text('Attendees: ${event.attendees.length}/${event.maxAttendees}'),
            Text('Average Rating: ${event.averageRating.toStringAsFixed(1)}'),
            const SizedBox(height: 24),
            // Text('Feedback Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                title: const ChartTitle(text: 'Feedback Distribution'),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: const CategoryAxis(
                  title: AxisTitle(text: 'Rating'),
                ),
                primaryYAxis: const NumericAxis(
                  minimum: 0,
                  // maximum: event.attendees.length.toDouble(),
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
            const SizedBox(height: 24),
            const Text('Event Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Median Rating: ${event.medianRating}'),
            Text('Highest Rating: ${event.highestRating}'),
            Text('Lowest Rating: ${event.lowestRating}'),
            // Text('Mode: ${event.mode}'),
            // Text('Skewness: ${event.skewness.toStringAsFixed(2)}'),
            Text('RSVP Ratio: ${event.rsvpRatio.toStringAsFixed(2)}%'),
            Text('Capacity Ratio: ${event.capacityRatio.toStringAsFixed(2)}%'),
            Text('Attendance Ratio: ${event.attendanceRatio.toStringAsFixed(2)}%'),
            Text('Feedback Ratio: ${event.feedbackRatio.toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }
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

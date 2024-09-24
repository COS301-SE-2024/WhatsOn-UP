import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HostAnalyticsPage extends StatefulWidget {
  @override
  _HostAnalyticsPageState createState() => _HostAnalyticsPageState();
}

class _HostAnalyticsPageState extends State<HostAnalyticsPage> {
  Api api = Api();
  bool isLoading = true;
  List<Event> events = [];
  List<Map<String, dynamic>> popularEvents = [];

  Future<void> _getAllEventsAnalytics() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    try {
      // final response = await api.getHostEventAnalytics("69ae72bc-8e2b-4400-b608-29f048d4f8c7", userP.JWT);
      final response = await api.getHostEventAnalytics(userP.userId, userP.JWT);
      
      // print('EVENTS ANALYTICS RESPONSE: $response');

      List<Event> fetchedEvents = [];
      if (response['data'] != null && response['data'] is Map<String, dynamic>) {
        response['data'].forEach((month, monthEvents) {
          if (monthEvents is List) {
            fetchedEvents.addAll(monthEvents.map<Event>((event) => Event.fromJson(event)));
          }
        });
      }

      setState(() {
        events = fetchedEvents;
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

  Future<void> _getPopularEvents() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    try {
      final response = await api.getHostPopularEvents(userP.JWT);
      // final response = await api.getHostPopularEvents("69ae72bc-8e2b-4400-b608-29f048d4f8c7");
      // print('POPULAR EVENTS RESPONSE: $response');

      setState(() {
        popularEvents = List<Map<String, dynamic>>.from(response['data']);

        //  print("Popular events: $popularEvents");
      });
    } 
    catch (e) {
      print('Error getting popular events: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllEventsAnalytics();
    _getPopularEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Analytics'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty && popularEvents.isEmpty
              ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 64, color: Color.fromARGB(255, 119, 119, 119),),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        'No Events found!',
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
              )
              : EventAnalyticsDashboard(events: events, popularEvents: popularEvents),
    );
  }
}

class EventAnalyticsDashboard extends StatelessWidget {
  final List<Event> events;
  final List<Map<String, dynamic>> popularEvents;

  EventAnalyticsDashboard({required this.events, required this.popularEvents});

  @override
  Widget build(BuildContext context) {
    final sortedEvents = groupEventsByMonth(events);
    return ListView(
      children: [
        PopularEventsWidget(popularEvents: popularEvents),
        SizedBox(height: 24,),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'All My Events',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedEvents.length,
          itemBuilder: (context, index) {
            final month = sortedEvents.keys.elementAt(index);
            final monthEvents = sortedEvents[month]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    DateFormat('MMMM yyyy').format(DateTime(DateTime.now().year, month)),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: monthEvents.length,
                  itemBuilder: (context, index) => EventCard(event: monthEvents[index]),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

    Map<int, List<Event>> groupEventsByMonth(List<Event> events) {
      final groupedEvents = <int, List<Event>>{};
      for (var event in events) {
        final month = event.startDateTime.month;
        if (!groupedEvents.containsKey(month)) {
          groupedEvents[month] = [];
        }
        groupedEvents[month]!.add(event);
      }
      return Map.fromEntries(groupedEvents.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    }
  }

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    // print("Event: $event");
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(event.startDateTime)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Attendees: ${event.attendees.length}/${event.maxAttendees}'),
            Text('Rating: ${event.averageRating.toStringAsFixed(1)}'),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)),
        ),
      ),
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
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.blueGrey.shade50;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final iconColor = isDarkMode ? Colors.amber.shade200 : Colors.amber;

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 16),
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
            Text('RSVP Ratio: ${event.rsvpRatio.toStringAsFixed(2)}%'),
            Text('Capacity Ratio: ${event.capacityRatio.toStringAsFixed(2)}%'),
            Text('Attendance Ratio: ${event.attendanceRatio.toStringAsFixed(2)}%'),
            Text('Feedback Ratio: ${event.feedbackRatio.toStringAsFixed(2)}%'),
            const SizedBox(height: 24),

            const Text('User Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: event.feedback.isNotEmpty
                  ? ListView.builder(
                      itemCount: event.feedback.length,
                      itemBuilder: (context, index) {
                        final feedback = event.feedback[index];
                        final profileImage = feedback["userId"]["profileImage"];

                        return Card(
                          color: cardColor,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: profileImage.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(profileImage),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Color.fromARGB(255, 48, 86, 139),
                                    child: Text(
                                      feedback['userId']['fullName'][0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    feedback['userId']['fullName'],
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                for (var i = 0; i < feedback['rating']; i++)
                                  Icon(Icons.star, size: 16, color: iconColor),
                                for (var i = feedback['rating']; i < 5; i++)
                                  Icon(Icons.star_border, size: 16, color: iconColor),
                              ],
                            ),
                            subtitle: Text(feedback['comment'], style: TextStyle(color: textColor)),
                          ),
                        );
                      },
                    )
                  :  const Center(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 64, color: Color.fromARGB(255, 119, 119, 119),),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'No feedback received yet.',
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
                    )
            ),
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
    );
  }
}

double _roundNum(double value) {
  return double.parse(value.toStringAsFixed(2));
}
class PopularEventsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> popularEvents;

  const PopularEventsWidget({Key? key, required this.popularEvents}) : super(key: key);

  @override
  _PopularEventsWidgetState createState() => _PopularEventsWidgetState();
}

class _PopularEventsWidgetState extends State<PopularEventsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'My Top 5 Popular Events',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: widget.popularEvents.map((eventMap) {
              final event = Event.fromJson(eventMap);
              return EventCard(event: event);
            }).toList(),
          ),
        ),
      ],
    );
  }
}


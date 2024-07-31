
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import 'package:firstapp/widgets/event_card.dart';

import '../providers/events_providers.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with AutomaticKeepAliveClientMixin {



  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _fetchRSVPEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRSVPEvents();
    });
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _fetchRSVPEvents();
  //
  // }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _groupedEvents = {};
  bool _isLoading = true;

  Future<void> _fetchRSVPEvents() async {

    try {
      EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
      final List<Event> events = await eventP.eventsRsvp;
      // final parsedEvents = parseEvents(response);

      setState(() {
        _groupedEvents = _groupEventsByDate(events);
        _isLoading = false;
      });
      
    } catch (e) {
      // print('RSVP Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> parseEvents(List<dynamic> events) {
    return events.map((event) {
      return {

        'startTime': event['startTime']?.toString() ?? '',
        'endTime': event['endTime']?.toString() ?? '',
        'isPrivate': event['isPrivate'] ?? false,
        'name': event['title'],
        'date': event['startTime'].substring(0, 10),
        'time': event['startTime'].substring(11, 16),
        'location': event['location'],
        // 'attendees': event['attendees'].length.toString(),
        'maxAttendees': event['maxAttendees'] is int ? event['maxAttendees'] : 0,
        'url': 'https://picsum.photos/200', // TODO: This still needs to change to the actual url of the image. Currently nothing is being returned in the eventMedia field
        'description': event['description'],
        'id': event['id'],
        'hosts': (event.containsKey('Hosts') && (event['Hosts'] as List).isNotEmpty)
            ? List<Hosts>.from(event['Hosts'].map((host) => Hosts.fromJson(host)))
            : [],
        'attendees': (event.containsKey('attendees') &&
            (event['attendees'] as List).isNotEmpty)
            ? List<Attendee>.from(event['attendees'].map((attendee) => Attendee.fromJson(attendee)))
            : [],
        'metadata': event.containsKey('metadata') && event['metadata'] is Map<String, dynamic>
            ? Metadata.fromJson(event['metadata'])
            : Metadata(
          mentors: [],
          categories: [],
          sessions: [],
        ),

      };
    }).toList();
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupEventsByDate(List<Event> events) {
    Map<DateTime, List<Map<String, dynamic>>> groupedEvents = {};


    for (var event in events) {
      DateTime date = DateTime.parse(event.startTime); // Assuming startTime is a DateTime string
      DateTime eventDay = DateTime(date.year, date.month, date.day);

      if (groupedEvents[eventDay] == null) {
        groupedEvents[eventDay] = [];
      }

      groupedEvents[eventDay]!.add({
        'startTime': event.startTime.toString(),
        'endTime': event.endTime.toString(),
        'isPrivate': event.isPrivate ?? false,
        'name': event.nameOfEvent,
        'date': event.startTime.substring(0, 10),
        'time': event.startTime.substring(11, 16),
        'location': event.location,
        'maxAttendees': event.maxAttendees ?? 0,
        'url': 'https://picsum.photos/200', // Placeholder URL, update as needed
        'description': event.description ?? '',
        'id': event.id,
        'hosts': event.hosts != null ? List<Hosts>.from(event.hosts) : [],
        'attendees': event.attendees != null ? List<Attendee>.from(event.attendees) : [],
        'metadata': event.metadata.toJson(),
      });
    }

    return groupedEvents;
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _groupedEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  List<dynamic> _getEventsForMonth(DateTime month) {
    List<dynamic> events = [];
    _groupedEvents.forEach((date, eventList) {
      if (date.year == month.year && date.month == month.month) {
        events.addAll(eventList);
      }
    });
    return events;
  }

  String _formatMonth(DateTime date) {
    return DateFormat.yMMMM().format(date);
  }

  String _formatDate(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

  @override
  Widget build(BuildContext context) {




    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = isSameDay(_selectedDay, selectedDay) ? null : selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = null;
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade300,
                      ),
                      width: 16,
                      height: 16,
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 149, 137, 74),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedDay != null
                    ? "Events on ${_formatDate(_selectedDay!)}"
                    : "Your RSVP'd Events for ${_formatMonth(_focusedDay)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: _isLoading
              ? const Center(child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 149, 137, 74),
                  size: 50.0,
                ))
              : ListView.builder(
                  itemCount: _selectedDay != null
                      ? _getEventsForDay(_selectedDay!).length
                      : _getEventsForMonth(_focusedDay).length,
                  itemBuilder: (context, index) {
                    final events = _selectedDay != null
                        ? _getEventsForDay(_selectedDay!)
                        : _getEventsForMonth(_focusedDay);
                    final event = events[index];

                    return GestureDetector(
                      onTap: () {
                        Event eventObject = Event(
                          nameOfEvent: event['name'],
                          dateAndTime: '${event['date']} ${event['time']}',
                          location: event['location'],
                          description: event['description'],
                          imageUrls: [event['url']],
                          id: event['id'],
                          hosts: event['hosts'],
                          attendees:event['attendees'],
                          startTime: event['startTime'],
                          endTime: event['endTime'],
                          maxAttendees: event['maxAttendees'],
                          isPrivate: event['isPrivate'],
                          startDate: '',
                          metadata:event['metadata'],

                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedEventPage(event: eventObject),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(event['url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 16),
                                        const SizedBox(width: 4.0),
                                        Text(event['date']),
                                        const SizedBox(width: 16.0),
                                        const Icon(Icons.access_time, size: 16),
                                        const SizedBox(width: 4.0),
                                        Text(event['time']),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 4.0),
                                        Text(event['location']),
                                        const SizedBox(width: 16.0),
                                        const Icon(Icons.people, size: 16),
                                        const SizedBox(width: 4.0),
                                        Text(event['attendees'].length.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}



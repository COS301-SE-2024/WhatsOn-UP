import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, dynamic>> _events = [
    {
      'name': 'Event 1 Name',
      'date': '2024-05-14',
      'time': '00:00',
      'location': 'Location',
      'attendees': '12 052',
      'url': 'https://picsum.photos/200',
    },
    {
      'name': 'Event 2 Name',
      'date': '2024-05-25',
      'time': '00:00',
      'location': 'Location',
      'attendees': '1 234',
      'url': 'https://picsum.photos/200',
    },
    {
      'name': 'Event 3 Name',
      'date': '2024-06-01',
      'time': '00:00',
      'location': 'Location',
      'attendees': '4 129',
      'url': 'https://picsum.photos/200',
    },
    {
      'name': 'Event 4 Name',
      'date': '2024-06-10',
      'time': '00:00',
      'location': 'Location',
      'attendees': '31',
      'url': 'https://picsum.photos/200',
    },
    {
      'name': 'Event 5 Name',
      'date': '2024-06-22',
      'time': '00:00',
      'location': 'Location',
      'attendees': '383',
      'url': 'https://picsum.photos/200',
    },
  ];

  late Map<DateTime, List<Map<String, dynamic>>> _groupedEvents;

  @override
  void initState() {
    super.initState();
    _groupedEvents = _groupEventsByDate(_events);
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupEventsByDate(List<Map<String, dynamic>> events) {
    Map<DateTime, List<Map<String, dynamic>>> groupedEvents = {};
    for (var event in events) {
      DateTime date = DateTime.parse(event['date']);
      DateTime eventDay = DateTime(date.year, date.month, date.day);
      if (groupedEvents[eventDay] == null) groupedEvents[eventDay] = [];
      groupedEvents[eventDay]!.add(event);
    }
    return groupedEvents;
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _groupedEvents[day] ?? [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
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
                _selectedDay = selectedDay;
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
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            calendarStyle: const CalendarStyle(
              todayTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 0, 0),
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
                "Your RSVP'd Events for ${_formatMonth(_focusedDay)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForMonth(_focusedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForMonth(_focusedDay)[index];
                return Card(
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
                                  const Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 4.0),
                                  Text(event['location']),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 4.0),
                                  Text(event['time']),
                                  const SizedBox(width: 16.0),
                                  const Icon(Icons.people, size: 16),
                                  const SizedBox(width: 4.0),
                                  Text('${event['attendees']} Attendees'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

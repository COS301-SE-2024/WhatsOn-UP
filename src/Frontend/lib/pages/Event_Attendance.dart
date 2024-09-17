import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class EventAttendance extends StatefulWidget {
  Event event;
  EventAttendance({super.key, required this.event});

  @override
  State<EventAttendance> createState() => _EventAttendanceState();
}

class _EventAttendanceState extends State<EventAttendance> {
  late List<Attendee> filteredAttendees;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredAttendees = widget.event.attendees;
    searchController.addListener(filterAttendees);
  }

  void filterAttendees() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredAttendees = widget.event.attendees
          .where((attendee) => attendee.fullName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.nameOfEvent),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredAttendees.isEmpty
                ? const Center(
                    child: Text("No attendees found."),
                  )
                : ListView.builder(
                    itemCount: filteredAttendees.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              filteredAttendees[index]
                                          .profileImage
                                          .isNotEmpty
                                  ? NetworkImage(
                                      filteredAttendees[index].profileImage)
                                  : const AssetImage('assets/images/user.png'),
                          radius: 20,
                        ),
                        title: Center(
                          child: Text(filteredAttendees[index].fullName),
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

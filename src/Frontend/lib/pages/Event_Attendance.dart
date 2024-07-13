
import 'package:flutter/material.dart';

import '../widgets/event_card.dart';

class EventAttendance extends StatefulWidget {

  Event event;
   EventAttendance({super.key , required this.event});

  @override
  State<EventAttendance> createState() => _EventAttendanceState();
}

class _EventAttendanceState extends State<EventAttendance> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
        title: Text(widget.event.nameOfEvent),
    ),
    body: widget.event.attendees.length == 0
        ? Center(
      child: Text("You don't have any attendees"),
    )
   : ListView.builder(
      itemCount: widget.event.attendees.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.event.attendees[index].profileImage),
            radius: 20,
          ),
          title:Center(
            child: Text(widget.event.attendees[index].fullName),
        )
        );
      },
    ),
    );
  }
}

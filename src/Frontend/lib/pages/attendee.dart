import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_providers.dart';
import '../providers/user_provider.dart';
import '../widgets/event_card.dart';
import 'Event_Attendance.dart';


class Attendee extends StatefulWidget {
   Attendee({super.key});

  @override
  State<Attendee> createState() => _AttendeeState();
}

class _AttendeeState extends State<Attendee> {
  late Future<List<Event>> _eventsRsvp;

  @override
  void initState() {
    super.initState();
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    if(userP.role== 'ADMIN'){
      _eventsRsvp = eventP.eventsRsvp;
    }
    else{
      _eventsRsvp = eventP.eventsHome;
    }

  }



  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;

    return Scaffold(
        appBar: AppBar(
          title: Text('Attandees'),
        ),
        body: FutureBuilder<List<Event>>(
          future: _eventsRsvp,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred: ${snapshot.error}'),
              );
            } else {
              userProvider userP = Provider.of<userProvider>(context, listen: false);
              List<Event> events = snapshot.data!;
              events = events.where((event) => event.hosts.contains(userP.Fullname)).toList();
              return ListView.separated(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return   InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>EventAttendance(event: events[index]),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      color: Colors.grey[200],
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${events[index].nameOfEvent}'),

                          Row(
                            children:[
                              Icon(Icons.people, size: 16),
                              SizedBox(width: 4),
                              Text(events[index].attendees.length.toString())
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              );
            }
          },
        ));

  }
}

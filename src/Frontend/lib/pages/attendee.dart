import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_providers.dart';
import '../providers/user_provider.dart';
import '../widgets/event_card.dart';
import 'Event_Attendance.dart';


class Attendees extends StatefulWidget {
   const Attendees({super.key});

  @override
  State<Attendees> createState() => _AttendeesState();
}

class _AttendeesState extends State<Attendees> {
  late final _eventsRsvp;

  @override
  void initState() {
    super.initState();
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    if(userP.role== 'HOST'){
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
          title: const Text('Attendees'),
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
              var events = snapshot.data!;
              events = events.where((event) => event.hosts!.contains(userP.Fullname)).toList();
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(events[index].nameOfEvent),

                          Row(
                            children:[
                              const Icon(Icons.people, size: 16),
                              const SizedBox(width: 4),
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

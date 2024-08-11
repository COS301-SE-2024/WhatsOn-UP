import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firstapp/services/EventService.dart';
import '../screens/FilterScreen.dart';
import '../screens/SearchScreen.dart';
import 'event_card.dart';
import 'package:firstapp/main.dart';


class Pastevents extends StatefulWidget {
  final EventService eventService;

  Pastevents({Key? key, required this.eventService}) : super(key: key);

  @override
  _PasteventsState createState() => _PasteventsState();
}

class _PasteventsState extends State<Pastevents> {
  late Future<List<Event>> _pastEvents;

  @override
  void initState() {
    super.initState();
    final user = supabase.auth.currentUser;
    _pastEvents = widget.eventService.fetchPastEvents(user!.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Past Events'),
      ),
      body: Column(
        children: [
          SizedBox(width: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.search, color: textColour),
                        label: Text('Search', style: TextStyle(color: textColour)),
                      ),
                    ),
                  ),
                  SizedBox(width: 35.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.filter_list, color: textColour),
                        label: Text('Filter', style: TextStyle(color: textColour)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 35.0),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _pastEvents,
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitPianoWave(
                      color: Color.fromARGB(255, 149, 137, 74),
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading events'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No events available'));
                } else {
                  List<Event> events = snapshot.data!;
                  DateTime now = DateTime.now();

                  events = events.where((event) =>
                      DateTime.parse(event.endTime).isBefore(now)
                  ).toList();


                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                          event: events[index], showBookmarkButton: false,
                      );

                    },

                  );

                }

              },

            ),

          ),

        ],

      ),

    );

  }

}


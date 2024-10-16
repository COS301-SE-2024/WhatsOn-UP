import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/FilterScreen.dart';
import '../screens/SearchScreen.dart';
import 'event_card.dart';
// import 'package:firstapp/main.dart';


class Pastevents extends StatefulWidget {
  final EventService eventService;
  final SupabaseClient supabaseClient;

  Pastevents({Key? key, required this.eventService, required this.supabaseClient}) : super(key: key);

  @override
  _PasteventsState createState() => _PasteventsState();
}

class _PasteventsState extends State<Pastevents> {
  late Future<List<Event>> _pastEvents;
  late SupabaseClient supabaseClient;

  @override
  void initState() {
    super.initState();
    supabaseClient = widget.supabaseClient;
    final user = supabaseClient.auth.currentUser;
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    if (user != null) {
      _pastEvents = widget.eventService.fetchPastEvents(userP.JWT);
    } else {

      _pastEvents = Future.error('User is not authenticated');
    }

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Events'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const SizedBox(width: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // width: MediaQuery.of(context).size.width * 0.27,
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
                  const SizedBox(width: 35.0),
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
          const SizedBox(width: 35.0),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _pastEvents,
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitPianoWave(
                      color: Color.fromARGB(255, 149, 137, 74),
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading events'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 64, color: Color.fromARGB(255, 119, 119, 119),),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'No Events Available',
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
                } else {
                  List<Event> events = snapshot.data!;
                  DateTime now = DateTime.now();

                  events = events.where((event) =>
                      DateTime.parse(event.endTime).isBefore(now)
                  ).toList();


                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14.0),
                        child: EventCard(
                            event: events[index],
                            showBookmarkButton: false,
                            ),
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


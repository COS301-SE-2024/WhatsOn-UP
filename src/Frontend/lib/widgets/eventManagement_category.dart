import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../main.dart';
import '../providers/user_provider.dart';
import '../screens/FilterScreen.dart';
import '../screens/HostSearchScreenState.dart';

import 'event_card.dart';

class EventmanagementCategory extends StatefulWidget {
  final SupabaseClient supabaseClient;
  EventmanagementCategory({Key? key, required this.supabaseClient,}) : super(key: key);

  @override
  _EventmanagementCategoryState createState() =>
      _EventmanagementCategoryState();
}

class _EventmanagementCategoryState extends State<EventmanagementCategory> {
  late Future<List<Event>> _eventsHome;
  late SupabaseClient supabaseClient;

  @override
  void initState() {
    super.initState();
      supabaseClient = widget.supabaseClient;

    final user = supabaseClient.auth.currentUser;
    _loadEvents();
  }

  void _loadEvents() async {
    try {
      EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
      _eventsHome = eventP.eventsHome;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading events';
        _errorOccurred = true;
      });
    }
  }

  late String _errorMessage;
  late bool _errorOccurred = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;
    final user = supabaseClient.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Events'),
      ),
      body: _errorOccurred
          ? Center(child: Text(_errorMessage))
          : Column(
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                              builder: (context) => HostSearchScreen(hostId: user!.id),
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
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _eventsHome,
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
                  userProvider userP = Provider.of<userProvider>(context, listen: false);
                  List<Event> events = snapshot.data!;
                  if (userP.role != 'ADMIN') {
                    events = events.where((event) => event.hosts.contains(userP.Fullname)).toList();
                  }
                  if (events.isEmpty) {
                    return Center(child: Text('No upcoming or current events found.'));
                  }
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: EventCard(
                          event: events[index],
                          showBookmarkButton: false,
                          broadcast:'EDIT',
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
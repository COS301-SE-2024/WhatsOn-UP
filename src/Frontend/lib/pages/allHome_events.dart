
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


import '../providers/events_providers.dart';
import '../services/api.dart';
import '../widgets/event_card.dart';

class AllhomeEvents extends StatefulWidget {
  AllhomeEvents({Key? key}) : super(key: key);

  @override
  _AllhomeEventsState createState() => _AllhomeEventsState();
}

class _AllhomeEventsState extends State<AllhomeEvents> {
  late List<Event> events = [];
  late Api api;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    api = Api();
    try {

      EventProvider eventProvider = Provider.of<EventProvider>(context, listen: false);
      events =await eventProvider.eventsHome;
    } catch (error) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
      ),
      body: isLoading
          ? Center(
              child: SpinKitPianoWave(
                color: Color.fromARGB(255, 149, 137, 74),
                size: 50.0,
              ),
            )
          : hasError
              ? Center(
                  child: Text(
                    'Failed to load events. Please try again later.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 8.0,
                    ),
                      child: EventCard(event: events[index], showBookmarkButton: true,),
                    );
                  },
                ),
    );
  }
}


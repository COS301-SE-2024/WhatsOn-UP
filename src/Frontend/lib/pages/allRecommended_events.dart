import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import '../pages/detailed_event_page.dart';
import '../providers/events_providers.dart';
import '../services/api.dart';
import '../widgets/event_card.dart';

class AllrecommendedEvents extends StatefulWidget {
  AllrecommendedEvents({Key? key}) : super(key: key);

  @override
  _AllrecommendedEventsState createState() => _AllrecommendedEventsState();
}

class _AllrecommendedEventsState extends State<AllrecommendedEvents> {
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
      userProvider user = Provider.of<userProvider>(context, listen: false);
      EventProvider eventProvider = Provider.of<EventProvider>(context, listen: false);
      events =await eventProvider.recommendations ;
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
        title: const Text('Recommended Events'),
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

class EventCardH extends StatelessWidget {
  final Event event;

  const EventCardH({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColour = theme.colorScheme.surface;
    final textColour = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedEventPage(event: event,recommendations:'recommendations'),
          ),
        );
      },
      child: Card(
        color: cardColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 200,
          height: 265,
          decoration: BoxDecoration(
            color: cardColour,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 7.0),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: event.imageUrls != null && event.imageUrls!.isNotEmpty
                        ? Image.network(
                            event.imageUrls![0],
                            height: 120.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/user.png',
                            height: 120.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Text(
                  event.nameOfEvent ?? 'No Event Name',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: textColour,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: textColour,
                    ),
                    Expanded(
                      child: Text(
                        event.venue?.name ?? 'No Venue Name',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: textColour,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

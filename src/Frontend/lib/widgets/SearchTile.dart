import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchImageTile.dart';
import 'package:firstapp/services/EventService.dart';

class SearchTile extends StatelessWidget {
  final EventService eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        LikedCategory(eventService: eventService),
      ],
    );
  }
}

class LikedCategory extends StatefulWidget {
  final EventService eventService;

  LikedCategory({required this.eventService});

  @override
  _LikedCategoryState createState() => _LikedCategoryState();
}

class _LikedCategoryState extends State<LikedCategory> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final List<dynamic> fetchedEvents = await widget.eventService.searchEvents();
      setState(() {
        events = fetchedEvents;
      });

      // Print received event titles and media links
      events.forEach((event) {
        print('Event Title: ${event['name']}');
        print('Media Link: ${event['eventMedia'][0]}');
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: Column(
        children: [
          Center(
            child: Text(
              'Ideas for you',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: MediaQuery.of(context).size.height / 400,
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              final event = events[index];
              return SearchImageTile(
                title: event['name'], // Adjust as per your backend response structure
                imageUrl: event['eventMedia'][0], // Assuming first media link is displayed
              );
            },
          ),
        ],
      ),
    );
  }
}

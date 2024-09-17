import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/screens/SearchScreen.dart';


class FilteredResultScreen extends StatelessWidget {
  final List<Event> filteredEvents;

  const FilteredResultScreen({super.key, required this.filteredEvents});

  void _openSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  SearchScreen(showSearchHistoryOnStart: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Results'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => _openSearchScreen(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Text(
                      "Search for events",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
          filteredEvents.isEmpty
              ? const Center(child: Text('No events found'))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: filteredEvents[index], showBookmarkButton: false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
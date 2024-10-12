import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/screens/SearchScreen.dart';


class FilteredResultScreen extends StatelessWidget {
  final List<Event> filteredEvents;

  FilteredResultScreen({required this.filteredEvents});

  void _openSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(showSearchHistoryOnStart: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Results'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => _openSearchScreen(context),
              child: Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8.0),
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for events",
                      border: InputBorder.none,
                    ),
                  ),
                )],
                ),
              ),
            ),
          ),
          filteredEvents.isEmpty
              ? Center(child: Text('No events found'))
              : Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 8.0,
                    ),
                      child: EventCard(event: filteredEvents[index], showBookmarkButton: true,),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
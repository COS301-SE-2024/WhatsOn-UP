import 'package:flutter/material.dart';
import 'package:firstapp/widgets/CustomSearchBar.dart';
import 'package:firstapp/widgets/SearchTile.dart';
import 'package:firstapp/services/EventService.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final EventService _eventService = EventService();
  List<dynamic> _searchResults = [];

  void _searchEvents(String query) async {
    try {
      final results = await _eventService.searchEvents(title: query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle error, e.g., show an error message
      print('Error searching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
              padding: EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                color: Colors.grey, // Adjust color as needed
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for events",
                        border: InputBorder.none,
                      ),
                      onSubmitted: _searchEvents,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_searchResults[index]['title']),
                    subtitle: Text(_searchResults[index]['description']),
                    // Implement onTap to navigate or show details
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

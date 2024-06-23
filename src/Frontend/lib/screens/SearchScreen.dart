import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchTile.dart';
import 'package:firstapp/services/EventService.dart';

import '../widgets/FilteredEventsScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final EventService _eventService = EventService();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _showSearchTiles = true;

  void _searchEvents(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults.clear(); // Clear previous results
    });

    try {
      final results = await _eventService.searchEvents(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
        _showSearchTiles = false;
      });
    } catch (e) {
     //probably add an  alert
      print('Error searching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
/*  void _applyFilter(String filter) async {
    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      final results = await _eventService.filterEventsByKeyword(filter);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredEventsScreen(events: _searchResults),
        ),
      ).then((value) {
        // Clear search results when returning from FilteredEventsScreen
        setState(() {
          _searchResults.clear();
        });
      });
    } catch (e) {
      //probably add an  alert
      print('Error filtering events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }*/
  void _clearSearchResults() {
    setState(() {
      _searchResults.clear();
      _showSearchTiles = true; // Show search tiles again
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
        actions: [
          if (_searchResults.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _clearSearchResults,
            ),
        ],
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
                color: Colors.grey,
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
                      onTap: () {
                        setState(() {
                          _showSearchTiles = true; // Show search tiles on tap
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _showSearchTiles = true; // Show search tiles on change
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_showSearchTiles)
              SearchTile(
                onFilterSelected: _searchEvents,
              ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(
              child: Text('No events found'),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_searchResults[index]['title']),
                    subtitle: Text(_searchResults[index]['description']),
                    // TODO: Implement onTap to navigate to event details page
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
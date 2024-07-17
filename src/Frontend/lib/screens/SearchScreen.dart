import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchImageTile.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final EventService _eventService = EventService(Supabase.instance.client);
  List<Event> _searchResults = [];
  List<String> _categories = [];
  bool _isLoading = false;
  bool _showSearchTiles = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories(); 
  }

  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _eventService.fetchUniqueCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, e.g., show an error message
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchEvents(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults.clear(); // Clear previous results
      _showSearchTiles = false; // Hide search tiles when searching
    });

    try {
      final results = await _eventService.searchEvents(query) as List<Event>;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, e.g., show an error message
      print('Error searching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                          _showSearchTiles = true; //
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
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: _categories.map((category) {
                  return SearchImageTile(
                    title: category,
                    imageUrl: 'images/$category.jpg', // Example path to image in assets
                    onTap: (title) => _searchEvents(title),
                  );
                }).toList(),
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
                itemBuilder: (context, index) {
                  // Ensure index is within bounds
                  if (index >= _searchResults.length) {
                    return Container(); // or handle error gracefully
                  }
                  return EventCard(event: _searchResults[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/SearchImageTile.dart';
import 'package:firstapp/services/EventService.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firstapp/screens/FilterScreen.dart';

import '../providers/user_provider.dart';
import '../services/api.dart'; // Import the FilterScreen


class SearchScreen extends StatefulWidget {

  final bool showSearchHistoryOnStart;
  final String? initialQuery;

  SearchScreen({this.showSearchHistoryOnStart = false, this.initialQuery});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Api _api = Api();
  final EventService _eventService = EventService(Supabase.instance.client);
  final TextEditingController _searchController = TextEditingController();
  List<Event> _searchResults = [];
  List<Category> _categories = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showSearchTiles = true;
  bool _showSearchHistory = false;
  bool _hasSearched = false;
  Timer? _debounce;




  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _loadSearchHistory();
    
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchEvents(widget.initialQuery!);
    }

    if (widget.showSearchHistoryOnStart) {
      _showSearchHistory = true;
      _showSearchTiles = false;
    }
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
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchEvents(String query) async {
    print("Category being searched");
    print(query);
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _searchResults.clear();
      _showSearchTiles = false;
      _showSearchHistory = false;
      _hasSearched = true;
    });

    try {
      final results = await _eventService.searchEvents(query) as List<Event>;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      _saveSearchQuery(query);
    } catch (e) {
      print('Error searching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearchResults() {
    setState(() {
      _searchResults.clear();
      _showSearchTiles = true;
      _hasSearched = false;
    });
  }

  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  void _saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_searchHistory.contains(query)) {
        _searchHistory.remove(query);
      }
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 5) {
        _searchHistory.removeLast();
      }
      prefs.setStringList('searchHistory', _searchHistory);
    });
  }

  void _removeSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.remove(query);
      prefs.setStringList('searchHistory', _searchHistory);
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchEvents(query);
    });
  }


  Future<List<Event>> fetchEventsByCategory(String category) async {
    try {

      userProvider userP = Provider.of<userProvider>(context, listen: false);

      var response = await _api.getAllEvents(userP.JWT);

      if (response != null) {

        print(response);
        List<Event> events = response.map<Event>((event) => Event.fromJson(event as Map<String, dynamic>)).toList();
        print ("print events");
        print(events);
        return events.where((event) => event.metadata.categories == category).toList();

        } else {
        // Handle empty or null response
        return [];
      }
    } catch (e) {
      // Handle exceptions and return an empty list or rethrow
      print("Error fetching events: $e");
      return [];
    }
  }



  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _openFilterDialog() async {
    final result = await showDialog<List<Event>>(
      context: context,
      builder: (context) =>  FilterScreen( searchResults:_searchResults),
    );

    if (result != null) {
      setState(() {
        _searchResults = result;
        _hasSearched = true;
      });
    }
  }

  List<Category> _getRandomCategories(List<Category> categories) {
    categories.shuffle(Random());
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
        actions: [
            IconButton(
              icon : FaIcon(FontAwesomeIcons.searchPlus,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: _clearSearchResults,

            ),
        ],
      ),
      body: SingleChildScrollView(
        child:Padding(
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
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Icon(Icons.search), // Search icon color
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for events",
                        border: InputBorder.none,
                      ),
                      onSubmitted: _searchEvents,
                      onTap: () {
                        setState(() {
                          _showSearchHistory = true;
                          _showSearchTiles = false;
                        });
                      },
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    color: Colors.black,
                    onPressed: _openFilterDialog,
                  ),
                ],
              ),
            ),
            if (_showSearchHistory)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchHistory.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Search History'),
                        ..._searchHistory.map((history) {
                          return ListTile(
                            title: Text(history),
                            trailing: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _removeSearchQuery(history),
                            ),
                            onTap: () {
                              _searchEvents(history);
                            },
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            if (_showSearchTiles)
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children:_getRandomCategories(_categories).map((category) {
                  String categoryName = category.name;
                  return SearchImageTile(
                    title: categoryName,
                    imageUrl: 'assets/images/$categoryName.jpg',
                    onTap: (title) =>  Center(
                      child: Text('No events found'),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasSearched && _searchResults.isEmpty
                ? Center(child: Text('No events found'))
                : ListView.builder(
                shrinkWrap: true,
                physics:NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  if (index >= _searchResults.length) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 8.0,
                    ),
                      child: EventCard(event: _searchResults[index], showBookmarkButton: true,),
                  );
                },
              ),
    ],
            ),

        ),
      ),
    );
  }
}
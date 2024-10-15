import 'dart:math';

import 'package:firstapp/providers/events_providers.dart';
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

import '../pages/NoEventsFoundScreen.dart';
import '../providers/user_provider.dart';
import '../services/api.dart';

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
  List<Event> Teventhome = [];

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
      EventProvider eventProvider = Provider.of<EventProvider>(context, listen: false);
      final categories = await _eventService.fetchUniqueCategories();
      var eventhome = await eventProvider.eventsHome;
      setState(() {
        _categories = categories;
        _isLoading = false;
        Teventhome = eventhome;
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
  List<Event> searchEventsByCategory(String category, List<Event> allEvents) {

    return allEvents.where((event) =>  event.extractCategoryFromMetadata() == category).toList();
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

        List<Event> events = response
            .map<Event>(
                (event) => Event.fromJson(event as Map<String, dynamic>))
            .toList();


        return events
            .where((event) => event.extractCategoryFromMetadata() == category)
            .toList();
      } else {

        return [];
      }
    } catch (e) {

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
      builder: (context) => FilterScreen(searchResults: _searchResults),
    );

    if (result != null) {
      setState(() {
        _searchResults = result;
        _hasSearched = true;
      });
    }
  }
  bool hasEventsInCategory(String categoryName, List<Event> events) {
    return events.any((event) => event.extractCategoryFromMetadata() == categoryName);
  }
  List<Category> _getRandomCategories(List<Category> categories, List<Event> eventHOme)  {

    List<Category> categoriesWithEvents = [];
    List<Category> categoriesWithoutEvents = [];

    for (var category in categories) {
      if (hasEventsInCategory(category.name, eventHOme)) {
        categoriesWithEvents.add(category);
      } else {
        categoriesWithoutEvents.add(category);
      }
    }
    categoriesWithEvents.shuffle(Random());
    categoriesWithoutEvents.shuffle(Random());
    return categoriesWithEvents + categoriesWithoutEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
        actions: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Container(
              child: OutlinedButton.icon(
                onPressed: _clearSearchResults,
                icon: FaIcon(
                  FontAwesomeIcons.searchPlus,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text(
                  'By Category',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8.0),
                    Icon(Icons.search), // Search icon color
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for events",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
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
                  children: _getRandomCategories(_categories,Teventhome).map((category) {
                    String categoryName = category.name;

                    return SearchImageTile(
                      title: categoryName,
                      imageUrl: 'assets/images/$categoryName.jpg',
                      onTap: (title) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoEventsFoundScreen(categoryName: categoryName)),
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
                          physics: NeverScrollableScrollPhysics(),
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
                              child: EventCard(
                                event: _searchResults[index],
                                showBookmarkButton: true,
                              ),
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

import 'dart:async';
import 'dart:convert';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'FilterScreen.dart';
import 'package:firstapp/services/api.dart';  // Import the API file

class HostSearchScreen extends StatefulWidget {
  final String hostId;

  HostSearchScreen({required this.hostId});

  @override
  _HostSearchScreenState createState() => _HostSearchScreenState();
}

class _HostSearchScreenState extends State<HostSearchScreen> {
  final Api _api = Api();
  List<Event> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showSearchHistory = false;
  bool _hasSearched = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  void _searchEvents(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _searchResults.clear();
      _showSearchHistory = false;
      _hasSearched = true;
    });

    try {
      userProvider userP = Provider.of<userProvider>(context, listen: false);
      final results = await _api.getAllEvents(userP.JWT);
      final hostEvents = results.where((event) {
        if (event.hosts is List<Map<String, dynamic>>) {
          return (event.hosts as List<Map<String, dynamic>>)
              .any((host) => host['userId'] == widget.hostId);
        } else if (event.hosts is List<String>) {
          return (event.hosts as List<String>).contains(widget.hostId);
        }
        return false;
      }).toList();

      setState(() {
        _searchResults = hostEvents;
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _openFilterDialog() async {
    final result = await showDialog<List<Event>>(
      context: context,
      builder: (context) => FilterScreen(),
    );

    if (result != null) {
      setState(() {
        _searchResults = result;
        _hasSearched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Events'),
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
                color: Colors.grey[200], // Light grey for better visibility
              ),
              child: Row(
                children: [
                  Icon(Icons.search), // Search icon color
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
                          _showSearchHistory = true;
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
            SizedBox(height: 16.0),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasSearched && _searchResults.isEmpty
                ? Center(child: Text('No events found for this host.'))
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return EventCard(event: _searchResults[index],showBookmarkButton: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
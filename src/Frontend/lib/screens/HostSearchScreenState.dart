import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FilterScreen.dart';
import 'package:firstapp/services/api.dart';  // Import the API file

class HostSearchScreen extends StatefulWidget {
  final String hostId;

  const HostSearchScreen({super.key, required this.hostId});

  @override
  _HostSearchScreenState createState() => _HostSearchScreenState();
}

class _HostSearchScreenState extends State<HostSearchScreen> {
  final Api _api = Api(); // Use the Api class
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
      final results = await _api.getAllEvents(); // Fetch all events
      final hostEvents = results.where((event) {
        if (event.hosts is List<Map<String, dynamic>>) {
          return (event.hosts as List<Map<String, dynamic>>)
              .any((host) => host['userId'] == widget.hostId);
        } else {
          return (event.hosts).contains(widget.hostId);
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
      builder: (context) => const FilterScreen(),
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
        title: const Text('Host Events'),
        actions: [
          if (_searchResults.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
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
              margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              padding: const EdgeInsets.all(8.0),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                color: Colors.grey[200], // Light grey for better visibility
              ),
              child: Row(
                children: [
                  const Icon(Icons.search), // Search icon color
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
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
                    icon: const Icon(Icons.filter_list),
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
                        const Text('Search History'),
                        ..._searchHistory.map((history) {
                          return ListTile(
                            title: Text(history),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _removeSearchQuery(history),
                            ),
                            onTap: () {
                              _searchEvents(history);
                            },
                          );
                        }),
                      ],
                    ),
                ],
              ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasSearched && _searchResults.isEmpty
                ? const Center(child: Text('No events found for this host.'))
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
import 'dart:async';
import 'package:firstapp/services/EventService.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  late AnimationController _controller;
  late Animation<Offset> _animationOffset;
  List<dynamic> filteredEvents = [];
  String? selectedDate;
  int? selectedMaxAttendees;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationOffset = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Add debug print to check initial state
    print('Initial state - Date: $selectedDate, MaxAttendees: $selectedMaxAttendees, Type: $selectedType');
  }

  void _filterEvents() async {
    print('Filtering events with - Date: $selectedDate, MaxAttendees: $selectedMaxAttendees, Type: $selectedType');
    try {
      final results = await _eventService.filterEvents(
        date: selectedDate ?? '',
        maxAttendees: selectedMaxAttendees ?? 0,
        type: selectedType ?? '', // Ensure type is a string
      );
      setState(() {
        filteredEvents = results;
      });

      // Debug print to check filtered results
      print('Filtered events: $filteredEvents');
    } catch (e) {
      // Handle error
      print('Error filtering events: $e');
    }
  }

  void _onFilterSelected(String filter, String value) {
    setState(() {
      if (filter == 'date') {
        selectedDate = value;
      } else if (filter == 'maxAttendees') {
        selectedMaxAttendees = int.parse(value);
      } else if (filter == 'type') {
        selectedType = value;
      }
    });

    // Debug print to check selected filters
    print('Selected filters - Date: $selectedDate, MaxAttendees: $selectedMaxAttendees, Type: $selectedType');

    _filterEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                selectedDate = null;
                selectedMaxAttendees = null;
                selectedType = null;
                filteredEvents.clear();
              });

              // Debug print to check state after clearing filters
              print('Filters cleared');
            },
          ),
        ],
      ),
      body: SlideTransition(
        position: _animationOffset,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFilterOption(
                title: 'Date',
                options: ['Last Week', 'Today', 'Next Week'],
                onSelected: (value) => _onFilterSelected('date', value),
                selectedOption: selectedDate,
              ),
              _buildFilterOption(
                title: 'Maximum Attendees',
                options: ['0-50', '50-100', '100-200', '200-300', '300-400', '400-500'],
                onSelected: (value) => _onFilterSelected('maxAttendees', value),
                selectedOption: selectedMaxAttendees?.toString(),
              ),
              _buildFilterOption(
                title: 'Type of Event',
                options: ['Private', 'Public'],
                onSelected: (value) => _onFilterSelected('type', value),
                selectedOption: selectedType,
              ),
              SizedBox(height: 20),
              Expanded(
                child: filteredEvents.isEmpty
                    ? Center(child: Text('No events found'))
                    : ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return ListTile(
                      title: Text(event['title']),
                      subtitle: Text(event['description']),
                    );
                  },
                ),
              ),
              // Temporary UI element to check if the screen is rendering
              Text('Debug: FilterScreen loaded successfully'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required String title,
    required List<String> options,
    required Function(String) onSelected,
    String? selectedOption,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) => onSelected(option),
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

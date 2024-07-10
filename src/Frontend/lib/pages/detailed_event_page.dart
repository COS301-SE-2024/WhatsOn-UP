import 'dart:async';

import 'package:firstapp/pages/edit_Event.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/services/api.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/user_provider.dart';

class DetailedEventPage extends StatefulWidget {
  final Event event;

  const DetailedEventPage({super.key, required this.event});

  @override
  _DetailedEventPageState createState() => _DetailedEventPageState();
}

class _DetailedEventPageState extends State<DetailedEventPage> {
  int _currentImageIndex = 0;
  final user = supabase.auth.currentUser;
  late Event _thisCurrentEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchEvent();

  }
  Future<void> _fetchEvent() async {
    try {
      EventProvider eventProvider = Provider.of<EventProvider>(context,listen: false);
      Event? event = await eventProvider.getEventById(widget.event.id );
      if (event != null) {
        setState(() {
          _thisCurrentEvent = event;
        });

      } else {
        print('Event with ID ${widget.event.id} not found.');
      }
    } catch (e) {
      print('Error fetching event: $e');
    }
  }









  Future<void> _addToCalendar() async {
    try {
      var result = await Api().rsvpEvent(widget.event.id,user!.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully RSVP\'d to event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to RSVP: ${e.toString()}')),
      );
    }
  }

  void _viewLocationOnMap() {
    // Logic for viewing location on map
  }

  void _reportEvent() {
    // Logic for reporting event
  }

  Future<void> _editEvent() async {
    EventProvider eventProvider = Provider.of<EventProvider>(context,listen: false);
    if (widget.event.id != null && widget.event.id is String) {
      print('Navigating to EditEvent with eventId: ${widget.event.id}');
      final resultEdit= await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditEvent(eventId: widget.event.id)),
      );
      if (resultEdit == true) {
        await eventProvider.refreshEvents();
      }
    } else {
      print('Event ID is null or not a String');
    }
  }

  void _DeleteEvent() {

  }

  @override
  Widget build(BuildContext context) {

    userProvider userP = Provider.of<userProvider>(context, listen: false);




    final theme = Theme.of(context);
    final dotColour = theme.brightness == Brightness.dark ? const Color.fromARGB(255, 116, 116, 116) : Colors.grey;
    final activeDotColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(_thisCurrentEvent.nameOfEvent),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: widget.event.imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row( // Dots indicator for carousel
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.event.imageUrls.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? activeDotColour
                        : dotColour
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _thisCurrentEvent.nameOfEvent,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.event.dateAndTime,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8.0),
                      Text(
                        // widget.event.location,
                        _thisCurrentEvent.location,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _thisCurrentEvent.description,
                    //   _thisCurrentEvent.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: _addToCalendar,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Add to my Calendar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _viewLocationOnMap,
                    icon: const Icon(Icons.map),
                    label: const Text('Remove Event from my Calendar'),

                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _viewLocationOnMap,
                    icon: const Icon(Icons.map),
                    label: const Text('View Location on a Map'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _reportEvent,
                    icon: const Icon(Icons.report),
                    label: const Text('Report Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  if (_thisCurrentEvent != null &&
                      (_thisCurrentEvent!.hosts != null &&
                          _thisCurrentEvent!.hosts.isNotEmpty &&
                          _thisCurrentEvent!.hosts[0] == userP.Fullname || userP.role=='ADMIN')) ...[
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _editEvent,
                      label: const Text('Edit Event'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _DeleteEvent,
                      label: const Text('Remove Event'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],

                ],
              ),
            ),
          ],
        ),
      ),
    );



  }

}

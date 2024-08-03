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
    EventProvider eventProvider = Provider.of<EventProvider>(context,listen: false);
    try {
      var result = await Api().rsvpEvent(widget.event.id,user!.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully RSVP\'d to event!')),
      );
      await eventProvider.refreshRSVPEvents(user!.id);
      await eventProvider.refreshEvents();
      print('amount of attendees after event added to the calendar ${_thisCurrentEvent.attendees.length}');
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to RSVP: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeFromCalendar() async {
    EventProvider eventProvider = Provider.of<EventProvider>(context,listen: false);
    print('Removing RSVP for event: ${widget.event.id}');
    try {
       await Api().DeletersvpEvent(widget.event.id,user!.id).then((response){

       });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully removed RSVP !')),
      );
       await eventProvider.refreshRSVPEvents(user!.id);
       await eventProvider.refreshEvents();

       Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove RSVP: ${e.toString()}')),
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
        await eventProvider.refreshRSVPEvents(user!.id);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      print('Event ID is null or not a String');
    }
  }
  Future<void> _DeleteEvent() async {
    EventProvider eventProvider = Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      Api api = Api();
      api.DeleteEvent(_thisCurrentEvent.id, userP.userId).then((response) async {
        if(response['status'] == 'success'){
          print('Event deleted successfully. Response: $response');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event deleted successfully')),
          );
          await eventProvider.refreshEvents();
          Navigator.of(context).pushReplacementNamed('/home');
        }
        else{
          print('Failed to delete event. Response: $response');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete event')),
          );
        }
      });


    }
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
            const SizedBox(height: 16.0),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start: ${_thisCurrentEvent.startTime}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'End: ${_thisCurrentEvent.endTime}',
                            style: const TextStyle(fontSize: 16.0),
                          ),

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(width: 8.0),
                      Text(
                        'Attendees: ${_thisCurrentEvent.attendees.length}/${_thisCurrentEvent.maxAttendees}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),


                  const SizedBox(height:8.0 ),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8.0),
                      Text(
                        // widget.event.location,
                        _thisCurrentEvent.venue!.name,
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
                  if (!_thisCurrentEvent.attendees.any((attendee) => attendee.userId == userP.userId)) ...[
                    if (userP.role != "GUEST")
                    if (_thisCurrentEvent.maxAttendees >_thisCurrentEvent.attendees.length )
                      ElevatedButton.icon(
                        onPressed: _addToCalendar,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Add to my Calendar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    if (_thisCurrentEvent.maxAttendees <= _thisCurrentEvent.attendees.length + 1)
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Max Participants reached'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                  ],

                  const SizedBox(height: 8.0),
                  if (_thisCurrentEvent.attendees.any((attendee) => attendee.userId == userP.userId)) ...[
                    ElevatedButton.icon(
                      onPressed: _removeFromCalendar,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Remove from my Calendar'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
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
                  if (userP.role != "GUEST")
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
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Event'),
                      style: ElevatedButton.styleFrom(
                        // foregroundColor: Colors.black,
                        // backgroundColor: Colors.white,
                        // side: const BorderSide(color: Colors.black),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _DeleteEvent,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove Event'),
                      style: ElevatedButton.styleFrom(
                        // foregroundColor: Colors.black,
                        // backgroundColor: Colors.white,
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

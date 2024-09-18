import 'dart:async';
import 'package:firstapp/pages/edit_Event.dart';
import 'package:firstapp/pages/explore_page.dart';
import 'package:firstapp/pages/rate_event.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:firstapp/services/api.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../main.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DetailedEventPage extends StatefulWidget {
  final Event event;
String recommendations;

   DetailedEventPage({super.key, required this.event,  this.recommendations=''});

  @override
  _DetailedEventPageState createState() => _DetailedEventPageState();
}

class _DetailedEventPageState extends State<DetailedEventPage> {
  int _currentImageIndex = 0;
  final user = supabase.auth.currentUser;
  late Event _thisCurrentEvent;
  bool _isLoading = false;
  List<Widget> _mediaWidgets = [];

  @override
  void initState() {
    super.initState();
    _initializeMediaWidgets();
  }

  void _initializeMediaWidgets() {
    _mediaWidgets = widget.event.imageUrls?.map((url) {
      if (_isVideoUrl(url)) {
        return _buildVideoPlayer(url);
      } else {
        return _buildImageWidget(url);
      }
    }).toList() ?? [];
  }

  bool _isVideoUrl(String url) {
    return url.toLowerCase().endsWith('.mp4') || url.toLowerCase().endsWith('.mov');
  }

  Widget _buildImageWidget(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildVideoPlayer(String url) {
    VideoPlayerController videoPlayerController = VideoPlayerController.network(url);
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    return Chewie(
      controller: chewieController,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchEvent();
  }

  Future<void> _fetchEvent() async {
    try {
      Event? event;
      EventProvider eventProvider =
          Provider.of<EventProvider>(context, listen: false);
      if(widget.recommendations=='recommendations'){
        _thisCurrentEvent = widget.event;
        event =await eventProvider.getEventByIdR(widget.event.id);
      }else{
        _thisCurrentEvent = widget.event;
         event = await eventProvider.getEventById(widget.event.id);
      }

      if (event != null) {
        setState(() {
          _thisCurrentEvent = event!;
        });
      } else {
        print('Event with ID ${widget.event.id} not found.');
      }
    } catch (e) {
      print('Error fetching event: $e');
    }
  }

  Future<void> _addToCalendar() async {
    EventProvider eventProvider =
        Provider.of<EventProvider>(context, listen: false);

    userProvider userP =
        Provider.of<userProvider>(context,listen: false);

    try {
      setState(() {
        _isLoading = true;
      });

      var result = await Api().rsvpEvent(widget.event.id, userP.JWT);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully RSVP\'d to event!')),
      );
      await eventProvider.refreshRSVPEvents(user!.id, userP.JWT);
      await eventProvider.refreshEvents();
      print(
          'amount of attendees after event added to the calendar ${_thisCurrentEvent.attendees.length}');
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to RSVP: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromCalendar() async {
    EventProvider eventProvider =
        Provider.of<EventProvider>(context, listen: false);

    userProvider userP =
        Provider.of<userProvider>(context,listen: false);

    print('Removing RSVP for event: ${widget.event.id}');
    try {
      setState(() {
        _isLoading = true;
      });

      await Api()
          .DeletersvpEvent(widget.event.id, user!.id)
          .then((response) {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully removed your RSVP from the event!')),
      );
      await eventProvider.refreshRSVPEvents(user!.id, userP.JWT);
      await eventProvider.refreshEvents();

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove RSVP: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewLocationOnMap() {
    Venue? venue = _thisCurrentEvent.venue;
    String? buildingName = (venue != null && venue.building != null) ? venue.building!.name : null;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavigationPage(
        initSearchQuery: buildingName
      )),
    );
  }

  void _reportEvent() {
    // Logic for reporting event
  }

  Future<void> _editEvent() async {
    EventProvider eventProvider =
        Provider.of<EventProvider>(context, listen: false);

    userProvider userP =
        Provider.of<userProvider>(context,listen: false);
        
    if (widget.event.id != null && widget.event.id is String) {
      print('Navigating to EditEvent with eventId: ${widget.event.id}');
      final resultEdit = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditEvent(eventId: widget.event.id)),
      );
      if (resultEdit == true) {
        await eventProvider.refreshEvents();
        await eventProvider.refreshRSVPEvents(user!.id, userP.JWT);
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      print('Event ID is null or not a String');
    }
  }

  Future<void> _DeleteEvent() async {
    EventProvider eventProvider =
        Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      Api api = Api();
      api.DeleteEvent(_thisCurrentEvent.id, userP.userId)
          .then((response) async {
        if (response['status'] == 'success') {
          print('Event deleted successfully. Response: $response');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event deleted successfully')),
          );
          await eventProvider.refreshEvents();
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
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
    final dotColour = theme.brightness == Brightness.dark
        ? const Color.fromARGB(255, 116, 116, 116)
        : Colors.grey;
    final activeDotColour =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

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
              items: _mediaWidgets,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _mediaWidgets.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index ? Colors.black : Colors.grey,
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
                            'Start: ${DateFormat.yMMMMd().add_jm().format(DateTime.parse(_thisCurrentEvent.startTime))}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'End: ${DateFormat.yMMMMd().add_jm().format(DateTime.parse(_thisCurrentEvent.endTime))}',
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
                  const SizedBox(height: 8.0),
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
                  if (!_thisCurrentEvent.attendees
                      .any((attendee) => attendee.userId == userP.userId)) ...[
                    if (userP.role != "GUEST")
                      if (_thisCurrentEvent.maxAttendees >
                          _thisCurrentEvent.attendees.length)
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _addToCalendar(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 8),
                                    Text('Add to my Calendar'),
                                  ],
                                ),
                        ),
                    if (_thisCurrentEvent.maxAttendees <=
                        _thisCurrentEvent.attendees.length + 1)
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Max Participants reached'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                  ],
                  if (_thisCurrentEvent.attendees
                      .any((attendee) => attendee.userId == userP.userId)) ...[
                    ElevatedButton(
                          onPressed: _isLoading ? null : () => _removeFromCalendar(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 8),
                                    Text('Remove from my Calendar'),
                                  ],
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
                              _thisCurrentEvent!.hosts[0] == userP.Fullname ||
                          userP.role == 'ADMIN')) ...[
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _editEvent,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Event'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton.icon(
                      onPressed: _DeleteEvent,
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove Event'),
                      style: ElevatedButton.styleFrom(
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

  @override
  void dispose() {
    for (var widget in _mediaWidgets) {
      if (widget is Chewie) {
        widget.controller.dispose();
      }
    }
    super.dispose();
  }
}

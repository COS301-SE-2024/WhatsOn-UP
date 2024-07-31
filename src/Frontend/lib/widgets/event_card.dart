import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import 'package:provider/provider.dart';

class Attendee {
  final String userId;
  final String fullName;
  final String profileImage;
  final Map<String, dynamic> role;

  Attendee({
    required this.userId,
    required this.fullName,
    required this.profileImage,
    required this.role,
  });
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'profileImage': profileImage,
      'role': role,
    };
  }
  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      userId: json['userId'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      role: json['role'],
    );
  }
  @override
  String toString() {
    return 'Attendee(id: $userId, name: $fullName, role: $role)';  // Include all properties
  }
}
class Hosts {
  final String userId;
  final String fullName;
  final String profileImage;
  final Map<String, dynamic> role;

  Hosts({
    required this.userId,
    required this.fullName,
    required this.profileImage,
    required this.role,
  });
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'profileImage': profileImage,
      'role': role,
    };
  }
  factory  Hosts.fromJson(Map<String, dynamic> json) {
    return  Hosts(
      userId: json['userId'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      role: json['role'],
    );
  }
  @override
  String toString() {
    return 'Hosts(id: $userId, name: $fullName, role: $role)';  // Include all properties
  }
}

class Metadata {
  final List<String> mentors;
  final List<String> categories;
  final List<String> sessions;

  Metadata({
    required this.mentors,
    required this.categories,
    required this.sessions,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      mentors: json['mentors'] != null ? List<String>.from(json['mentors']) : [],
      categories: json['categories'] != null ? List<String>.from(json['categories']) : [],
      sessions: json['sessions'] != null ? List<String>.from(json['sessions']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentors': mentors,
      'categories': categories,
      'sessions': sessions,
    };
  }
}

class Event {
  late  String nameOfEvent;
  late final String dateAndTime;
  late  String location;
  List<String> imageUrls;
  String description;
  final String id;
  List<Hosts> hosts;
  late final String startTime;
  late final String endTime;
  late int maxAttendees;
  late final bool isPrivate;
  final List<Attendee> attendees;
  final Metadata metadata;
  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    required this.location,
    required this.imageUrls,
    required this.description,
    required this.id,
    required this.hosts,
   required this.startTime,
    required this.endTime,
    required this.maxAttendees,
    required this.isPrivate,
    required this.attendees,
    required startDate,
    required this.metadata,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      nameOfEvent: json['title']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      maxAttendees: json['maxAttendees'] is int ? json['maxAttendees'] : 0,
      location: json['location']?.toString() ?? '',
      isPrivate: json['isPrivate'] ?? false,
      imageUrls: (json.containsKey('eventMedia') && (json['eventMedia'] as List).isNotEmpty)
          ? List<String>.from(json['eventMedia'].map((media) => media?.toString() ?? ''))
          : ['https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'],
      description: json['description']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      hosts: (json.containsKey('Hosts') && (json['Hosts'] as List).isNotEmpty)
          ? List<Hosts>.from(json['Hosts'].map((host) => Hosts.fromJson(host)))
          : [],
      attendees: (json.containsKey('attendees') && (json['attendees'] as List).isNotEmpty)
          ? List<Attendee>.from(json['attendees'].map((attendee) => Attendee.fromJson(attendee)))
          : [],
      dateAndTime: json['startTime'],
      startDate: null,
      metadata: json.containsKey('metadata') && json['metadata'] is Map<String, dynamic>
          ? Metadata.fromJson(json['metadata'])
          : Metadata(
        mentors: [],
        categories: [],
        sessions: [],
      ),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': nameOfEvent,
      'startTime': startTime,
      'endTime': endTime,
      'maxAttendees': maxAttendees,
      'location': location,
      'isPrivate': isPrivate,
      'eventMedia': imageUrls,
      'description': description,
      'hosts': hosts.map((host) => {'fullName': host}).toList(),
      'attendees': attendees.map((attendee) => attendee.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }
}



class EventCard extends StatefulWidget {
  final Event event;
  final bool showBookmarkButton;

  const EventCard({super.key, required this.event, this.showBookmarkButton = true});



  @override
  _EventCardState createState() => _EventCardState();


}

class _EventCardState extends State<EventCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {

    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    final theme = Theme.of(context);
    final cardColour = theme.colorScheme.surface;
    final textColour = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedEventPage(event: widget.event),
          ),
        );
      },
      child: Card(
        color: cardColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 200,
          height: 265,
          decoration: BoxDecoration(
            color: cardColour,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 7.0),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: widget.event.imageUrls.isNotEmpty
                        ? Image.network(
                      widget.event.imageUrls[0],
                      height: 120.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/user.png',
                      height: 120.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  widget.event.nameOfEvent,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: textColour,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: textColour,
                    ),
                    Expanded(
                      child: Text(
                        widget.event.location,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: textColour,
                        ),
                      ),
                    ),
                    if (widget.showBookmarkButton)
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 20.0,
                          color: isBookmarked ? Colors.black : textColour,
                        ),
                        onPressed: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                            if (isBookmarked == true) {
                              eventP.addEventSaved(widget.event);
                              //api to add this event
                            } else {
                              eventP.removeEventSaved(widget.event);

                            }
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

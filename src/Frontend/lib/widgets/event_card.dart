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

//HERE
class Campus {
  final String campusId;
  final String name;
  final String location;
  final bool parking;

  Campus({
    required this.campusId,
    required this.name,
    required this.location,
    required this.parking,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      campusId: json['campus_id'],
      name: json['name'],
      location: json['location'],
      parking: json['parking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campus_id': campusId,
      'name': name,
      'location': location,
      'parking': parking,
    };
  }
}

class Building {
  final String buildingId;
  final String name;
  final String accessType;
  final String location;
  final Campus? campus;

  Building({
    required this.buildingId,
    required this.name,
    required this.accessType,
    required this.location,
    this.campus,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      buildingId: json['building_id'],
      name: json['name'],
      accessType: json['accessType'],
      location: json['location'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building_id': buildingId,
      'name': name,
      'accessType': accessType,
      'location': location,
      'campus': campus?.toJson(),
    };
  }
}

class Venue {
  final String venueId;
  final Building? building;
  final String name;
  final String? boards;
  final bool ac;
  final bool wifi;
  final int dataProject;
  final bool docCam;
  final bool mic;
  final bool windows;
  final int capacity;
  final bool available;

  Venue({
    required this.venueId,
    this.building,
    required this.name,
    this.boards,
    required this.ac,
    required this.wifi,
    required this.dataProject,
    required this.docCam,
    required this.mic,
    required this.windows,
    required this.capacity,
    required this.available,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueId: json['venue_id'],
      building: json['building'] != null ? Building.fromJson(json['building']) : null,
      name: json['name'],
      boards: json['boards'],
      ac: json['ac'],
      wifi: json['wifi'],
      dataProject: json['dataProject'],
      docCam: json['docCam'],
      mic: json['mic'],
      windows: json['windows'],
      capacity: json['capacity'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'venue_id': venueId,
      'building': building?.toJson(),
      'name': name,
      'boards': boards,
      'ac': ac,
      'wifi': wifi,
      'dataProject': dataProject,
      'docCam': docCam,
      'mic': mic,
      'windows': windows,
      'capacity': capacity,
      'available': available,
    };
  }
}



class Event {
  late  String nameOfEvent;
  late final String dateAndTime;
  final Venue? venue;
  List<String> imageUrls;
  String description;
  final String id;
  List<String> hosts;
  late final String startTime;
  late final String endTime;
  late int maxAttendees;
  late final bool isPrivate;
  final List<Attendee> attendees;
  final Metadata metadata;
  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    this.venue,
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
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      isPrivate: json['isPrivate'] ?? false,
      imageUrls: (json.containsKey('eventMedia') && (json['eventMedia'] as List).isNotEmpty)
          ? List<String>.from(json['eventMedia'].map((media) => media?.toString() ?? ''))
          : ['https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'],
      description: json['description']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      hosts: (json.containsKey('hosts') && (json['hosts'] as List).isNotEmpty)
          ? List<String>.from(json['hosts'].map((host) => host['fullName']?.toString() ?? ''))
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
      'location': venue?.toJson(),
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

  EventCard({Key? key, required this.event, this.showBookmarkButton = true})
      : super(key: key);



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
                        widget.event.venue?.name ?? 'No Venue',
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

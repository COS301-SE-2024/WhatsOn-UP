import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import 'package:provider/provider.dart';
import '../pages/BroadcastEvent.dart';
import '../pages/Event_Attendance.dart';
import '../providers/user_provider.dart';
import '../services/api.dart';


class Category {
  final String id;
  final String name;
  bool isSelected;
  String rating;
  String faculty;
  Category({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.rating='0',
    this.faculty = '',
  });

  factory Category.fromJson(String json) {
    final parts = json.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid category format');
    }
    return Category(
      id: parts[0],
      name: parts[1],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating': rating,
    'faculty': faculty,
  };
  @override
  String toString() {
    return 'Category(id: $id, name: $name, isSelected: $isSelected, rating: $rating, faculty: $faculty)';
  }
}






class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Attendee {
  final String userId;
  final String fullName;
  final String profileImage;
  final Role role;

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
      userId: json['userId'] ?? '',
      fullName: json['fullName']?.toString() ?? 'Unknown',
      profileImage: json['profileImage'] ?? '',
      role: Role.fromJson(json['role']),
    );
  }
  @override
  String toString() {
    return 'Attendee(id: $userId, name: $fullName, role: $role, profileImage: $profileImage)';
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
      mentors:
          json['mentors'] != null ? List<String>.from(json['mentors']) : [],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      sessions:
          json['sessions'] != null ? List<String>.from(json['sessions']) : [],
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
      campusId: json['campusId'],
      name: json['name'],
      location: json['location'],
      parking: json['parking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campusId': campusId,
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
    /* print("Printing Building From Json...");
    print(json['buildingId']);
    print(json['name']);
    print(json['accessType']);
    print(json['location']);
    print(json['campus'] );

    */
    Building building;
    building = Building(
      buildingId: json['buildingId'],
      name: json['name'],
      accessType: json['accessType'],
      location: json['location'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
    );
    return building;
  }

  Map<String, dynamic> toJson() {
    return {
      'buildingId': buildingId,
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
  late String name;
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
    // print("Printing Venue fromJson...");

    Venue venue = Venue(
      venueId: json['venueId'],
      building:
          json['building'] != null ? Building.fromJson(json['building']) : null,
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
    return venue;
  }

  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
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
class Host {

  final String userId;

  final String eventId;

  Host({

    required this.userId,

    required this.eventId,

  });





  factory Host.fromJson(Map<String, dynamic> json) {

    return Host(

      userId: json['user_id'],

      eventId: json['event_id'],



    );

  }





  Map<String, dynamic> toJson() {

    return {

      'user_id': userId,

      'event_id': eventId,

    };

  }

}


class Event {
  late String nameOfEvent;
  // late final String dateAndTime;
  late final Venue? venue;
  List<String>? imageUrls;
  String description;
  final String id;
  List<String> hosts;
  late final String startTime;
  late final String endTime;
  late int maxAttendees;
  late final bool isPrivate;
  final List<Attendee> attendees;
  final Metadata metadata;
  final List<Attendee>? invitees;
  Event({
    required this.nameOfEvent,
    this.venue,
    this.imageUrls,
    required this.description,
    required this.id,
    required this.hosts,
    required this.startTime,
    required this.endTime,
    required this.maxAttendees,
    required this.isPrivate,
    required this.attendees,
    required this.metadata,
    this.invitees,
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    var eventVat;
    eventVat = Event(
      nameOfEvent: json['title']?.toString() ?? '',
      startTime: json['startDateTime']?.toString() ?? '',
      endTime: json['endDateTime']?.toString() ?? '',
      maxAttendees: json['maxAttendees'] is int ? json['maxAttendees'] : 0,
      venue: json['location'] != null ? Venue.fromJson(json['location']) : null,
      isPrivate: json['isPrivate'] ?? false,
      imageUrls: (json.containsKey('eventMedia') &&
              (json['eventMedia'] as List).isNotEmpty)
          ? List<String>.from(
              json['eventMedia'].map((media) => media?.toString() ?? ''))
          : [
              'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'
            ],
      description: json['description']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      hosts: (json.containsKey('hosts') && (json['hosts'] as List).isNotEmpty)
          ? List<String>.from(
              json['hosts'].map((host) => host['fullName']?.toString() ?? ''))
          : [],
      attendees: (json.containsKey('attendees') &&
              (json['attendees'] as List).isNotEmpty)
          ? List<Attendee>.from(
              json['attendees'].map((attendee) => Attendee.fromJson(attendee)))
          : [],
      metadata: json.containsKey('metadata') &&
              json['metadata'] is Map<String, dynamic>
          ? Metadata.fromJson(json['metadata'])
          : Metadata(
              mentors: [],
              categories: [],
              sessions: [],
            ),
      invitees:
          json.containsKey('invitees') && (json['invitees'] as List).isNotEmpty
              ? List<Attendee>.from(
                  json['invitees'].map((invitee) => Attendee.fromJson(invitee)))
              : [],
    );
    return eventVat;
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
      'invitees': invitees?.map((invitee) => invitee.toJson()).toList(),
    };
  }
}

class EventCard extends StatefulWidget {
  final Event event;
  bool showBookmarkButton;
  String broadcast;

  EventCard({Key? key, required this.event, required this.showBookmarkButton ,this.broadcast=''})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

String getValidImageUrl(List<String>? imageUrls) {
  const List<String> validExtensions = ['jpeg', 'jpg', 'png'];
  const String defaultUrl = 'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'; // only videos in the array

  if (imageUrls == null || imageUrls.isEmpty) {
    return defaultUrl;
  }

  for (String url in imageUrls) {
    final extension = url.split('.').last.toLowerCase();
    if (validExtensions.contains(extension)) {
      return url;
    }
  }
  return defaultUrl;
}

class _EventCardState extends State<EventCard> {
  bool isBookmarked = false;
  bool isbroadcast=false;
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userRole = userP.role;
    widget.showBookmarkButton = widget.showBookmarkButton && userRole != "GUEST";

    widget.showBookmarkButton=widget.broadcast=="EDIT"
    ?false
    :true;

   isbroadcast=widget.broadcast=="EDIT"
       ?true
       :false;
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
                    child: Image.network(
                      getValidImageUrl(widget.event.imageUrls),
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

                            } else {
                              eventP.removeEventSaved(widget.event);
                            }
                          });
                        },
                      ),

                  ],
                ),
                const SizedBox(height: 10.0),
                if(isbroadcast)
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextButton(
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventAttendance(event:widget.event ),
                              ),
                            );

                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people, size: 16),
                              SizedBox(width: 8),
                              Text('Attendees: ${widget.event.attendees.length}'),
                            ],
                          ),
                        ),


                      ),
                    const SizedBox(height: 10.0),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BroadcastEventDialog(event: widget.event);
                              },
                            );

                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                          ),
                          child: Text('Broadcast'),
                        ),
                      )
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

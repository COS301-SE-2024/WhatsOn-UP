import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

// class Event {
//   final String nameOfEvent;
//   final String dateAndTime;
//   final String location;
//   final List<String> imageUrls;
//   final String description;
//   final String id;
//
//   Event({
//     required this.nameOfEvent,
//     required this.dateAndTime,
//     required this.location,
//     required this.imageUrls,
//     required this.description,
//     required this.id,
//   });
//
//    factory Event.fromJson(Map<String, dynamic> json) {
//     dynamic j = json['eventMedia'];
//
//     // print("EVENTS: ${json}");
//
//     return Event(
//       nameOfEvent: json['title'],
//       dateAndTime: json['startTime'],
//       location: json['location'],
//       imageUrls: (json.containsKey('eventMedia') && (json['eventMedia'] as List).isNotEmpty)
//           ? List<String>.from(json['eventMedia'])
//           : ['https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'],
//       description: json['description'],
//       id: json['id'],
//     );
//    }
// }
//
// class EventCard extends StatelessWidget {
//   final Event event;
//
//   const EventCard({super.key, required this.event});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final cardColour = theme.colorScheme.surface;
//     final textColour = theme.colorScheme.onSurface;
//      bool isBookmarked = false;
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailedEventPage(event: event),
//           ),
//         );
//       },
//       child: Card(
//         color: cardColour,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Container(
//           width: 200,
//           height: 265,
//           decoration: BoxDecoration(
//             color: cardColour,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 4,
//                 blurRadius: 3,
//                 offset: const Offset(0, 0),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 const SizedBox(height: 7.0),
//                 Container(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16.0),
//                     child: Image.network(
//                       event.imageUrls[0],
//                       height: 120.0,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   event.nameOfEvent,
//                   style: TextStyle(
//                     fontSize: 17.0,
//                     fontWeight: FontWeight.bold,
//                     color: textColour,
//                   ),
//                 ),
//                 const SizedBox(height: 4.0),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       size: 20.0,
//                       color: textColour,
//                     ),
//                     Expanded(
//                       child: Text(
//                         event.location,
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: textColour,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                         size: 20.0,
//                         color: isBookmarked ? Colors.black : textColour,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isBookmarked = !isBookmarked; // Toggle bookmark state
//                         });
//
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
class Event {
  late  String nameOfEvent;
  late final String dateAndTime;
  late  String location;
  List<String> imageUrls;
  String description;
  final String id;
  List<String> hosts;
  late final String startTime;
  late final String endTime;
  late int maxAttendees;
  late final bool isPrivate;
  final List<Attendee> attendees;

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
  });

  // factory Event.fromJson(Map<String, dynamic> json) {
  //   return Event(
  //     nameOfEvent: json['title'],
  //     startTime: json['startTime'],
  //     endTime: json['endTime'],
  //     dateAndTime: json['startTime'],
  //     maxAttendees: json['maxAttendees'],
  //     location: json['location'],
  //     isPrivate: json['isPrivate'],
  //     imageUrls: (json.containsKey('eventMedia') &&
  //             (json['eventMedia'] as List).isNotEmpty)
  //         ? List<String>.from(json['eventMedia'])
  //         : [
  //             'https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'
  //           ],
  //     description: json['description'],
  //     id: json['id'],
  //     hosts: (json.containsKey('hosts') && (json['hosts'] as List).isNotEmpty)
  //         ? List<String>.from(json['hosts'].map((host) => host['fullName']))
  //         : [],
  //     attendees: (json.containsKey('attendees') &&
  //         (json['attendees'] as List).isNotEmpty)
  //         ? List<Attendee>.from(json['attendees'].map((attendee) => Attendee.fromJson(attendee)))
  //         : [],
  //   );
  // }
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
      hosts: (json.containsKey('hosts') && (json['hosts'] as List).isNotEmpty)
          ? List<String>.from(json['hosts'].map((host) => host['fullName']?.toString() ?? ''))
          : [],
      attendees: (json.containsKey('attendees') && (json['attendees'] as List).isNotEmpty)
          ? List<Attendee>.from(json['attendees'].map((attendee) => Attendee.fromJson(attendee)))
          : [],
      dateAndTime: json['startTime'],
      startDate: null,
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
    };
  }
}

class EventCard extends StatefulWidget {
  final Event event;
  bool showBookmarkButton;

 

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
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userRole = userP.role;
    widget.showBookmarkButton = userRole == "GUEST" ? false : true; // if user is a guest, don't show bookmark button

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
                              //api to remove this event// Toggle bookmark state
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

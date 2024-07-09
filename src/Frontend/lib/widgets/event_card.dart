
import 'package:firstapp/providers/events_providers.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import 'package:provider/provider.dart';

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


class Event {
  final String nameOfEvent;
  final String dateAndTime;
  final String location;
  final List<String> imageUrls;
  final String description;
  final String id;
  List<String> hosts;

  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    required this.location,
    required this.imageUrls,
    required this.description,
    required this.id,
    required this.hosts,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      nameOfEvent: json['title'],
      dateAndTime: json['startTime'],
      location: json['location'],
      imageUrls: (json.containsKey('eventMedia') && (json['eventMedia'] as List).isNotEmpty)
          ? List<String>.from(json['eventMedia'])
          : ['https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg'],
      description: json['description'],
      id: json['id'],
      hosts: (json.containsKey('hosts') && (json['hosts'] as List).isNotEmpty)
          ? List<String>.from(json['hosts'].map((host) => host['fullName']))
          : [],
    );
  }
}

class EventCard extends StatefulWidget {
  final Event event;
  final bool showBookmarkButton;

  EventCard({Key? key, required this.event, this.showBookmarkButton = true}) : super(key: key);

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
                    child: Image.network(
                      widget.event.imageUrls[0],
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
                            if(isBookmarked==true){
                              eventP.addEventSaved(widget.event);
                              //api to add this event
                            }
                            else{
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

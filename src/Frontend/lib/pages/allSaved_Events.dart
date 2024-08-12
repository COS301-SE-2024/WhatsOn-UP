// import 'package:firstapp/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/detailed_event_page.dart';
// import '../pages/detailed_event_page.dart';
// import '../providers/events_providers.dart';
// import '../services/api.dart';
// import '../widgets/event_card.dart';

// class AllsavedEvents extends StatefulWidget {
//   AllsavedEvents({Key? key}) : super(key: key);

//   @override
//   _AllsavedEventsState createState() => _AllsavedEventsState();
// }

// class _AllsavedEventsState extends State<AllsavedEvents> {
//   late List<Event> events = [];
//   late Api api;
//   bool isLoading = true;
//   bool hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     getEvents();
//   }

//   void getEvents() async {
//     api = Api();
//     try {
//       final user = supabase.auth.currentUser;
//       events = await api.getAllSavedEvents(user!.id);
//     } catch (error) {
//       setState(() {
//         hasError = true;
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saved Events'),
//       ),
//       body: isLoading
//           ? const Center(
//               child: SpinKitPianoWave(
//                 color: Color.fromARGB(255, 149, 137, 74),
//                 size: 50.0,
//               ),
//             )
//           : hasError
//               ? const Center(
//                   child: Text(
//                     'Failed to load events. Please try again later.',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 )
//               : events.isEmpty
//                   ? const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           'You have no saved events. Tap the bookmark button on any event card to save it for later viewing here.',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: events.length,
//                       itemBuilder: (context, index) {
//                         return EventCardS(event: events[index]);
//                       },
//                     ),
//     );
// }


// }

// class EventCardS extends StatelessWidget {
//   final Event event;

//   const EventCardS({Key? key, required this.event}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final cardColour = theme.colorScheme.surface;
//     final textColour = theme.colorScheme.onSurface;

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
//                     child: event.imageUrls.isNotEmpty
//                         ? Image.network(
//                       event.imageUrls[0],
//                       height: 120.0,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     )
//                         : Image.asset(
//                       'assets/images/user.png',
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
//                         event.venue!.name,
//                         style: TextStyle(
//                           fontSize: 14.0,
//                           color: textColour,
//                         ),
//                       ),
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

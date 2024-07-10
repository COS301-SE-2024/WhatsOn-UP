// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/events_providers.dart';
// import '../providers/user_provider.dart';
// import 'event_card.dart';
//
//
//
//
// class EventmanagementCategory extends StatefulWidget {
//   const EventmanagementCategory({super.key});
//
//   @override
//   State<EventmanagementCategory> createState() => _EventmanagementCategoryState();
// }
//
// class _EventmanagementCategoryState extends State<EventmanagementCategory> {
//
//
//
//
//
//
//
//
//   @override
//   Widget _buildHomePage() {
//     userProvider userP = Provider.of<userProvider>(context);
//     EventProvider eventP = Provider.of<EventProvider>(context);
//
//     final theme = Theme.of(context);
//     final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
//     final textColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
//     // futureEvents=eventP.eventsHome;
//     return FutureBuilder<List<Event>>(
//       future: eventP.eventsHome,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: SpinKitPianoWave(
//             color:  Color.fromARGB(255, 149, 137, 74),
//             size: 50.0,
//           ));
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData) {
//           final events = snapshot.data!;
//
//           // Add check to ensure events list is not empty
//           if (events.isEmpty) {
//             return Center(child: Text('No events found.'));
//           }
//
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20.0),
//                  Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Text(
//                     userP.role == 'ADMIN' ? 'All Events' : 'My Events',
//                     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 250.0,
//                   child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                     ),
//                     itemCount: events.length,
//                     itemBuilder: (context, index) {
//                       // Ensure index is within bounds
//                       if (index >= events.length) {
//                         return Container(); // or handle error gracefully
//                       }
//                       print('Event card: ${events[index]}');
//                       EventCard card = EventCard(event: events[index]);
//
//                       return card;
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Text(
//                     'Saved',
//                     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 250.0,
//                   child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                     ),
//                     itemCount: events.length,
//                     itemBuilder: (context, index) {
//                       // Ensure index is within bounds
//                       if (index >= events.length) {
//                         return Container(); // or handle error gracefully
//                       }
//                       return EventCard(event: events[index]);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Center(child: Text('No events found.'));
//         }
//       },
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//
// }
// import 'package:firstapp/providers/events_providers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class EventmanagementCategory extends StatefulWidget {
//   const EventmanagementCategory({super.key});
//
//   @override
//   State<EventmanagementCategory> createState() =>
//       _EventmanagementCategoryState();
// }
//
// class _EventmanagementCategoryState extends State<EventmanagementCategory> {
//   @override
//   Widget build(BuildContext context) {
//     EventProvider eventP = Provider.of<EventProvider>(context);
//     return const Scaffold(
//       body:ListView(
//         shrinkWrap: true,
//         children:eventP.eventsHome.map((event) {
//           return ListTile(
//             title: Text(event.nameOfEvent),
//             subtitle: Text(event.description),
//             trailing: Text(event.date),
//           );
//         }).toList(),
//
//       )
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/providers/events_providers.dart';
//
// import 'Eventcard_management.dart';
//
// class EventmanagementCategory extends StatelessWidget {
//   EventmanagementCategory({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Event Management'), // Adjust the app bar title as needed
//       ),
//       body: Consumer<EventProvider>(
//         builder: (context, eventP, child) {
//           if (eventP.isLoading) {
//             return Center(child: CircularProgressIndicator()); // While data is loading
//           } else if (eventP.hasError || eventP.events.isEmpty) {
//             return Center(child: Text('Error loading events')); // On error or no data
//           } else {
//             // When data is available
//             return ListView.builder(
//               itemCount: eventP.events.length,
//               itemBuilder: (context, index) {
//                 var event = eventP.events[index];
//                 return EventCard(event: event); // Using EventCard widget to display each event
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'Eventcard_management.dart'; // Assuming Eventcard_management.dart contains EventCard widget
//
//
// class EventmanagementCategory extends StatelessWidget {
//   EventmanagementCategory({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Event Management'), // Adjust the app bar title as needed
//       ),
//       body: Consumer<EventProvider>(
//         builder: (context, eventP, child) {
//           // Assuming eventP.events is already populated
//           if (eventP.eventsHome==null) {
//             return Center(child: Text('No events available')); // If no events
//           } else {
//             // When data is available
//             final events = eventP.eventsHome;
//             return ListView.builder(
//               itemCount:events.length,
//               itemBuilder: (context, index) {
//                 var event = events[index];
//                 return EventCard(event: event); // Using EventCard widget to display each event
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/providers/events_providers.dart';
// import 'Eventcard_management.dart'; // Assuming Eventcard_management.dart contains EventCard widget
// import 'event_card.dart';
//
// class EventmanagementCategory extends StatefulWidget {
//   EventmanagementCategory({Key? key}) : super(key: key);
//
//   @override
//   _EventmanagementCategoryState createState() => _EventmanagementCategoryState();
// }
//
// class _EventmanagementCategoryState extends State<EventmanagementCategory> {
//   late Future<List<Event>> _eventsHome;
//
//   @override
//   void initState() {
//     super.initState();
//     EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
//     // Initialize _eventsHome in initState or any other appropriate lifecycle method
//     _eventsHome = eventP.eventsHome;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Event Management'), // Adjust the app bar title as needed
//       ),
//       body: children:[
//
//     Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//     child: Center(
//     child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//     SizedBox(
//     width: MediaQuery.of(context).size.width * 0.27,
//     child: Container(
//     decoration: BoxDecoration(
//     border: Border.all(color: borderColour),
//     borderRadius: BorderRadius.circular(16.0),
//     ),
//     child: TextButton.icon(
//     onPressed: () {
//     // Navigate to SearchScreen when Search button is pressed
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: (context) => SearchScreen(),
//     ),
//     );
//     },
//     icon: Icon(Icons.search, color: textColour),
//     label: Text('Search', style: TextStyle(color: textColour)),
//     ),
//     ),
//     ),
//     SizedBox(width: 35.0),
//     SizedBox(
//     width: MediaQuery.of(context).size.width * 0.27,
//     child: Container(
//     decoration: BoxDecoration(
//     border: Border.all(color: borderColour),
//     borderRadius: BorderRadius.circular(16.0),
//     ),
//     child: TextButton.icon(
//     onPressed: () {
//     // Navigate to SearchScreen when Search button is pressed
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: (context) => FilterScreen(),
//     ),
//     );
//     },
//     icon: Icon(Icons.filter_list, color: textColour),
//     label: Text('Filter', style: TextStyle(color: textColour)),
//     ),
//     ),
//     ),
//     ],
//     ),
//     ),
//     ),
//
//
//
//     FutureBuilder<List<Event>>(
//     future: _eventsHome,
//       builder: (context, AsyncSnapshot<List<Event>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator()); // While data is loading
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error loading events')); // On error
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No events available')); // If no data
//         } else {
//           // When data is available
//           List<Event> events = snapshot.data!;
//           return ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               var event = events[index];
//               return EventCard(event: event,showBookmarkButton:false); // Using EventCard widget to display each event
//             },
//           );
//         }
//       },
//     ),






//
//     ]
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import '../providers/user_provider.dart';
import '../screens/FilterScreen.dart';
import '../screens/SearchScreen.dart';
import 'Eventcard_management.dart'; // Assuming Eventcard_management.dart contains EventCard widget
import 'event_card.dart';

class EventmanagementCategory extends StatefulWidget {
  EventmanagementCategory({Key? key}) : super(key: key);

  @override
  _EventmanagementCategoryState createState() => _EventmanagementCategoryState();
}

class _EventmanagementCategoryState extends State<EventmanagementCategory> {
  late Future<List<Event>> _eventsHome;

  @override
  void initState() {
    super.initState();
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    // Initialize _eventsHome in initState or any other appropriate lifecycle method
    _eventsHome = eventP.eventsHome;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColour = theme.colorScheme.onSurface;
    final borderColour = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'), // Adjust the app bar title as needed
      ),

      body: Column(
        children: [
          SizedBox(width: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to SearchScreen when Search button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.search, color: textColour),
                        label: Text('Search', style: TextStyle(color: textColour)),
                      ),
                    ),
                  ),
                  SizedBox(width: 35.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColour),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to FilterScreen when Filter button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.filter_list, color: textColour),
                        label: Text('Filter', style: TextStyle(color: textColour)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 35.0),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _eventsHome,
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitPianoWave(
                    color:  Color.fromARGB(255, 149, 137, 74),
                    size: 50.0,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading events'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No events available'));
                } else {
                  userProvider userP = Provider.of<userProvider>(context, listen: false);

                  List<Event> events = snapshot.data!;
                  if (userP.role!='ADMIN') {
                    events = events.where((event) => event.hosts.contains(userP.Fullname)).toList();
                  }
                  int rowCount = (events.length / 2).ceil();
                  return ListView.builder(
                   itemCount: rowCount,
                    itemBuilder: (context, rowIndex) {
                      int index1 = rowIndex * 2;
                      int index2 = index1 + 1;
                      return Row(
                        children: [
                          if (index1 < events.length)
                            Expanded(
                              child: EventCard(event: events[index1],showBookmarkButton:false),
                            ),
                          if (index2 < events.length)
                            Expanded(
                              child: EventCard(event: events[index2],showBookmarkButton:false),
                            ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:firstapp/pages/allSaved_Events.dart';
// import 'package:firstapp/widgets/event_card.dart';
// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/rsvp_events_page.dart';
// import 'package:firstapp/pages/calendar_page.dart';
// import 'package:firstapp/pages/explore_page.dart';
// import 'package:firstapp/pages/settings_page.dart';
// import 'package:firstapp/widgets/nav_bar.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:firstapp/pages/profilePage.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../providers/events_providers.dart';
// import '../providers/notification_providers.dart';
// import '../providers/user_provider.dart';
// import '../screens/FilterScreen.dart';
// import '../screens/SearchScreen.dart';
// import 'package:firstapp/services/api.dart';
// import 'package:firstapp/pages/Broadcast.dart';
// import 'package:firstapp/pages/manageEvents.dart';
// import 'package:firstapp/pages/application_event.dart';

// import '../services/socket_client.dart';
// import 'allHome_events.dart';
// import 'notifications.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({
//     Key? key,
//   }) : super(key: key);
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // late Future<List<Event>> futureEvents;
//   Api api = Api();

//   int _selectedIndex = 0;

//   // @override
//   // Future<void> initState() async {
//   //   super.initState();
//   //   await fetchEvents();
//   // }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<List<List<Event>>> fetchEvents() async {
//     EventProvider eventP = Provider.of<EventProvider>(context);
//     final eventsHome = await eventP.eventsHome;
//     final eventsSaved = await eventP.eventsSaved;
//     return [eventsHome, eventsSaved];
//   }

//   @override
//   Widget build(BuildContext context) {
//     userProvider userP = Provider.of<userProvider>(context);

//     const String HOST = 'HOST';
//     const String ADMIN = 'ADMIN';
//     return Scaffold(
//       body: Container(
//         // color: Colors.grey[200],
//         child: _getSelectedPage(_selectedIndex),
//       ),
//       bottomNavigationBar: NavBar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//         userRole: userP.role,
//       ),
//       floatingActionButton: (userP.role == HOST || userP.role == ADMIN) &&
//                             (_selectedIndex != 3)
//           ? Padding(
//               padding: const EdgeInsets.only(right: 15, bottom: 70),
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ApplicationEvent()),
//                     );
//                   },
//                   child: const Icon(Icons.add),
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//               ),
//             )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   Widget _getSelectedPage(int index) {
//     userProvider userP = Provider.of<userProvider>(context);
//     switch (index) {
//       case 0:
//         return _buildHomePage();
//       case 1:
//         return const Notifications();
//       case 2:
//         return const CalendarPage();
//       case 3:
//         return NavigationPage();
//       case 4:
//         return const SettingsPage();
//       case 5:
//         return  ManageEvents(supabaseClient: Supabase.instance.client);

//       case 6:
//         userProvider userP = Provider.of<userProvider>(context, listen: false);
//         EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
//         eventP.refreshSavedEvents(userP.userId);
//         return _buildHomePage();
//       default:
//         return _buildHomePage();
//     }
//   }

//   Widget _buildHomePage() {
//     userProvider userP = Provider.of<userProvider>(context);
//     final theme = Theme.of(context);
//     final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
//     final textColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
//     return FutureBuilder<List<List<Event>>>(
//       future: fetchEvents(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: SpinKitPianoWave(
//             color:  Color.fromARGB(255, 149, 137, 74),
//             size: 50.0,
//           ));
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.hasData) {
//           final eventsHome = snapshot.data![0];
//           final savedEvents = snapshot.data![1];

//           if (eventsHome.isEmpty && savedEvents.isEmpty) {
//             return const Center(child: Text('No events found.'));
//           }

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProfilePage(

//                               ),
//                             ),
//                           );
//                         },
//                         child: CircleAvatar(
//                           backgroundImage: userP.profileImage != null && userP.profileImage!.isNotEmpty
//                               ? NetworkImage(userP.profileImage!)
//                               : const AssetImage('assets/images/user.png') as ImageProvider,
//                           radius: 27.0,
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       child: Text(
//                         'Welcome, ${userP.Fullname}',
//                         style: const TextStyle(
//                           fontSize: 24.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20.0),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.3,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: borderColour),
//                               borderRadius: BorderRadius.circular(16.0),
//                             ),
//                             child: TextButton.icon(
//                               onPressed: () {
//                                 // Navigate to SearchScreen when Search button is pressed
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => SearchScreen(),
//                                   ),
//                                 );
//                               },
//                               icon: Icon(Icons.search, color: textColour),
//                               label: Text('Search',
//                                   style: TextStyle(color: textColour)),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 35.0),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.27,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: borderColour),
//                               borderRadius: BorderRadius.circular(16.0),
//                             ),
//                             child: TextButton.icon(
//                               onPressed: () {

//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => FilterScreen(),
//                                   ),
//                                 );
//                               },
//                               icon: Icon(Icons.filter_list, color: textColour),
//                               label: Text('Filter', style: TextStyle(color: textColour)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                  Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(children: [
//                     const Text(
//                       'Explore More',
//                       style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AllhomeEvents(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         'See more',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                   ],)
//                 ),
//                 SizedBox(
//                   height: 250.0,
//                   child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 1,
//                     ),
//                     itemCount: eventsHome.length,
//                     itemBuilder: (context, index) {

//                       if (index >= eventsHome.length) {
//                         return Container();
//                       }

//                       EventCard card = EventCard(event: eventsHome[index], showBookmarkButton: true);

//                       return card;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 if (userP.role == "GUEST") ... [
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Saved Events',
//                           style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16.0),
//                         Text(
//                           'Log in or create an account to save events and view them here.',
//                           style: TextStyle(
//                             fontSize: 16.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//                 if (userP.role != "GUEST") ... [
//                  const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Saved Events',
//                         style: TextStyle(
//                             fontSize: 18.0, fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),

//                     ],
//                   ),
//                 ),

//                 SizedBox(
//                   height: 250.0,
//                   child: GridView.builder(
//                     scrollDirection: Axis.horizontal,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 1,
//                     ),
//                     itemCount: savedEvents.length,
//                     itemBuilder: (context, index) {
//                       if (index >= savedEvents.length) {
//                         return Container();
//                       }
//                       return EventCard(event: savedEvents[index],showBookmarkButton: true, saved: true);
//                     },
//                   ),
//                 ),
//                 ],
//               ],
//             ),
//           );
//         } else {
//           return const Center(child: Text('No events found.'));
//         }
//       },
//     );
//   }
// }













import 'package:firstapp/pages/allSaved_Events.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:firstapp/pages/calendar_page.dart';
import 'package:firstapp/pages/explore_page.dart';
import 'package:firstapp/pages/settings_page.dart';
import 'package:firstapp/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/events_providers.dart';
import '../providers/notification_providers.dart';
import '../providers/user_provider.dart';
import '../screens/FilterScreen.dart';
import '../screens/SearchScreen.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:firstapp/pages/application_event.dart';
import '../services/socket_client.dart';
import 'allHome_events.dart';
import 'notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  Api api = Api();
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<List<Event>>> fetchEvents() async {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    final eventsHome = await eventP.eventsHome;
    final eventsSaved = await eventP.eventsSaved;
    return [eventsHome, eventsSaved];
  }

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context);

    return Scaffold(
      body: Container(
        child: _getSelectedPage(_selectedIndex),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        userRole: userP.role,
      ),
      floatingActionButton: (userP.role == 'HOST' || userP.role == 'ADMIN') && _selectedIndex != 3
          ? Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 70),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplicationEvent()),
                    );
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return const Notifications();
      case 2:
        return const CalendarPage();
      case 3:
        return NavigationPage();
      case 4:
        return const SettingsPage();
      case 5:
        return ManageEvents(supabaseClient: Supabase.instance.client);
      case 6:
        return _buildHomePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 65.0,
          flexibleSpace: _buildHeader(),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 196, 179, 97),
            labelColor: Color.fromARGB(255, 196, 179, 97),
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 4,
            indicatorPadding: EdgeInsets.only(bottom: 12),
            tabs: const [
              Tab(text: 'Explore'),
              Tab(text: 'My Events'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildExploreTab(),
            _buildMyEventsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    userProvider userP = Provider.of<userProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: userP.profileImage != null && userP.profileImage!.isNotEmpty
                    ? NetworkImage(userP.profileImage!)
                    : const AssetImage('assets/images/user.png') as ImageProvider,
                radius: 27.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Flexible(
              child: Text(
                'Welcome, ${userP.Fullname}',
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildExploreTab() {
    return FutureBuilder<List<List<Event>>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitPianoWave(
              color: Color.fromARGB(255, 149, 137, 74),
              size: 50.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final eventsHome = snapshot.data![0];

          if (eventsHome.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'All Events',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllhomeEvents()),
                          );
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250.0,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: eventsHome.length,
                    itemBuilder: (context, index) {
                      if (index >= eventsHome.length) {
                        return Container();
                      }
                      
                      return EventCard(event: eventsHome[index], showBookmarkButton: true);
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Recommended Events',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                // REcommended events placeholder
                SizedBox(
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        height: 265,
                        margin: const EdgeInsets.only(right: 8.0),
                        color: Colors.grey[300],
                        child: Center(child: Text('Placeholder')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No events found.'));
        }
      },
    );
  }

  Widget _buildMyEventsTab() {
    return FutureBuilder<List<List<Event>>>(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitPianoWave(
              color: Color.fromARGB(255, 149, 137, 74),
              size: 50.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final savedEvents = snapshot.data![1];

          if (savedEvents.isEmpty) {
            return const Center(child: Text('No saved events found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: savedEvents.length,
            itemBuilder: (context, index) {
              if (index >= savedEvents.length) {
                return Container();
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 14.0),
                child: EventCard(event: savedEvents[index], showBookmarkButton: true, saved: true),
              );
            },
          );
        } else {
          return const Center(child: Text('No saved events found.'));
        }
      },
    );
  }
}

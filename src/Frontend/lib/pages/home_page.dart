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

import '../providers/events_providers.dart';
import '../providers/user_provider.dart';
import '../screens/FilterScreen.dart';
import '../screens/SearchScreen.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:firstapp/pages/application_event.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    Key? key,

  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<List<Event>> futureEvents;
  Api api = Api();

  int _selectedIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   futureEvents = api.getAllEvents();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context);
const String HOST='HOST';
const String ADMIN='ADMIN';
    return Scaffold(
      body: Container(
        // color: Colors.grey[200],
        child: _getSelectedPage(_selectedIndex),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        userRole: userP.role,
      ),
      floatingActionButton: (userP.role== HOST || userP.role == ADMIN)
      ? Padding(
          padding: EdgeInsets.only(right: 15, bottom: 70),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApplicationEvent(

                  )),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getSelectedPage(int index) {
    userProvider userP = Provider.of<userProvider>(context);
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return const RsvpEventsPage();
      case 2:
        return const CalendarPage();
      case 3:
        return const ExplorePage();
      case 4:
        return SettingsPage();
      case 5:
        return  ManageEvents();

      case 6:
        return const Broadcast();

      default:
        return _buildHomePage();
    }
  }




  Widget _buildHomePage() {
    userProvider userP = Provider.of<userProvider>(context);
    EventProvider eventP = Provider.of<EventProvider>(context);

    final theme = Theme.of(context);
    final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    // futureEvents=eventP.eventsHome;
    return FutureBuilder<List<Event>>(
      future: eventP.eventsHome,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitPianoWave(
            color:  Color.fromARGB(255, 149, 137, 74),
            size: 50.0,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final events = snapshot.data!;

          // Add check to ensure events list is not empty
          if (events.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(

                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: userP.profileImage!.isNotEmpty
                              ? MemoryImage(userP.profileImage!)
                              : const AssetImage('assets/images/user.png')

                          as ImageProvider,
                          radius: 27.0,
                        ),
                      ),
                    ),
                    Text(
                      'Welcome, ${userP.Fullname}',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                Container(
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
                                // Navigate to SearchScreen when Search button is pressed
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
                SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Explore More',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 250.0,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      // Ensure index is within bounds
                      if (index >= events.length) {
                        return Container(); // or handle error gracefully
                      }

                      EventCard card = EventCard(event: events[index]);

                      return card;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Saved',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 250.0,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      // Ensure index is within bounds
                      if (index >= events.length) {
                        return Container(); // or handle error gracefully
                      }
                      return EventCard(event: events[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No events found.'));
        }
      },
    );

  }
}
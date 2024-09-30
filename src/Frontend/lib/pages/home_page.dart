import 'package:firstapp/pages/allRecommended_events.dart';
import 'package:firstapp/pages/supabase_signup.dart';
import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
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
import '../providers/user_provider.dart';
import '../screens/SearchScreen.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:firstapp/pages/application_event.dart';
import 'allHome_events.dart';
import 'notifications.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Api api = Api();
  int _selectedIndex = 0;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearchInput() {
    _searchController.clear();
    // FocusScope.of(context).unfocus();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<List<Event>>> fetchEvents() async {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    userProvider userP = Provider.of<userProvider>(context, listen: false);
   if(userP.role == 'GUEST') {
     final eventsHome = await eventP.eventsHome;
     return [eventsHome, [], []];
   }
   else {
     final eventsHome = await eventP.eventsHome;
     // final eventsSaved = await eventP.eventsSaved;
     final eventsRecommended = await eventP.recommendations;
     return [eventsHome, [], eventsRecommended];
   }
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
      floatingActionButton:
          (userP.role == 'HOST' || userP.role == 'ADMIN') && _selectedIndex != 3
              ? Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 70),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApplicationEvent()),
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
            indicatorColor: const Color.fromARGB(255, 196, 179, 97),
            labelColor: const Color.fromARGB(255, 196, 179, 97),
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 4,
            indicatorPadding: const EdgeInsets.only(bottom: 12),
            tabs: const [
              Tab(text: 'Explore'),
              Tab(text: 'Saved Events'),
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
                backgroundImage:
                    userP.profileImage != null && userP.profileImage!.isNotEmpty
                        ? NetworkImage(userP.profileImage!)
                        : const AssetImage('assets/images/user.png')
                            as ImageProvider,
                radius: 27.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Flexible(
              child: Text(
                'Welcome, ${userP.Fullname}',
                style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
    userProvider userP = Provider.of<userProvider>(context);
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
          final eventsRecommended = snapshot.data![2];



          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for events',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchScreen(initialQuery: query)),
                        );
                      }
                      _clearSearchInput();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(
                              'Personalised Events',
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 149, 137, 74),
                              ),
                            ),
                            RotateAnimatedText(
                              'Recommended Events',
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color:Color.fromARGB(255, 149, 137, 74),
                              ),
                            ),

                          ],
                          repeatForever: true,
                          pause: const Duration(milliseconds: 200),
                        ),
                      ),
                      const Spacer(),
                      if (userP.role != "GUEST")
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllrecommendedEvents()),
                          );
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250.0,
                  child: userP.role == "GUEST"
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Create an account or sign in to your existing account to receive personalised event recommendations!",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SupabaseSignup()),
                            );
                          },
                          child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Already have an account? Log In',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                      : GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: eventsRecommended.length,
                          itemBuilder: (context, index) {
                            if (index >= eventsRecommended.length) {
                              return Container();
                            }

                            return EventCard(
                              event: eventsRecommended[index],
                              showBookmarkButton: true,
                              recommendations: true,
                            );
                          },
                        ),
                ),


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'All Events',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllhomeEvents()),
                          );
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250.0,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: eventsHome.length,
                    itemBuilder: (context, index) {
                      if (index >= eventsHome.length) {
                        return Container();
                      }

                      userProvider userP = Provider.of<userProvider>(context);
                      if (userP.role != 'GUEST') {
                        return EventCard(event: eventsHome[index], showBookmarkButton: true);
                      }
                      else {
                        return EventCard(event: eventsHome[index], showBookmarkButton: false);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
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
          var savedEvents = snapshot.data![0];
          List<Event> filteredEvents = [];


          for (var event in savedEvents) {
            print(event.saved);
            if (event.saved == true) {
              filteredEvents.add(event);
            }
          }

          if (filteredEvents.isEmpty) {
            return const Center(child: Text('No saved events found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              if (index >= filteredEvents.length) {
                return Container();
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 14.0),
                child: EventCard(
                    event: filteredEvents[index],
                    showBookmarkButton: true,
                    ),
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

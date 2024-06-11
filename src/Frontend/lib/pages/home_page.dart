import 'package:firstapp/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:firstapp/pages/calendar_page.dart';
import 'package:firstapp/pages/explore_page.dart';
import 'package:firstapp/pages/settings_page.dart';
import 'package:firstapp/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstapp/pages/searchbar.dart';
import 'package:firstapp/pages/data_search.dart';
import 'package:firstapp/pages/profilePage.dart';
// import 'package:firstapp/widgets/eventcard.dart';

class HomePage extends StatefulWidget {
  final String profileImageUrl;
  final String userName;
  final String userEmail;
  const HomePage(
      {
        Key? key,
        required this.profileImageUrl,
        required this.userName,
        required this.userEmail,
      }
      ): super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Event> events = [
    Event(
        nameOfEvent: 'Event name 1',
        dateAndTime: '2024/05/28',
        location: 'braam',
        imageUrls: [
          'https://source.unsplash.com/random/200x200?sig=1',
          'https://source.unsplash.com/random/200x200?sig=1',
          'https://source.unsplash.com/random/200x200?sig=1'
        ],
        description: 'This is a test description for Event 1'),
    Event(
        nameOfEvent: 'Event name 2',
        dateAndTime: '2024/05/29',
        location: 'jozi',
        imageUrls: ['https://source.unsplash.com/random/200x200?sig=2'],
        description: 'This is a test description for Event 2'),
    Event(
        nameOfEvent: 'Event name 3',
        dateAndTime: '2024/05/30',
        location: 'pta',
        imageUrls: [
          'https://source.unsplash.com/random/200x200?sig=3',
          'https://source.unsplash.com/random/200x200?sig=3'
        ],
        description: 'This is a test description for Event 3'),
    Event(
        nameOfEvent: 'Event name 4',
        dateAndTime: '2024/05/31',
        location: 'soweto',
        imageUrls: [
          'https://source.unsplash.com/random/200x200?sig=4',
          'https://source.unsplash.com/random/200x200?sig=4',
          'https://source.unsplash.com/random/200x200?sig=4',
          'https://source.unsplash.com/random/200x200?sig=4',
          'https://source.unsplash.com/random/200x200?sig=4'
        ],
        description: 'This is a test description for Event 4'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.grey[200],
        child: _getSelectedPage(_selectedIndex),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _getSelectedPage(int index) {
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
        return  SettingsPage( profileImageUrl: widget.profileImageUrl,
          userName: widget.userName,
          userEmail: widget.userEmail,);
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    final theme = Theme.of(context);
    final borderColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

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
                    // Navigate to another page when the profile icon is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  ProfilePage(
                            profileImageUrl: widget.profileImageUrl,
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                          ),
                      ),
                    );
                  },
                  child:  CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.profileImageUrl), // Replace the URL with your profile image URL
                    radius:
                        24.0, // Adjust the size of the profile icon as needed
                  ),
                ),
              ),
               Text(
                'Welcome, ${widget.userName}',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: borderColour),
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          //   child: IconButton(
          //     onPressed: () {
          //       showSearch(context: context, delegate: DataSearch());
          //     },
          //     icon: const Icon(Icons.search),
          //   ),
          // ),

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
                          showSearch(
                            context: context,
                            delegate: DataSearch(),
                          );
                        },
                        icon: Icon(Icons.search, color: textColour),
                        label: Text('Search',
                            style: TextStyle(
                              color: textColour,
                            )),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Filter Options'),
                                content:
                                    Text('Coming soon'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.filter_list, color: textColour),
                        label: Text('Filter',
                            style: TextStyle(
                              color: textColour,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  Widget062(),
          // Card(
          //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Text(
          //           'Featured Events',
          //           style: TextStyle(
          //             fontSize: 18.0,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         const SizedBox(height: 8.0),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   'Event 1',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text('Date: 01/06/2024'),
          //               ],
          //             ),
          //             ElevatedButton(
          //               onPressed: () {
          //                 // Handle event RSVP
          //               },
          //               child: const Text('RSVP'),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 16.0),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   'Event 2',
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text('Date: 15/06/2024'),
          //               ],
          //             ),
          //             ElevatedButton(
          //               onPressed: () {
          //                 // Handle event RSVP
          //               },
          //               child: const Text('RSVP'),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Explore More',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
                return EventCard(event: events[index]);
              },
            ),
          ),
          SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Saved',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
                return EventCard(event: events[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userRole;

  const NavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> navBarItems = userRole == 'ADMIN'
        ? [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'RSVP Event',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.more_vert),
        label: 'More',
      ),
    ]
        : const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: 'RSVP Events',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];


    List<PopupMenuEntry<int>> popupMenuItems = [
      const PopupMenuItem<int>(
        value: 5,
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ),
      const PopupMenuItem<int>(
        value: 6,
        child: ListTile(
          leading: Icon(Icons.event),
          title: Text('Manage Event'),
        ),
      ),
      const PopupMenuItem<int>(
        value: 7,
        child: ListTile(
          leading: Icon(Icons.broadcast_on_home),
          title: Text('Broadcast'),
        ),
      ),
    ];

    return BottomNavigationBar(
      items: navBarItems.map((item) {

        if (item.label == 'More') {
          return BottomNavigationBarItem(
            icon: PopupMenuButton<int>(
              onSelected: (int result) {
                onItemTapped(result);

              },
              itemBuilder: (BuildContext context) => popupMenuItems,
              child: Icon(Icons.more_vert),
            ),
            label: 'More',
          );
        } else {
          return item;
        }
      }).toList(),
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: selectedIndex,
    );
  }
}


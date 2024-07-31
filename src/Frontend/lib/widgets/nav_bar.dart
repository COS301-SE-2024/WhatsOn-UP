


import 'package:flutter/material.dart';
import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/pages/manageEvents.dart';
class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String userRole;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navBarItems = userRole == 'ADMIN'|| userRole == 'HOST'
        ? [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
      ),
      const BottomNavigationBarItem(
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
        icon: Icon(Icons.notifications),
        label: 'Notifications',
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
    int adjustedIndex = selectedIndex.clamp(0, navBarItems.length - 1);
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
          title: Text('Manage Events'),
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
                if (result == 5) {

                  onItemTapped(navBarItems.length - 1);
                  }else if (result == 6) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ManageEvents()),
                  );
                } else if (result == 7) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Broadcast()),
                  );
                }
              },
              itemBuilder: (BuildContext context) => popupMenuItems,
              child: const Icon(Icons.more_vert),
            ),
            label: 'More',
          );
        } else {
          return item;
        }
      }).toList(),
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme
          .of(context)
          .bottomNavigationBarTheme
          .backgroundColor,
      selectedItemColor: Theme
          .of(context)
          .bottomNavigationBarTheme
          .selectedItemColor,
      unselectedItemColor: Theme
          .of(context)
          .bottomNavigationBarTheme
          .unselectedItemColor,
      currentIndex: selectedIndex,
    );
  }}
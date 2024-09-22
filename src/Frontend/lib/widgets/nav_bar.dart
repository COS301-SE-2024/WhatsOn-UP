import 'package:firstapp/pages/admin_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/Broadcast.dart';
import 'package:firstapp/pages/manageEvents.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    bool isAdminOrHost = userRole == 'ADMIN' || userRole == 'HOST';

    List<BottomNavigationBarItem> navBarItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notifications), label: 'Notifications'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), label: 'Calendar'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.explore), label: 'Explore'),
      if (isAdminOrHost)
        const BottomNavigationBarItem(
          icon: Icon(Icons.more_vert),
          label: 'More',
        )
      else
        const BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Settings'),
    ];

    return BottomNavigationBar(
      items: navBarItems,
      onTap: (index) {
        if (isAdminOrHost && index == navBarItems.length - 1) {
          _showMoreMenu(context);
        } else {
          onItemTapped(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      currentIndex: selectedIndex.clamp(0, navBarItems.length - 1),
    );
  }

  
  void _showMoreMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final screenSize = overlay.size;

    double menuPos = screenSize.height  - 245;

    if (userRole == 'ADMIN') {
      menuPos = screenSize.height  - 300;
    } else if (userRole == 'HOST') {
      menuPos = screenSize.height  - 245;
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(screenSize.width - 200, menuPos, 0, 0),            
      items: [
        const PopupMenuItem<int>(
            value: 0,
            child: ListTile(
                leading: Icon(Icons.settings), title: Text('Settings'))),
        const PopupMenuItem<int>(
            value: 1,
            child: ListTile(
                leading: Icon(Icons.event), title: Text('Manage Events'))),
        const PopupMenuItem<int>(
            value: 2,
            child: ListTile(
                leading: Icon(Icons.broadcast_on_home), title: Text('Broadcast'))),
        if (userRole == 'ADMIN') ... [
          const PopupMenuItem<int>(
              value: 3,
              child: ListTile(
                  leading: Icon(Icons.bar_chart), title: Text('Analytics'))),
        ]
      ],
    ).then((int? result) {
      if (result != null) {
        switch (result) {
          case 0:
            onItemTapped(4);
            break;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ManageEvents(supabaseClient: Supabase.instance.client)));
            break;
          case 2:
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Broadcast();
              },
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminAnalyticsPage()),
            );
            break;
        }
      }
    });
  }
}

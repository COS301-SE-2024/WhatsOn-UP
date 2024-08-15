// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/Broadcast.dart';
// import 'package:firstapp/pages/manageEvents.dart';
// class NavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//   final String userRole;

//   const NavBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//     required this.userRole,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<BottomNavigationBarItem> navBarItems = userRole == 'ADMIN'|| userRole == 'HOST'
//         ? [
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Home',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.notifications),
//         label: 'Notifications',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.calendar_today),
//         label: 'Calendar',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.explore),
//         label: 'Explore',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.more_vert),
//         label: 'More',
//       ),
//     ]
//         : const [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Home',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.notifications),
//         label: 'Notifications',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.calendar_today),
//         label: 'Calendar',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.explore),
//         label: 'Explore',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.settings),
//         label: 'Settings',
//       ),
//     ];
//     int adjustedIndex = selectedIndex.clamp(0, navBarItems.length - 1);
//     List<PopupMenuEntry<int>> popupMenuItems = [
//       PopupMenuItem<int>(
//         value: 5,
//         child: ListTile(
//           leading: Icon(Icons.settings),
//           title: Text('Settings'),
//         ),
//       ),
//       PopupMenuItem<int>(
//         value: 6,
//         child: ListTile(
//           leading: Icon(Icons.event),
//           title: Text('Manage Events'),
//         ),
//       ),
//       PopupMenuItem<int>(
//         value: 7,
//         child: ListTile(
//           leading: Icon(Icons.broadcast_on_home),
//           title: Text('Broadcast'),
//         ),
//       ),
//     ];

//     return BottomNavigationBar(
//       items: navBarItems.map((item) {
//         if (item.label == 'More') {
//           return BottomNavigationBarItem(
//             icon: PopupMenuButton<int>(
//               onSelected: (int result) {
//                 if (result == 5) {

//                   onItemTapped(navBarItems.length - 1);
//                   }else if (result == 6) {

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ManageEvents()),
//                   );
//                 } else if (result == 7) {

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => Broadcast()),
//                   );
//                 }
//               },
//               itemBuilder: (BuildContext context) => popupMenuItems,
//               child: Icon(Icons.more_vert),
//             ),
//             label: 'More',
//           );
//         } else {
//           return item;
//         }
//       }).toList(),
//       onTap: onItemTapped,
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Theme
//           .of(context)
//           .bottomNavigationBarTheme
//           .backgroundColor,
//       selectedItemColor: Theme
//           .of(context)
//           .bottomNavigationBarTheme
//           .selectedItemColor,
//       unselectedItemColor: Theme
//           .of(context)
//           .bottomNavigationBarTheme
//           .unselectedItemColor,
//       currentIndex: selectedIndex,
//     );
//   }}

// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/Broadcast.dart';
// import 'package:firstapp/pages/manageEvents.dart';

// class NavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//   final String userRole;

//   const NavBar({
//     Key? key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//     required this.userRole,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     bool isAdminOrHost = userRole == 'ADMIN' || userRole == 'HOST';

//     List<BottomNavigationBarItem> navBarItems = [
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: 'Home',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.notifications),
//         label: 'Notifications',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.calendar_today),
//         label: 'Calendar',
//       ),
//       const BottomNavigationBarItem(
//         icon: Icon(Icons.explore),
//         label: 'Explore',
//       ),
//       if (isAdminOrHost)
//         BottomNavigationBarItem(
//           icon: Icon(Icons.more_vert),
//           label: 'More',
//         )
//       else
//         const BottomNavigationBarItem(
//           icon: Icon(Icons.settings),
//           label: 'Settings',
//         ),
//     ];

//     return BottomNavigationBar(
//       items: navBarItems,
//       onTap: (index) {
//         if (isAdminOrHost && index == navBarItems.length - 1) {
//           _showMoreMenu(context);
//         } else {
//           onItemTapped(index);
//         }
//       },
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
//       selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
//       unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
//       currentIndex: selectedIndex.clamp(0, navBarItems.length - 1),
//     );
//   }

//   void _showMoreMenu(BuildContext context) {
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
//       ),
//       Offset.zero & overlay.size,
//     );

//     showMenu<int>(
//       context: context,
//       position: position,
//       items: [
//         PopupMenuItem<int>(
//           value: 0,
//           child: ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Settings'),
//           ),
//         ),
//         PopupMenuItem<int>(
//           value: 1,
//           child: ListTile(
//             leading: Icon(Icons.event),
//             title: Text('Manage Events'),
//           ),
//         ),
//         PopupMenuItem<int>(
//           value: 2,
//           child: ListTile(
//             leading: Icon(Icons.broadcast_on_home),
//             title: Text('Broadcast'),
//           ),
//         ),
//       ],
//     ).then((int? result) {
//       if (result != null) {
//         switch (result) {
//           case 0:
//             onItemTapped(4); // Navigate to Settings
//             break;
//           case 1:
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ManageEvents()),
//             );
//             break;
//           case 2:
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Broadcast()),
//             );
//             break;
//         }
//       }
//     });
//   }
// }

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
        BottomNavigationBarItem(
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

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          screenSize.width - 200, screenSize.height - 230, 0, 0),
      items: [
        PopupMenuItem<int>(
            value: 0,
            child: ListTile(
                leading: Icon(Icons.settings), title: Text('Settings'))),
        PopupMenuItem<int>(
            value: 1,
            child: ListTile(
                leading: Icon(Icons.event), title: Text('Manage Events'))),
        PopupMenuItem<int>(
            value: 2,
            child: ListTile(
                leading: Icon(Icons.broadcast_on_home),
                title: Text('Broadcast'))),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Broadcast()));
            break;
        }
      }
    });
  }
}


// import 'package:firstapp/providers/notification_providers.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import '../screens/NotificationDetailScreen.dart';
// import '../widgets/notification_card.dart';
//
//
// class Notifications extends StatefulWidget {
//   const Notifications({super.key});
//
//   @override
//   _NotificationsState createState() => _NotificationsState();
// }
//
// class _NotificationsState extends State<Notifications> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     userProvider userP = Provider.of<userProvider>(context, listen: false);
//     notificationProvider _notificationProvider = notificationProvider(userP.userId);
//
//     return ChangeNotifierProvider<notificationProvider>(
//       create: (context) => _notificationProvider,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Notifications'),
//         ),
//         body: _isLoading
//             ? const Center(
//           child: SpinKitPianoWave(
//             color: Color.fromARGB(255, 149, 137, 74),
//             size: 50.0,
//           ),
//         )
//             : FutureBuilder<List<AppNotification>>(
//           future: _notificationProvider.notifications,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: SpinKitPianoWave(
//                   color: Color.fromARGB(255, 149, 137, 74),
//                   size: 50.0,
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Text('No notifications available'),
//               );
//             } else {
//               final notifications = snapshot.data!;
//               return ListView.separated(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notification = notifications[index];
//                   return Column(
//                       children: [
//                   ListTile(
//                     title: Text(notification.notificationTypes),
//                     subtitle: Text(notification.message),
//                     onTap: () {
//                       notification.markAsSeen();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NotificationDetailScreen(notification: notification),
//                         ),
//                       ).then((_) {
//                         setState(() {});
//                       });
//                     },
//                   ),
//                   _buildDivider(),
//                   ],
//                   );
//                 },
//                 separatorBuilder: (context, index) => _buildDivider(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//   Widget _buildDivider() {
//     return const Divider(
//       height: 1,
//       thickness: 1,
//       indent: 16,
//       endIndent: 16,
//     );
//   }
//
//   // Widget _buildProfileOption({
//   //   required String texttitle,
//   //   required String textsubtitle,
//   //   required AppNotification notification,
//   //   Widget? trailing,
//   //   required VoidCallback onTap,
//   // }) {
//   //   return ListTile(
//   //     title: Text(texttitle),
//   //     subtitle: Text(textsubtitle),
//   //     onTap: () {
//   //       notification.markAsSeen();
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => NotificationDetailScreen(notification: notification),
//   //         ),
//   //       ).then((_) {
//   //         setState(() {});
//   //       });
//   //     },
//   //   );
//   // }
// }
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../screens/NotificationDetailScreen.dart';
import '../widgets/notification_card.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    notificationProvider notif=Provider.of<notificationProvider>(context, listen: false);

    return ChangeNotifierProvider<notificationProvider>(
      create: (context) => notif,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: _isLoading
            ? const Center(
          child: SpinKitPianoWave(
            color: Color.fromARGB(255, 149, 137, 74),
            size: 50.0,
          ),
        )
            :
        FutureBuilder<List<AppNotification>>(
          future: notif.notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitPianoWave(
                  color: Color.fromARGB(255, 149, 137, 74),
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No notifications available'),
              );
            } else {
              final notifications = snapshot.data!;
              final invites = notifications.where((n) => n.notificationTypes == 'invite').toList();
              final broadcasts = notifications.where((n) => n.notificationTypes == 'broadcast').toList();
              final reminders = notifications.where((n) => n.notificationTypes == 'reminder').toList();
              final recommendations = notifications.where((n) => n.notificationTypes == 'recommendation').toList();
              final applications = notifications.where((n) => n.notificationTypes == 'application').toList();
              return ListView(
                children: [
                  if (invites.isNotEmpty)...[    SizedBox(height: 20.0),_buildCategory('INVITES', invites)],

                  if (broadcasts.isNotEmpty)...[   SizedBox(height: 20.0),  _buildCategory('BROADCASTS', broadcasts)],

                  if (reminders.isNotEmpty)...[    SizedBox(height: 20.0), _buildCategory('REMINDERS', reminders)],

                  if (recommendations.isNotEmpty)...[ SizedBox(height: 20.0),_buildCategory('RECOMMENDATIONS', recommendations)],
                  if (applications.isNotEmpty)...[ SizedBox(height: 20.0),_buildCategory('APPLICATIONS', recommendations)]

                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategory(String title, List<AppNotification> notifications) {
    String texttitle = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

          ),

        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            if(notification.notificationTypes=='invite'){
              texttitle = 'Invite';
            }
            else if(notification.notificationTypes=='broadcast'){
              texttitle = 'Broadcast';
            }
            else if(notification.notificationTypes=='reminder'){
               texttitle = 'Reminder';
            }
            else if(notification.notificationTypes=='recommendation'){
               texttitle = 'Recommendation';
            }
            else if(notification.notificationTypes=='application'){
              texttitle = 'Application';
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
              ),
              child: ListTile(
                title: Text(texttitle),
                subtitle: Text(notification.message),
                onTap: () {
                  notification.markAsSeen();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailScreen(notification: notification),
                    ),
                  ).then((_) {

                  });
                },
              ),
            );
          },
          separatorBuilder: (context, index) => _buildDividerA(),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 2,
      indent: 0,
      endIndent: 2,
    );
  }
  Widget _buildDividerA() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}


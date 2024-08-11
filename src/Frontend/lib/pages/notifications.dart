import 'package:firstapp/pages/supabase_signup.dart';
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
    String userRole = userP.role;

    notificationProvider notif =
        Provider.of<notificationProvider>(context, listen: false);

    return ChangeNotifierProvider<notificationProvider>(
      create: (context) => notif,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: userRole == "GUEST"
            ? _buildGuestView()
            : _buildNotificationsView(notif),
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Create an account or sign in to your existing account to receive personalised event recommendations, invites from other users, and stay up to date with important notifications!",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupabaseSignup()),
                  );
                },
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Already have an account? Log In',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsView(notificationProvider notif) {
    return _isLoading
        ? const Center(
            child: SpinKitPianoWave(
              color: Color.fromARGB(255, 149, 137, 74),
              size: 50.0,
            ),
          )
        : FutureBuilder<List<AppNotification>>(
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
                final invites = notifications
                    .where((n) => n.notificationTypes == 'invite')
                    .toList();
                final broadcasts = notifications
                    .where((n) => n.notificationTypes == 'broadcast')
                    .toList();
                final reminders = notifications
                    .where((n) => n.notificationTypes == 'reminder')
                    .toList();
                final recommendations = notifications
                    .where((n) => n.notificationTypes == 'recommendation')
                    .toList();
                final applications = notifications
                    .where((n) => n.notificationTypes == 'application')
                    .toList();

                return ListView(
                  children: [
                    if (invites.isNotEmpty) ...[
                      SizedBox(height: 20.0),
                      _buildCategory('INVITES', invites)
                    ],
                    if (broadcasts.isNotEmpty) ...[
                      SizedBox(height: 20.0),
                      _buildCategory('BROADCASTS', broadcasts)
                    ],
                    if (reminders.isNotEmpty) ...[
                      SizedBox(height: 20.0),
                      _buildCategory('REMINDERS', reminders)
                    ],
                    if (recommendations.isNotEmpty) ...[
                      SizedBox(height: 20.0),
                      _buildCategory('RECOMMENDATIONS', recommendations)
                    ],
                    if (applications.isNotEmpty) ...[
                      SizedBox(height: 20.0),
                      _buildCategory('APPLICATIONS', applications)
                    ]
                  ],
                );
              }
            },
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
            if (notification.notificationTypes == 'invite') {
              texttitle = 'Invite';
            } else if (notification.notificationTypes == 'broadcast') {
              texttitle = 'Broadcast';
            } else if (notification.notificationTypes == 'reminder') {
              texttitle = 'Reminder';
            } else if (notification.notificationTypes == 'recommendation') {
              texttitle = 'Recommendation';
            } else if (notification.notificationTypes == 'application') {
              texttitle = 'Application';
            }

            return Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius:
                    BorderRadius.circular(8.0), // Optional: rounded corners
              ),
              child: ListTile(
                title: Text(texttitle),
                subtitle: Text(notification.message),
                onTap: () {
                  notification.markAsSeen();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationDetailScreen(notification: notification),
                    ),
                  ).then((_) {});
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

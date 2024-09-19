
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/NotificationDetailScreen.dart';
import '../widgets/notification_card.dart';


class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String currentTab = "Unseen";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _refreshNotifications();
  }

  @override
  void dispose() {

    _tabController.dispose();
    super.dispose();
  }
  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        currentTab = "Unseen";
      } else if (_tabController.index == 1) {
        currentTab = "Seen";
      } else {
        final userP = Provider.of<userProvider>(context, listen: false);
        if (userP.role == "ADMIN") {
          currentTab = "Applications";
        } else {
          currentTab = "Invitations";
        }

      }
    });
  }
  Future<void> _refreshNotifications() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.red,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              tabs: [
                const Tab(
                  text: "Unseen",
                ),
                const Tab(
                  text: "Seen",
                ),
                if (userP.role == "ADMIN")
                  const Tab(
                    text: "Applications",
                  )
                else
                  const Tab(
                    text: "Invitations",
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationsView("Unseen"),
                  _buildNotificationsView("Seen"),
                  if (userP.role == "ADMIN")
                    _buildNotificationsAdminView("Applications")
                  else
                    _buildNotificationsView("Invitations"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsView(String tab) {
    return Consumer<notificationProvider>(
      builder: (context, notif, child) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (notif.notifications.isEmpty) {
          return Center(child: Text("No notifications available."));
        } else {
          final notifications = notif.notifications;
          print('Notifications: $notifications');
          if(tab == "Unseen"){

          final broadcasts = notifications
              .where((n) => n.notificationTypes == 'broadcast'&& n.seenAt == null )
              .toList();
          final reminders = notifications
              .where((n) => n.notificationTypes == 'reminder'&& n.seenAt == null )
              .toList();
          final recommendations = notifications
              .where((n) => n.notificationTypes == 'recommendation'&& n.seenAt == null )
              .toList();
          final applications = notifications
              .where((n) => n.notificationTypes == 'application'&& n.seenAt == null )
              .toList();
          final invites = notifications
              .where((n) => n.notificationTypes == 'invite'&& n.seenAt == null )
              .toList();
          return ListView(
            children: [
              if (broadcasts.isNotEmpty) ...[
                SizedBox(height: 20.0),
                _buildCategory('BROADCASTS', broadcasts),
              ],
              if (recommendations.isNotEmpty) ...[
                SizedBox(height: 20.0),
                _buildCategory('RECOMMENDATIONS', recommendations),
              ],
              if ( reminders.isNotEmpty) ...[
                SizedBox(height: 20.0),
                _buildCategory('REMINDERS',  reminders),
              ],
              if ( applications.isNotEmpty) ...[
                SizedBox(height: 20.0),
                _buildCategory('APPLICATIONS',  applications),
              ],
              if ( invites.isNotEmpty) ...[
                SizedBox(height: 20.0),
                _buildCategory('INVITES',  invites),
              ],
            ],
          );
        }else if(tab == "Seen"){
            final broadcasts = notifications
                .where((n) => n.notificationTypes == 'broadcast' && n.seenAt != null )
                .toList();
            final reminders = notifications
                .where((n) => n.notificationTypes == 'reminder' && n.seenAt != null )
                .toList();
            final recommendations = notifications
                .where((n) => n.notificationTypes == 'recommendation' && n.seenAt != null )
                .toList();

              final applications = notifications
                  .where((n) => n.notificationTypes == 'application' && n.seenAt != null )
                  .toList();
              final invites = notifications
                  .where((n) => n.notificationTypes == 'invite' && n.seenAt != null )
                  .toList();

            return ListView(
              children: [
                if (broadcasts.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('BROADCASTS', broadcasts),
                ],
                if (recommendations.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('RECOMMENDATIONS', recommendations),
                ],
                if ( reminders.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('REMINDERS',  reminders),
                ],
                if ( applications.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('APPLICATIONS',  applications),
                ],
                if ( invites.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('INVITES',  invites),
                ],
              ],
            );
          }

        else {
            final invites = notifications
                .where((n) => n.notificationTypes == 'invite'&& n.seenAt == null || n.seenAt != null)
                .toList();
            return ListView(
              children: [
                if (invites.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('INVITES', invites),
                ],
              ],
            );
          }

        }
      },
    );
  }
  Widget _buildNotificationsAdminView(String tab) {
    return Consumer<notificationProvider>(
      builder: (context, notif, child) {
        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (notif.notifications.isEmpty) {
          return   Center(child: Text("You have no notifications."));

        } else {
          var notifications = notif.notifications;
            final applications = notifications
                .where((n) => n.notificationTypes == 'application'&& n.seenAt == null )
                .toList();
            return ListView(
              children: [
                if (applications.isNotEmpty) ...[
                  SizedBox(height: 20.0),
                  _buildCategory('APPLICATIONS', applications),
                ],
              ],
            );
        }
      },
    );
  }
  Widget _buildCategory(String title, List<AppNotification> notifications) {
    String texttitle = '';
    notificationProvider notif = Provider.of<notificationProvider>(context, listen: false);
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



            return ListTile(

              leading: CircleAvatar(child: Icon(Icons.notifications),
              ),
              title: Text(texttitle),
              subtitle: Text(
                notification.message.length > 50
                    ? '${notification.message.substring(0, 50)}...'
                    : notification.message,
              ),
              onTap: () {
                final userProvider userP = Provider.of<userProvider>(context, listen: false);

                if (notification.notificationId != null) {
                  if(notification.seenAt == null){
                    notification.markAsSeen(notification.notificationId, userP.JWT);
                    notif.refreshNotifications(userP.JWT);
                  }
                  print(notification.seenAt);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailScreen(notification: notification),
                    ),
                  ).then((_) {});
                } else {
                  print("Unexpected null value in Notification ID or JWT");
                }
              },
            );
          },
          separatorBuilder: (context, index) => Divider(color: Colors.transparent,),
        ),
      ],
    );
  }
}

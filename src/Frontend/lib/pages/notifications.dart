
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
    notificationProvider _notificationProvider = notificationProvider(userP.userId);

    return ChangeNotifierProvider<notificationProvider>(
      create: (context) => _notificationProvider,
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
            : FutureBuilder<List<AppNotification>>(
          future: _notificationProvider.notifications,
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
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.notificationTypes),
                    subtitle: Text(notification.message),
                    onTap: () {
                      notification.markAsSeen();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailScreen(notification: notification),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

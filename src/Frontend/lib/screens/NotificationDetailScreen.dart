import 'package:flutter/material.dart';

import '../widgets/notification_card.dart';

class NotificationDetailScreen extends StatelessWidget {
  final AppNotification notification;

  NotificationDetailScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sent At: ${notification.sentAt}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10.0),
            Text(
              notification.message,
              style: TextStyle(fontSize: 18.0),
            ),
            Spacer(),
            Text(
              'Seen At: ${notification.seenAt ?? 'Not seen yet'}',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}

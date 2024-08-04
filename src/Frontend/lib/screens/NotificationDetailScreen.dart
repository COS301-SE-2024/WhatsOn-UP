import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/api.dart';
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
            SizedBox(height: 20.0),
            _buildDivider(),
            SizedBox(height: 10.0),
            Text(
              'Subject: ${notification.notificationTypes}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            _buildDivider(),
            SizedBox(height: 20.0),
            Text(
              'Message:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              notification.message,
              style: TextStyle(fontSize: 18.0),
            ),

            if(notification.notificationTypes=='invite')...[

              SizedBox(height: 20.0),
              _buildDivider(),
              SizedBox(height: 20.0),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

              TextButton(
                onPressed: () {

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.black),
                ),
                child: Text('Decline'),
              ),
              TextButton(
                onPressed: () {
                  _Accept();

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.greenAccent,
                  side: BorderSide(color: Colors.black),
                ),
                child: Text('Accept'),
              ),
              ],),
              SizedBox(height: 20.0),
              _buildDivider(),
            ],
            if(notification.notificationTypes=='reminder')...[
              SizedBox(height: 20.0),
              _buildDivider(),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar');

                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: BorderSide(color: Colors.black),
                ),
                child: Text('Go to Calendar'),
              ),
              SizedBox(height: 20.0),
              _buildDivider(),
            ],
            SizedBox(height: 20.0),

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

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
    );
  }






  Future<void> _Accept() async {



    Api api = Api();
    api.AcceptInvite(userId: notification.userId, notificationId:notification.notificationId).then((response){
      if (response['error'] != null) {
        print('An error occurred: ${response['error']}');
      } else {
        print('Invite accepted');
      }
    });




    print('signup successful');

  }
}

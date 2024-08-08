
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/api.dart';
import '../utils.dart';
import '../widgets/notification_card.dart';

class NotificationDetailScreen extends StatefulWidget {
  final AppNotification notification;

  NotificationDetailScreen({required this.notification});

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  bool isLoading = false;
  Future<void> _Accept() async {
    setState(() {
      isLoading = true;
    });

    Api api = Api();
    try {
      var response = await api.AcceptInvite(userId: widget.notification.userId, notificationId: widget.notification.notificationId);

      if (response['status'] == 'error') {


      } else {
        print('Invite accepted');
        Navigator.of(context).pushReplacementNamed('/notifications');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("Invite already accepted")) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This invite has been already accepted"))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: $e"))
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> _Decline() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   Api api = Api();
  //   var response = await api.DeclineInvite(userId: widget.notification.userId, notificationId: widget.notification.notificationId);
  //   if (response['error'] != null) {
  //     print('An error occurred: ${response['error']}');
  //   } else {
  //     print('Invite declined');
  //   }
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   Navigator.of(context).pushReplacementNamed( '/notifications');
  // }

  @override
  Widget build(BuildContext context) {
    String formattedDateSentAt = formatDateTime(widget.notification.sentAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notification.notificationTypes),
      ),
      body: isLoading
          ? Center(
        child: SpinKitPianoWave(
          color: Color.fromARGB(255, 149, 137, 74),
          size: 50.0,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 150.0),
            Text(
              'Sent At: $formattedDateSentAt',
              style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
            ChatBubble(
              clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
              backGroundColor: Colors.blueAccent,
              margin: EdgeInsets.all(20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  widget.notification.message,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            Text(
              'Seen At: ${widget.notification.seenAt ?? 'Not seen yet'}',
              style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
            if (widget.notification.notificationTypes == 'invite') ...[
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TextButton(
                  //   onPressed: _Decline,
                  //   style: TextButton.styleFrom(
                  //     foregroundColor: Colors.red,
                  //     side: BorderSide(color: Colors.black),
                  //     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  //   ),
                  //   child: Text('Decline'),
                  // ),
                  if(widget.notification.eventInvite ==null || widget.notification.eventInvite == false)
                  TextButton(
                    onPressed: _Accept,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.greenAccent,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    ),
                    child: Text('Accept'),
                  ),
                  if(widget.notification.eventInvite == true)
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("This invite has been already accepted"))
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.greenAccent,
                        side: BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                      ),
                      child: Text('Accepted'),
                    ),
                ],
              ),
            ],
            if (widget.notification.notificationTypes == 'reminder') ...[
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/calendar');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: BorderSide(color: Colors.black),
                ),
                child: Text('Go to Calendar'),
              ),
              SizedBox(height: 20.0),
            ],
          ],
        ),
      ),
    );
  }
}

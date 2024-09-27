import 'package:firstapp/pages/rate_event.dart';
import 'package:firstapp/providers/notification_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/api.dart';
import '../utils.dart';
import '../widgets/notification_card.dart';

class NotificationDetailScreen extends StatefulWidget {
  final AppNotification notification;

  NotificationDetailScreen({required this.notification});
  

  @override
  _NotificationDetailScreenState createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  bool isLoading = false;
  void setLoading(bool isLoading) {
    setState(() {
      isLoading = isLoading;
    });
  }

  Future<void> _Accept() async {
  userProvider userP = Provider.of<userProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    Api api = Api();
    try {
      var response = await api.AcceptInvite(
          JWT: userP.JWT,
          notificationId: widget.notification.notificationId);

      if (response['status'] == 'error') {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This invite has been accepted"), backgroundColor: Colors.green));
        Navigator.of(context).pushReplacementNamed('/notifications');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("Invite already accepted")) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("This invite has been already accepted"), backgroundColor: Colors.red));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("An error occurred: $e")));
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _Acknowledge() async {
    setState(() {
      isLoading = true;
    });

    Api api = Api();
    try {
userProvider userP = Provider.of<userProvider>(context, listen: false);
      var response =
          await api.Acknowledgeapplication(JWT: userP.JWT);

      if (response['status'] == 'error') {
      } else {
        SnackBar(content: Text("Application Acknowledged"), backgroundColor: Colors.green);
      }
    } catch (e) {

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("This application has been already acknowledged"), backgroundColor: Colors.red));

    } finally {
      Navigator.of(context).pushReplacementNamed('/notifications');
      setState(() {
        isLoading = false;
      });
    }
  }

  String? _extractEventName(String message) {
    final RegExp regex = RegExp(r'"([^"]*)"');
    final match = regex.firstMatch(message);
    return match?.group(1);
  }

  bool _showRateEventButton() {
    return widget.notification.notificationTypes == 'broadcast' &&
        widget.notification.message.startsWith(
            '🎉 We hope you had a fantastic time at') &&
        widget.notification.message.contains(
            'Please take a moment to rate the event and share your feedback.');
  }

  void _navigateToRateEvent() {
    final eventId = widget.notification.referencedEvent;
    final eventName = _extractEventName(widget.notification.message);
    
    if (eventId != null && eventName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RateEventPage(
            eventId: eventId,
            eventName: eventName,
            ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to rate event. Missing information.")),
      );
    }
  }


  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _showDeleteConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Notification"),
        content: const Text(
          "Are you sure you want to delete this notification?",
          style: TextStyle(fontSize: 17),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "No",
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              "Yes",
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteNotification();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

 Future<void> _deleteNotification() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    notificationProvider _notificationProvider = Provider.of<notificationProvider>(context, listen: false);

    Api api = Api();
    try {
      await api.deleteNotification(widget.notification.notificationId, userP.JWT);
      print("Notification deleted");    
      _notificationProvider.removeNotification(widget.notification.notificationId);
      await _notificationProvider.refreshNotifications(userP.JWT);
      Navigator.of(context).pop();
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred while deleting the notification")));
      print("Error deleting notification: $e");
    } 
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateSentAt = formatDateTime(widget.notification.sentAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(widget.notification.notificationTypes)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
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
                    style:
                        TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.end,
                  ),
                  ChatBubble(
                    clipper:
                        ChatBubbleClipper3(type: BubbleType.receiverBubble),
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
                  if (_showRateEventButton()) ...[
                    SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _navigateToRateEvent,
                        child: Text('Rate Event'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                  if (widget.notification.notificationTypes == 'invite') ...[
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.notification.message.contains('###'))...[
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "This invite has been accepted")));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 0, 128, 132),
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            child: Text('Already Accepted'),
                          ),
                        ]else ...[
                          TextButton(
                            onPressed: () {
                              _Accept();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 0, 128, 132),
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            child: Text('Accept invite'),
                          ),
                          ],

                      ],
                    ),
                  ],
                  if (widget.notification.notificationTypes == 'reminder') ...[
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
                  ],

                  if (widget.notification.notificationTypes ==
                      'application') ...[
                    TextButton(
                      onPressed: _Acknowledge,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.black),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                      ),
                      child: const Text('Acknowledge'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

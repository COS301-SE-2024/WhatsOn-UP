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

  const NotificationDetailScreen({super.key, required this.notification});

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
    setState(() {
      isLoading = true;
    });

    Api api = Api();
    try {
      var response = await api.AcceptInvite(
          userId: widget.notification.userId,
          notificationId: widget.notification.notificationId);

      if (response['status'] == 'error') {
      } else {
        Navigator.of(context).pushReplacementNamed('/notifications');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("Invite already accepted")) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This invite has been already accepted")));
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
      var response =
          await api.Acknowledgeapplication(userId: widget.notification.userId);

      if (response['status'] == 'error') {
      } else {
        const SnackBar(content: Text("Application Acknowledged"));
      }
    } catch (e) {

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("An error occurred: $e")));

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
      await api.deleteNotification(widget.notification.notificationId, userP.userId);
      print("Notification deleted");    
      _notificationProvider.removeNotification(widget.notification.notificationId);
      await _notificationProvider.refreshNotifications(userP.userId);
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
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
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
                  const SizedBox(height: 150.0),
                  Text(
                    'Sent At: $formattedDateSentAt',
                    style:
                        const TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.end,
                  ),
                  ChatBubble(
                    clipper:
                        ChatBubbleClipper3(type: BubbleType.receiverBubble),
                    backGroundColor: Colors.blueAccent,
                    margin: const EdgeInsets.all(20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        widget.notification.message,
                        style: const TextStyle(color: Colors.white, fontSize: 18.0),
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
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.notification.eventInvite == null ||
                            widget.notification.eventInvite == false)
                          TextButton(
                            onPressed: _Accept,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.greenAccent,
                              side: const BorderSide(color: Colors.black),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            child: const Text('Accept'),
                          ),
                        if (widget.notification.eventInvite == true)
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                      "This invite has been already accepted")));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.greenAccent,
                              side: const BorderSide(color: Colors.black),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            child: const Text('Accepted'),
                          ),
                      ],
                    ),
                  ],
                  if (widget.notification.notificationTypes == 'reminder') ...[
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/calendar');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text('Go to Calendar'),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                  if (widget.notification.notificationTypes ==
                      'application') ...[
                    TextButton(
                      onPressed: _Acknowledge,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(
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

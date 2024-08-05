import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/api.dart';
import '../widgets/event_card.dart';
import 'editProfile_page.dart';


class EventHost extends StatefulWidget {
  User user;
  EventHost({super.key, required this.user});

  @override
  State<EventHost> createState() => _EventHostState();
}



class _EventHostState extends State<EventHost> {

TextEditingController messageController = TextEditingController();
bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child:SpinKitPianoWave(
        color:  Color.fromARGB(255, 149, 137, 74),
        size: 50.0,
      ))
          : Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.user.profileImage!.isNotEmpty
                            ? NetworkImage(widget.user.profileImage!)
                            : const AssetImage('assets/images/user.png'),

                        radius: 60.0,

                      ),

                      ]

                  ),
                  const SizedBox(height: 10),
                  Text(
                    // widget.userName,
                    widget.user.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 8),
                  Text(
                    // widget.userEmail,
                    widget.user.email,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller:messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write a message to the user',
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _NotifyUser,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.grey, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Send response',

                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
Future<void> _NotifyUser() async {
  setState(() {
    _isLoading = true;
  });
    Api api = Api();
  if (messageController.text.isNotEmpty) {
    final message = messageController.text;


    final response = await Api().postNotifyUser(
      userId: widget.user.userId,
      message: message,
    );

    if (response['error'] != null) {
      print('An error occurred: ${response['error']}');
      _isLoading = false;
    } else {
      print('Message sent successfully');
      await showSentDialog();
    }
  }
  else{
    final message='The status of your application is ${widget.user.userStatus}';
    final response = await Api().postNotifyUser(
      userId: widget.user.userId,
      message: message,
    );
    if (response['error'] != null) {
      print('An error occurred: ${response['error']}');
    } else {
      print('Message sent successfully');
      await showSentDialog();
    }
  }



  }






Future<void> showSentDialog() async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success!'),
        content: const Text('Notification sent.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              ); // Navigate to ProfilePage
            },
          ),
        ],
      );
    },
  );
}



}



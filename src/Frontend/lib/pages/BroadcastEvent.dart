// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/services/api.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../widgets/event_card.dart';
//
// class BroadcastEvent extends StatefulWidget {
//   final Event event;
//   const BroadcastEvent({super.key, required this.event});
//
//   @override
//   State<BroadcastEvent> createState() => _BroadcastEventState();
// }
//
// class _BroadcastEventState extends State<BroadcastEvent> {
//   TextEditingController messageController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//           padding: EdgeInsets.all(30),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40)
//                 ,
//
//                 const Text(
//                   'Broadcast Message',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//
//                 Stack(children: [
//                   Center(
//                     child: TextField(
//                       controller: messageController,
//                       minLines: 1,
//                       maxLines: 100,
//                       style: TextStyle(fontSize: 20),
//                       decoration: InputDecoration(
//                           border:OutlineInputBorder()
//                       ),
//                     ),
//
//                   ),
//                   const SizedBox(height: 40),
//
//
//                 ]),
//                 const SizedBox(height: 40),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _sendEventBeroadcast,
//                       child: Text('Submit'),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/home');
//                       },
//                       child: const Text(
//                         'Cancel',
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0),
//                       ),
//                     ),
//                   ],
//                 )
//               ])
//
// /////////////////////////////////
//           ),
//     );
//   }
//   Future<void> _sendEventBeroadcast()async {
//     userProvider userP = Provider.of<userProvider>(context,listen:false);
//
//     Api api=Api();
//
//     try {
//       final response = await api.broadcastEvent(widget.event.id,messageController.text,userP.userId);
//       if(response['status']=='success'){
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Broadcast sent successfully"),backgroundColor: Colors.green,));
//         Navigator.pushNamed(context, '/manageEvents');
//       }
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("An error occurred: $e"),backgroundColor: Colors.red,));
//       print('Error sending broadcast: $e');
//     }
//     print('broadcast sent');
//   }
//
//   }

import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/event_card.dart';

class BroadcastEventDialog extends StatelessWidget {
  final Event event;
  BroadcastEventDialog({required this.event});

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Broadcast Message',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(

              controller: messageController,
              minLines: 1,
              maxLines: 20,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Write your announcement here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _sendEventBroadcast(context),
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEventBroadcast(BuildContext context) async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    Api api = Api();

    try {
      final response = await api.broadcastEvent(event.id, messageController.text, userP.userId);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Broadcast sent successfully"), backgroundColor: Colors.green),
        );

        Navigator.of(context).pop(); // Close the dialog after submission
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
      print('Error sending broadcast: $e');
    }
  }
}

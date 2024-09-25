
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/services/api.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_selector/emoji_selector.dart';
// import '../widgets/event_card.dart';
//
// class BroadcastEventDialog extends StatelessWidget {
//   final Event event;
//   BroadcastEventDialog({required this.event});
//
//   final TextEditingController messageController = TextEditingController();
//   EmojiData? selectedEmoji;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Broadcast Message',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//
//               controller: messageController,
//               minLines: 1,
//               maxLines: 20,
//               style: TextStyle(fontSize: 20),
//               decoration: InputDecoration(
//                 labelText: 'Write your announcement here',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.emoji_emotions),
//                   onPressed: () => _showEmojiPicker(context),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => _sendEventBroadcast(context),
//                   child: Text('Submit'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   void _showEmojiPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: EmojiSelector(
//             onSelected: (emoji) {
//               messageController.text += emoji.char;
//               Navigator.pop(context);
//             },
//             columns: 11,
//             padding: const EdgeInsets.all(10),
//           ),
//         );
//       },
//     );
//   }
//   Future<void> _sendEventBroadcast(BuildContext context) async {
//     userProvider userP = Provider.of<userProvider>(context, listen: false);
//
//     Api api = Api();
//
//     try {
//       final response = await api.broadcastEvent(event.id, messageController.text, userP.userId);
//       if (response['status'] == 'success') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Broadcast sent successfully"), backgroundColor: Colors.green),
//         );
//
//         Navigator.of(context).pop(); // Close the dialog after submission
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
//       );
//       print('Error sending broadcast: $e');
//     }
//   }
// }
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:emoji_selector/emoji_selector.dart';
import '../widgets/event_card.dart';

class BroadcastEventDialog extends StatefulWidget {
  final Event event;
  const BroadcastEventDialog({super.key, required this.event});

  @override
  _BroadcastEventDialogState createState() => _BroadcastEventDialogState();
}

class _BroadcastEventDialogState extends State<BroadcastEventDialog> {
  final TextEditingController messageController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Write your announcement here',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () => _showEmojiPicker(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child:  SpinKitPianoWave(
                color: Color.fromARGB(255, 149, 137, 74),
                size: 50.0,
              )),
            if (!_isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _sendEventBroadcast(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: EmojiSelector(
            onSelected: (emoji) {
              messageController.text += emoji.char;
              Navigator.pop(context);
            },
            columns: 11,
            padding: const EdgeInsets.all(10),
          ),
        );
      },
    );
  }

  Future<void> _sendEventBroadcast(BuildContext context) async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    Api api = Api();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await api.broadcastEvent(widget.event.id, messageController.text, userP.JWT);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Broadcast sent successfully"), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
      print('Error sending broadcast: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

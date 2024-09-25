
import 'package:emoji_selector/emoji_selector.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
class Broadcast extends StatefulWidget {
  const Broadcast({super.key});

  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

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
                labelText: 'Write your announcement here..',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () => _showEmojiPicker(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isLoading
                    ? const SpinKitPianoWave(
            color: Color.fromARGB(255, 149, 137, 74),
        size: 50.0,
      )
                    : ElevatedButton(
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
              setState(() {
                messageController.text += emoji.char;
              });
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
    setState(() {
      isLoading = true;
    });

    userProvider userP = Provider.of<userProvider>(context, listen: false);
    Api api = Api();
    try {
      final response = await api.broadcast(messageController.text, userP.JWT);
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Broadcast sent successfully"), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
      else if(response['status'] == '403') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Only admins can broadcast'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firstapp/services/api.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class RateEventPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  const RateEventPage({Key? key, required this.eventId, required this.eventName}) : super(key: key);

  @override
  _RateEventPageState createState() => _RateEventPageState();
}

class _RateEventPageState extends State<RateEventPage> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  Api api = Api();
  

  Future<void> _submitRating() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
  
    try {
      final response = await api.rateEvent(
        widget.eventId,
        userP.JWT,
        _rating,
        _feedbackController.text,
      );

      print('EVENT RATING RESPONSE: $response');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your rating has been submitted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      
    } catch (e) {
      print('Error submitting rating: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit rating. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please rate the event "${widget.eventName}"',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('How would you rate this event?'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Additional Feedback (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _submitRating,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
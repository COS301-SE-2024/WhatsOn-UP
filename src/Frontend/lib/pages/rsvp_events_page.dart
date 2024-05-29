import 'package:flutter/material.dart';

class RsvpEventsPage extends StatelessWidget {
  const RsvpEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVP Events'),
      ),
      body: const Center(
        child: ListTile(
      title: Text('ListTile with red background'),
      tileColor: Colors.red,
    ),
      ),
    );
  }
}
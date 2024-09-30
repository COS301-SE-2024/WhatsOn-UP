import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoEventsFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('No Events'),
      ),
      body: Center(
        child: Text(
          'No events with this category found',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

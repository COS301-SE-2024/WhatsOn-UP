import 'package:flutter/material.dart';

class HostAnalyticsPage extends StatefulWidget {
  @override
  _HostAnalyticsPageState createState() => _HostAnalyticsPageState();
}

class _HostAnalyticsPageState extends State<HostAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Analytics'),
      ),
      body: Center(
        child: Text(
          'Host Analytics Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
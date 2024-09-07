import 'package:flutter/material.dart';

class AdminAnalyticsPage extends StatefulWidget {
  @override
  _AdminAnalyticsPageState createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends State<AdminAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Analytics'),
      ),
      body: Center(
        child: Text(
          'Admin Analytics Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
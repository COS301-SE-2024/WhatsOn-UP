import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const StatsCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

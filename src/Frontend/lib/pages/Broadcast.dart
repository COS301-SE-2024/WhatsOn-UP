
import 'package:flutter/material.dart';

class Broadcast extends StatelessWidget {
  const Broadcast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Broadcast',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 350,),
              Center(
                child: Text('Broadcast Page - Coming soon'),
              ),
            ]
        )
    );
  }
}
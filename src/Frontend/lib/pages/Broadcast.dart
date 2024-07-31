import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Broadcast extends StatelessWidget {
  const Broadcast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.fromLTRB(48.0, 16.0, 16.0, 16.0),
                child: Text(
                  'Broadcast',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 350),
              Center(
                child: Text('Broadcast Page - Coming soon'),
              ),
            ],
          ),
          Positioned(
            top: 60.0,
            left: 10.0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(LineAwesomeIcons.angle_left_solid),
            ),
          ),
        ],
      ),
    );
  }
}

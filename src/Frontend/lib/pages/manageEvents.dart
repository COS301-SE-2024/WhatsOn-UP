import 'package:flutter/material.dart';



class ManageEvents extends StatelessWidget {
  const ManageEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Manage Events',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 350,),
              Center(
                child: Text('Manage Events Page - Coming soon'),
              ),
            ]
        )
    );
  }
}
import 'package:flutter/material.dart';

class Event {
  final String nameOfEvent;
  final String dateAndTime;
  final String location;
  final String imageUrl;

  Event({
    required this.nameOfEvent,
    required this.dateAndTime,
    required this.location,
    required this.imageUrl,
  });
}

class EventCardE extends StatelessWidget {
  final Event event;

  EventCardE({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 200,
        height: 265,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow:[
           BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius:5,
            blurRadius:10,
            offset: Offset(0, 3),

           ),
           ],

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children:[
              SizedBox(height: 7.0),
              Container(
                
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(event.imageUrl,
                height: 120.0,
                width: double.infinity,
                fit: BoxFit.cover,),
                ),
              ),
                Text(
                event.nameOfEvent,
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                 
                ),
              ),
                SizedBox(height: 4.0),
               Text(
                event.dateAndTime,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                 
                ),
              ),
              SizedBox(height: 6.0),


               Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20.0,
                    color: Colors.grey,
                  ),

                  Expanded(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      size: 20.0,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  )
            ]
            )
             
          ],
          ),
        ),
      ),
    );
  }
}

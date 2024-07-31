import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/detailed_event_page.dart';
import '../providers/events_providers.dart';
import  'event_card.dart';


class EventCardM extends StatefulWidget {
  final Event event;

  const EventCardM({super.key, required this.event});

  @override
  _EventCardMState createState() => _EventCardMState();
}

class _EventCardMState extends State<EventCard> {


  @override
  Widget build(BuildContext context) {
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    final theme = Theme.of(context);
    final cardColour = theme.colorScheme.surface;
    final textColour = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailedEventPage(event: widget.event),
          ),
        );
      },
      child: Card(
        color: cardColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 200,
          height: 265,
          decoration: BoxDecoration(
            color: cardColour,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 4,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [

                Text(
                  widget.event.nameOfEvent,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: textColour,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: textColour,
                    ),
                    Expanded(
                      child: Text(
                        //modified here
                        widget.event.venue!.name,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: textColour,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

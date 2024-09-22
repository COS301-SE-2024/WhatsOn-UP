import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DirectionsModalSheet extends StatelessWidget {
  final List<String> directions;

  DirectionsModalSheet({required this.directions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Directions',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16.0),
          
          Expanded(
            child: ListView(
              children: directions.map((direction) {
                return Card(
                  child: ListTile(
                    leading: _selectIcon(direction), // Custom function to select an icon
                    title: Html(data: direction),
                  ),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Icon _selectIcon(String directionText){
    Icon selectedIcon;

    if(directionText.contains(RegExp('right|east'))){
      selectedIcon = const Icon(Icons.turn_right_outlined);
    }
    else if(directionText.contains(RegExp('left|west'))){
      selectedIcon = const Icon(Icons.turn_left_outlined);
    }
    else if(directionText.contains(RegExp('straight|forward|north'))){
      selectedIcon = const Icon(Icons.straight_outlined);
    }
    else if(directionText.contains(RegExp('northeast'))){
      selectedIcon = const Icon(Icons.north_east_outlined);
    }
    else if(directionText.contains(RegExp('northwest'))){
      selectedIcon = const Icon(Icons.north_west_outlined);
    }
    else if(directionText.contains(RegExp('southeast'))){
      selectedIcon = const Icon(Icons.south_east_outlined);
    }
    else if(directionText.contains(RegExp('southwest'))){
      selectedIcon = const Icon(Icons.south_west_outlined);
    }
    else if(directionText.contains(RegExp('roundabout'))){
      selectedIcon = const Icon(Icons.roundabout_right_rounded);
    }
    else{
      selectedIcon = const Icon(Icons.circle_outlined);
    }

    return selectedIcon;
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firstapp/models/Location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:firstapp/pages/explore_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceInformationModalSheet extends StatelessWidget {
  final Location location;
  final startTripCallback startTrip;

  PlaceInformationModalSheet({required this.location, required this.startTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           Text(
            location.displayName,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16.0),

          //Image(s)
          
          Expanded(
            child: 
              ListView(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width, // Full width of the screen
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0), // Adjust radius as needed
                      child: CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayAnimationDuration: Duration(seconds: 2)
                        ),
                        items: location.imageUrls.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                //Additional information
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0), // Space between label and address
                        Text(
                          location.formattedAddress,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                
                SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Row(children: [
                          Icon(Icons.directions),
                          Text('Start Navigation')
                        ],),
                        onPressed: () => {
                          startTrip(location.location)
                        },
                      ),
                      ElevatedButton(
                      child: const Row(children: [
                          Icon(Icons.share),
                          Text('Share')
                        ],),
                      onPressed: () => {},
                      ),
                      // ElevatedButton(
                      // child: const Row(children: [
                      //     Icon(Icons.keyboard_return_outlined),
                      //     Text('Close')
                      //   ],),
                      // onPressed: () => Navigator.pop(context),
                      // )
                    ],
                )
              ],
            )
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

typedef startTripCallback = void Function(LatLng destination);
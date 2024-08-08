// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:firstapp/models/Location.dart';
import 'package:firstapp/models/Route.dart';
import 'package:firstapp/services/RouteService.dart';
import 'package:firstapp/widgets/DirectionsBottomSheet.dart';
import 'package:firstapp/widgets/PlaceInfoBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firstapp/services/PlacesService.dart';
import 'package:location/location.dart' as LocationController;

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

// class _NavigationPageState extends State<NavigationPage> {
//   late MapBoxNavigation _directions;
//   late MapBoxOptions _options;
//   late MapBoxNavigationViewController _controller;

//   String _instruction = "";
//   bool _arrived = false;
//   bool _routeBuilt = false;
//   bool _isNavigating = false;
//   double _distanceRemaining = 0.0;
//   double _durationRemaining = 0.0;
//   bool _isMultipleStop = false;

//   @override
//   void initState() {
//     super.initState();
//     _directions = MapBoxNavigation();
//     _options = MapBoxOptions(
//       initialLatitude: 37.7749,
//       initialLongitude: -122.4194,
//       zoom: 15.0,
//       tilt: 0.0,
//       bearing: 0.0,
//       enableRefresh: false,
//       alternatives: true,
//       voiceInstructionsEnabled: true,
//       bannerInstructionsEnabled: true,
//       longPressDestinationEnabled: true,
//       mode: MapBoxNavigationMode.driving,
//       simulateRoute: false,
//       language: "en",
//       units: VoiceUnits.metric,
//     );

//     MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
//   }

//   Future<void> _onRouteEvent(e) async {
//     _distanceRemaining = await _directions.getDistanceRemaining() as double;
//     _durationRemaining = await _directions.getDurationRemaining() as double;

//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         _arrived = progressEvent.arrived as bool;
//         if (progressEvent.currentStepInstruction != null)
//           _instruction = progressEvent.currentStepInstruction as String;
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         _routeBuilt = true;
//         break;
//       case MapBoxEvent.route_build_failed:
//         _routeBuilt = false;
//         break;
//       case MapBoxEvent.navigation_running:
//         _isNavigating = true;
//         break;
//       case MapBoxEvent.on_arrival:
//         _arrived = true;
//         if (!_isMultipleStop) {
//           await Future.delayed(Duration(seconds: 3));
//           await _directions.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         _routeBuilt = false;
//         _isNavigating = false;
//         break;
//       default:
//         break;
//     }
//     setState(() {});
//   }

//   Future<void> startNavigation() async {
//     var wayPoints = <WayPoint>[];
//     wayPoints.add(WayPoint(name: "start", latitude: 37.7749, longitude: -122.4194));
//     wayPoints.add(WayPoint(name: "end", latitude: 37.7849, longitude: -122.4094));

//     await _directions.startNavigation(
//       wayPoints: wayPoints,
//       options: _options,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Navigation")),
//       body: Container(
//                 color: Colors.grey,
//                 child: MapBoxNavigationView(
//                     options: _options,
//                     onRouteEvent: _onRouteEvent,
//                     onCreated:
//                         (MapBoxNavigationViewController controller) async {
//                       _controller = controller;
//                     }),
//               ),
//     );
//   }
// }

class _NavigationPageState extends State<NavigationPage> {
  
  late GoogleMapController _googleMapController;
  // static const LatLng initPos = LatLng(-25.756283, 28.231191);
  LatLng? _currentLocation;
  Marker? _destination;
  LatLng? _currentDestination;
  MapRoute? _route;

  late BitmapDescriptor _customOriginIcon;
  late BitmapDescriptor _customDestinationIcon;

  // late CameraPosition _initialCameraPosition;

  final PlacesService places = PlacesService();
  final locationController = LocationController.Location();

  static const double farZoom = 17;
  static const double closeZoom = 18;

  double currentTilt = 0;
  double currentZoom = farZoom;
  

  bool locationFound = false;

  final _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    WidgetsBinding.instance
      .addPostFrameCallback((_) async {
        await _getLocationUpdates();
        print("Current LOCATION: $_currentLocation");
      });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _currentLocation == null 
          ? const Center(child: CircularProgressIndicator()) 
          : GoogleMap(
            initialCameraPosition:  CameraPosition(
              target: _currentLocation!,
              zoom: farZoom,
            ),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              Marker(
                markerId: const MarkerId("currentPosition"),
                icon: _customOriginIcon,
                position: _currentLocation!
              ),
              if (_destination != null) _destination as Marker
            },
            polylines: {
              if (_route != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _route!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _updateRoute,
          ),
          Positioned(
            top: 35,
            left: 15,
            right: 15,
            child: SearchBar(
              hintText: "Search",
              controller: _textFieldController,
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 15),
              ),
              leading: const Icon(Icons.search),
              trailing: const [Icon(Icons.mic)],
              onSubmitted: _searchPlaces,
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition( CameraPosition(
                  target: _currentLocation!,
                  zoom: farZoom,
                )),
              ),
              child: const Icon(Icons.center_focus_strong)
            ),
            
            const SizedBox(height: 16.0), // Space between buttons

            if (_route != null) FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => _showDirections(context,_route!.stepInstructions),
              child: const Icon(Icons.directions),
            ),
          ],
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
    );
  }

  void _setDestination(LatLng _position) {
    setState(() {
        _destination = Marker(
          markerId: const MarkerId("destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: _position
        );
      });
  }

  Future<void> _updateRoute(LatLng _destinationLocation) async {
    _setDestination(_destinationLocation);
    
    final updatedRoute = await RouteService().getRoute(origin: _currentLocation!, destination: _destinationLocation);
    setState(() {
      _route = updatedRoute;
    });
    print('\n ${updatedRoute}');
  }

  Future<void>_getLocationUpdates() async {
    try{
      bool locationServiceEnabled = await locationController.serviceEnabled();
      if (!locationServiceEnabled) {
        locationServiceEnabled = await locationController.requestService();
        if (!locationServiceEnabled) {
          throw Exception("Location service is not enabled");
        }
      }

      LocationController.PermissionStatus permissionStatus = await locationController.hasPermission();
      if (permissionStatus == LocationController.PermissionStatus.denied) {
        permissionStatus = await locationController.requestPermission();
        if (permissionStatus != LocationController.PermissionStatus.granted) {
          throw Exception("Location permission has not been granted");
        }
      }

      locationController.onLocationChanged.listen((currentLocation) async {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        if (mounted) { // Check if the widget is still mounted
          if(_currentDestination != null && _route != null){
            await _updateRoute(_currentDestination!);
            print("CALLED");
          };
        setState((){
          _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (!locationFound) {
            _cameraToPosition(_currentLocation);
          }
        });
      }
      }
    });
    }
    catch(e){
      print(e);
      rethrow;
    }
  }

  void _loadCustomIcons() async {
    _customOriginIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    // _customIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: Size(512,512)), 'assets/images/target.png');
    // print(_customIcon.toJson());

    // _origin = Marker(
    //   markerId: const MarkerId("origin"),
    //   icon: _customIcon,
    //   position: initPos
    // );
  }

  ////////////////////////////////////////////////Searchbar logic///////////////////////////////////////////////

  void _searchPlaces(String query) async {
    List<Location> foundLocations = await places.findLocationFromQuery(query: query);

    if(foundLocations.isEmpty){
      print("location not found"); //alter to be a popup
    }
    else{
      print("LOCATION: ${foundLocations[0].location}");

      if (_route != null){
        _route = null;
      }
      
      //Choose closest matching location
      Location foundLocation = foundLocations[0];

      //change the camera angle
      setState(() {
        currentTilt = 0;
        currentZoom = farZoom;
      });

      //locate place
      _setDestination(foundLocation.location);
      _cameraToPosition(foundLocation.location);
      _showPlaceInfo(context, foundLocation);
    }
  }

  Future<void> _cameraToPosition(LatLng? pos) async{
    if(pos == null) return;
    CameraPosition newCamPosition = CameraPosition(target: LatLng(pos.latitude,pos.longitude), zoom: currentZoom, tilt: currentTilt);
    await _googleMapController.animateCamera(CameraUpdate.newCameraPosition(newCamPosition));
  }

///////////////////////////////////////Directions//////////////////////////////////////////////////

   void _showDirections(BuildContext context, List<String> directions) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return DirectionsModalSheet(directions: directions);
        },
      );
    }

////////////////
   void _showPlaceInfo(BuildContext context, Location location) {
      locationFound = true;
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return PlaceInformationModalSheet(
            location: location,
            startTrip: (LatLng dest){
              Navigator.of(context).pop();
              _updateRoute(dest);
              setState(() {
                _currentDestination = LatLng(dest.latitude,dest.longitude);
                currentZoom = closeZoom;
                currentTilt = 40;
                locationFound = false;
              });
              _cameraToPosition(_currentLocation);
            }
          );
        },
      );
    }
}
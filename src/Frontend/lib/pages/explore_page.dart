import 'package:firstapp/models/Route.dart';
import 'package:firstapp/services/RouteService.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  static const LatLng initPos = LatLng(-25.756283, 28.231191);
  Marker? _destination;
  MapRoute? _route;
  late BitmapDescriptor _customIcon;

  final Marker _origin = Marker(
      markerId: const MarkerId("origin"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: initPos
    );

  

  static const _initialCameraPosition = CameraPosition(
    target: initPos,
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin as Marker,
          if (_destination != null) _destination as Marker
        },
        polylines:{
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
        onLongPress: _setDestination,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
    );
  }

  void _setDestination(LatLng _position) async {
    setState(() {
        _destination = Marker(
          markerId: const MarkerId("destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: _position
        );
      });
    
    final updatedRoute = await RouteService().getRoute(origin: _origin!.position, destination: _position);
    setState(() {
      _route = updatedRoute;
    });
    print('\n ${updatedRoute}');
  }

  void _loadCustomIcons() async {
    // _customIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: Size(512,512)), 'assets/images/target.png');
    // print(_customIcon.toJson());

    // _origin = Marker(
    //   markerId: const MarkerId("origin"),
    //   icon: _customIcon,
    //   position: initPos
    // );
  }

}
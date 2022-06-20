import 'dart:convert';
import 'dart:math';

import 'package:bike_nav/main.dart';
import 'package:bike_nav/own/search_bar_ui.dart';
import 'package:bike_nav/screens/review_ride.dart';
import 'package:bike_nav/widgets/marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/helpers/shared_prefs.dart';

import '../helpers/commons.dart';
import '../widgets/review_ride_bottom_sheet.dart';

class ReviewDestination extends StatefulWidget {
  const ReviewDestination({Key? key})
      : super(key: key);

  @override
  State<ReviewDestination> createState() => _ReviewDestinationState();
}

class _ReviewDestinationState extends State<ReviewDestination> {
  // Mapbox Maps SDK related
  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;

  List<Marker> _markers = [];
  List<MarkerState> _markerStates = [];
    late MapboxMapController _mapController;
  

  final Random _rnd =  Random();
  late String destination;
  late LatLng destinationLatLng;
  @override
  void initState() {
    
    // initialise initialCameraPosition, address and trip end points
    _initialCameraPosition = CameraPosition(target: getTripLatLngFromSharedPrefs('destination'), zoom: 15);

    // initialize destination
    destination = sharedPreferences.getString("destination")!;
    destinationLatLng = getTripLatLngFromSharedPrefs('destination');

    super.initState();
  }

  _handleStart() async {
    sharedPreferences.setString('source', getCurrentJSONAddressFromSharedPrefs());

    LatLng sourceLatLng = getCurrentLatLngFromSharedPrefs();
    LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
    Map modifiedResponse = await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReviewRide(modifiedResponse: modifiedResponse,)));
  
  }



  _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    controller.addListener(() {
      if (controller.isCameraMoving) {
        _updateMarkerPosition();
      }
    });
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        _markerStates[i].updatePosition(points[i]);
      });
    });
  }

  _onCameraIdleCallback() {
    _updateMarkerPosition();
  }



  void _addMarkerStates(MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void addMarker(Point<double> point, LatLng coordinates) {
    setState(() {
      _markers.add(Marker(_rnd.nextInt(100000).toString(), coordinates, point,
          _addMarkerStates));
    });
  }

  

  _onStyleLoadedCallback() async {
    LatLng destination = getTripLatLngFromSharedPrefs("destination");

    _mapController.toScreenLocation(destination).then((value){

      Point<double> point = Point(value.x as double, value.y as double);
      addMarker(point, destination );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
            MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              trackCameraPosition: true,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onCameraIdle: _onCameraIdleCallback,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            ),
            
          IgnorePointer(
            ignoring: true,
            child: Stack(
              children: _markers,
            )),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child:Card(
              elevation: 3.0,
              child: Column(
                children: [
                  ListTile(
                    title: Text(json.decode(destination)["name"]),
                    subtitle:Text(json.decode(destination)["address"]) ,
                    trailing: IconButton(onPressed: (){}, icon:Icon(Icons.bookmark_outline)), 
                  ),
                  ButtonBar(
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                          ),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)){
                              return Colors.blue.shade800;
                            }
                            return Colors.blue.shade700;
                          }    
                          ),

                        ),
                        onPressed: (){
                          _handleStart();
                        }, 
                        icon: const Icon(Icons.fork_left),
                        label: const Text("Find Route")
                      )
                    ],
                  )
                ],
              ),
            ),
          ),),
          
          SearchBarUI(),
        ]
      )
    )
    ;
  }
}

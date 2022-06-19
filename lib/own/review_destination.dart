import 'dart:convert';

import 'package:bike_nav/main.dart';
import 'package:bike_nav/own/search_bar_ui.dart';
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

  
  late String destination;
  late LatLng destinationLatLng;
  @override
  void initState() {
    
    // initialise initialCameraPosition, address and trip end points
    _initialCameraPosition = CameraPosition(target: getTripLatLngFromSharedPrefs('destination'), zoom: 12);

    // initialize destination
    destination = sharedPreferences.getString("destination")!;
    destinationLatLng = getTripLatLngFromSharedPrefs('destination');

    super.initState();
  }


  _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  _onStyleLoadedCallback() async {
    
  }

  _addSourceAndLineLayer() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
              accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
              trackCameraPosition: true,
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            ),
          ),
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
                    trailing: const Icon(Icons.bookmark_outline)
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
                          
                        }, 
                        icon: const Icon(Icons.navigation),
                        label: const Text("Start Navigation")
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

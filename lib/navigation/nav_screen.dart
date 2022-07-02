import 'package:bike_nav/helpers/handle_route_progress.dart';
import 'package:bike_nav/navigation/easy_nav.dart';
import 'package:bike_nav/navigation/nav_bottom_card.dart';
import 'package:bike_nav/navigation/nav_top_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/helpers/shared_prefs.dart';

import '../helpers/commons.dart';
import '../widgets/review_ride_bottom_sheet.dart';

class NavScreen extends StatefulWidget {
  final Map modifiedResponse;
  const NavScreen({Key? key, required this.modifiedResponse})
      : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {

  // view related
  bool easyNavToggled = false;

  // Mapbox Maps SDK related
  final List<CameraPosition> _kTripEndPoints = [];
  late MapboxMapController controller;
  late CameraPosition _initialCameraPosition;
  bool _myLocationEnabled = false;

  // Directions API response related
  late Map geometry;
  late NavigationController navController; 

  @override
  void initState() {
    // initialise distance, dropOffTime, geometry
    _initialiseNavController();

    // initialise initialCameraPosition, address and trip end points
    _initialCameraPosition = CameraPosition(target: getCurrentLatLngFromSharedPrefs(), zoom: 16);

    for (String type in ['source', 'destination']) {
      _kTripEndPoints
          .add(CameraPosition(target: getTripLatLngFromSharedPrefs(type)));
    }
    super.initState();
  }

    updateInstructions(){
    setState(() {
    });
  }


  _initialiseNavController() {
    navController = NavigationController(
      latestStep: 0,
      nextStep: 1,
      userLocation: getCurrentLatLngFromSharedPrefs(),
      steps: widget.modifiedResponse['steps'],
      timeDist: {
        "distance" : widget.modifiedResponse['distance'],
        "duration" : widget.modifiedResponse['duration'],
      }, 
      updateInstructions: updateInstructions
    );
    
    geometry = widget.modifiedResponse['geometry'];
  }


  _onMapCreated(MapboxMapController controller) async {
    
    this.controller = controller;
    setState(() {
      _myLocationEnabled = true;
    });
  
  }


  _onStyleLoadedCallback() async {
    for (int i = 0; i < _kTripEndPoints.length; i++) {
      String iconImage = i == 0 ? 'circle' : 'square';
      await controller.addSymbol(
        SymbolOptions(
          geometry: _kTripEndPoints[i].target,
          iconSize: 0.1,
          iconImage: "assets/icon/$iconImage.png",
        ),
      );
    }
    _addSourceAndLineLayer();
  }


  _onUserLocationUpdate(UserLocation userLocation){

    print("UserLocation PRE: bearing: ${userLocation.bearing} location: ${userLocation.position}");
    print("CameraPosition PRE: ${controller.cameraPosition}");
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation.position, 
          bearing: userLocation.bearing ?? controller.cameraPosition?.bearing ?? 0.0,
          zoom: controller.cameraPosition?.zoom ?? 16,
        ))
    );
    
    navController.handleRouteProgress(userLocation.position, controller);
    print("UserLocation POST: bearing: ${userLocation.bearing} location: ${userLocation.position}");
    print("CameraPosition POST: ${controller.cameraPosition}");
  }

  _addSourceAndLineLayer() async {
    // Create a polyLine between source and destination
    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Add new source and lineLayer
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.indigo.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: easyNavToggled ? const Text('Standard Map') : const Text('Bike Map'),
        icon: easyNavToggled ? const Icon(Icons.map) : const Icon(Icons.directions_bike),
        
        onPressed: (() {
          setState(() {
            easyNavToggled = !easyNavToggled;
          });
        }),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: MapboxMap(
                accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: _myLocationEnabled,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                onUserLocationUpdated: _onUserLocationUpdate,
                trackCameraPosition: true,
              ),
            ),
            if (easyNavToggled ) EasyNav(step: navController.latestStep),

            
            NavTopCard(
              bannerInstructions: navController.getBannerInstruction(), 
              distanceToNextStep: navController.userDistanceToNextStep
            ),
            NavBottomCard( timeDist: navController.timeDist),
          ],
        ),
      ),
    );
  }
}

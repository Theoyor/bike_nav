import 'package:bike_nav/own/search_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:bike_nav/helpers/shared_prefs.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late String currentAddress;
  late CameraPosition _initialCameraPosition;


  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
    currentAddress = getCurrentAddressFromSharedPrefs();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MapboxMap(
          accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: true,
          styleString: "mapbox://styles/mapbox/streets-v11",
        ),
        SearchBarUI(),
      ],
    );
  }
}

import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as ltlg;
import 'package:mapbox_gl/mapbox_gl.dart';



void handleRouteProgress(UserLocation userLocation, MapboxMapController controller){

}


bool onTrack(UserLocation userLocation, Map<dynamic, dynamic> geometry, LatLng latestPoint, LatLng nextPoint ){
  
  return true;
}


class NavigationController {
  Map<dynamic,dynamic> route;
  UserLocation userLocation;
  int latestStep; 
  int nextStep;
  //int _timer = 

  NavigationController({
    required this.route, 
    required this.userLocation, 
    required this.latestStep, 
    required this.nextStep, 
  });

  void handleRouteProgress(UserLocation userLocation, MapboxMapController controller) async{
  ltlg.Distance distance = const ltlg.Distance();

    ltlg.LatLng latestStepLatLng = ltlg.LatLng(
      route["legs"][0]["steps"][latestStep]["maneuver"]["location"][0],
      route["legs"][0]["steps"][latestStep]["maneuver"]["location"][1],
    );
    ltlg.LatLng nextStepLatLng = ltlg.LatLng(
      route["legs"][0]["steps"][nextStep]["maneuver"]["location"][0],
      route["legs"][0]["steps"][nextStep]["maneuver"]["location"][1],
    );

    // evtl -5 zu ungenau, gerade in engen Ecken!
    if (distance(latestStepLatLng, nextStepLatLng) <= (_getDistFromUserLocation(latestStepLatLng) - 5)){

      //TODO onStepChange() bzw. update Instruction 

      latestStep = nextStep;

      // later on search for the closest next step
      nextStep = nextStep +1;
    }

    num userDistanceToNextStep = _getDistFromUserLocation(nextStepLatLng);
    double userSpeed = userLocation.speed ?? 0.0;

    // TODO allow only once a minute
    Map timeDist = await getRemainingTimeDistanceAPIResponse(userLocation.position, LatLng(nextStepLatLng.latitude, nextStepLatLng.longitude));

    //TODO update numerical parts of UI
    
  }




  bool onTrack(UserLocation userLocation, Map<dynamic, dynamic> geometry){
  return true;
  }

  num _getDistFromUserLocation(ltlg.LatLng location){
    ltlg.Distance distance = const ltlg.Distance();
    return distance(ltlg.LatLng(userLocation.position.latitude, userLocation.position.longitude), location);
  }

}

import 'dart:async';

import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/helpers/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as ltlg;
import 'package:mapbox_gl/mapbox_gl.dart';



void handleRouteProgress(LatLng userLocation, MapboxMapController controller){

}


bool onTrack(LatLng userLocation, Map<dynamic, dynamic> geometry, LatLng latestPoint, LatLng nextPoint ){
  
  return true;
}


class NavigationController {
  List<dynamic> steps;
  LatLng userLocation;
  int latestStep; 
  int nextStep;
  Map timeDist;
  bool allowCalls = true; 
  late Timer allowCallsTimer;
  late int  userDistanceToNextStep;
  final VoidCallback updateInstructions;

  NavigationController({
    required this.steps, 
    required this.userLocation, 
    required this.latestStep, 
    required this.nextStep,
    required this.timeDist,
    required this.updateInstructions,
  }){
    print(steps);
     userDistanceToNextStep = _getDistFromUserLocation(
      ltlg.LatLng(
        steps[nextStep]["maneuver"]["location"][1],
        steps[nextStep]["maneuver"]["location"][0],
      )
    ).round();

    allowCallsTimer = Timer.periodic(
    const Duration(seconds: 30), 
    (timer) { 
      if(!allowCalls){ allowCalls = true;}
    });
  }

  


  void handleRouteProgress(LatLng userLocation, MapboxMapController controller) async{
    this.userLocation = userLocation;
    ltlg.Distance distance = const ltlg.Distance();

    ltlg.LatLng latestStepLatLng = ltlg.LatLng(
      steps[latestStep]["maneuver"]["location"][1],
      steps[latestStep]["maneuver"]["location"][0],
    );
    ltlg.LatLng nextStepLatLng = ltlg.LatLng(
      steps[nextStep]["maneuver"]["location"][1],
      steps[nextStep]["maneuver"]["location"][0],
    );


    print("NEXTSTEP: $nextStep, LATESTSTEP: $latestStep ");
    print("distance(latestStepLatLng, nextStepLatLng) = ${distance(latestStepLatLng, nextStepLatLng)}\n_getDistFromUserLocation(latestStepLatLng) = ${_getDistFromUserLocation(latestStepLatLng)}");
    // evtl -5 zu ungenau, gerade in engen Ecken!
    if (distance(latestStepLatLng, nextStepLatLng) <= (_getDistFromUserLocation(latestStepLatLng) + 5)){

      latestStep = nextStep;
      // later on search for the closest next step
      nextStep = nextStep +1;

      updateInstructions();

    }

    userDistanceToNextStep = _getDistFromUserLocation(nextStepLatLng).round();

    if (allowCalls){
      timeDist = await getRemainingTimeDistanceAPIResponse(userLocation, getTripLatLngFromSharedPrefs("destination"));
      updateInstructions();
      allowCalls = false;
    }
    
  }

  bool onTrack(UserLocation userLocation, Map<dynamic, dynamic> geometry){
  return true;
  }

  Map<dynamic, dynamic> getBannerInstruction(){
    return steps[latestStep]["bannerInstructions"][0];
  }


  num _getDistFromUserLocation(ltlg.LatLng location){
    ltlg.Distance distance = const ltlg.Distance();
    return distance(ltlg.LatLng(userLocation.latitude, userLocation.longitude), location);
  }

}

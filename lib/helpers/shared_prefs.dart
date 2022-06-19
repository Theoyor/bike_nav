import 'dart:convert';

import 'package:mapbox_gl/mapbox_gl.dart';

import '../main.dart';

LatLng getCurrentLatLngFromSharedPrefs() {
  
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

String getCurrentAddressFromSharedPrefs() {
  return sharedPreferences.getString('current-address')!;
}

String getCurrentJSONAddressFromSharedPrefs(){
  return sharedPreferences.getString('unformatted-current-address')!;
}

LatLng getTripLatLngFromSharedPrefs(String type) {

   if (type == 'source') {
    List sourceLocationList = json.decode(sharedPreferences.getString('source')!)['location'];
    LatLng source = LatLng(sourceLocationList[0], sourceLocationList[1]);
    return source;
  } else {
    List destinationLocationList = json.decode(sharedPreferences.getString('destination')!)['location'];
    LatLng destination = LatLng(destinationLocationList[0], destinationLocationList[1]);
    return destination;
  }
 
}

String getSourceAndDestinationPlaceText(String type) {
  
  
  if (type == 'source') {
    String sourceAddress =
      json.decode(sharedPreferences.getString('source')!)['name'];
    return sourceAddress;
  } else {
    String destinationAddress =
      json.decode(sharedPreferences.getString('destination')!)['name'];
    return destinationAddress;
  }
}

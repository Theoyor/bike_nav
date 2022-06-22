import 'dart:convert';
import 'dart:ffi';

import 'package:mapbox_gl/mapbox_gl.dart';

import '../requests/mapbox_directions.dart';
import '../requests/mapbox_rev_geocoding.dart';
import '../requests/mapbox_search.dart';

// ----------------------------- Mapbox Search Query -----------------------------
String getValidatedQueryFromQuery(String query) {
  // Remove whitespaces
  String validatedQuery = query.replaceAll(" ", "%20");
  return validatedQuery;
}

Future<List> getParsedResponseForQuery(String value) async {
  List parsedResponses = [];

  // If empty query send blank response
  //String query = getValidatedQueryFromQuery(value);
  //if (query == '') return parsedResponses;

  // Else search and then send response
  final response =  Map<String, dynamic>.from(await getSearchResultsFromQueryUsingMapbox(value));
  List features = response['features'];
  for (var feature in features) {
    List address = feature['place_name'].split(RegExp(', '));
    Map response = {
      'name': address[0],
      'address': address.sublist(1).join(", "),
      'place': feature['place_name'],
      'location': LatLng(feature['center'][1], feature['center'][0])
    };
    parsedResponses.add(response);
  }
  return parsedResponses;
}

// ----------------------------- Mapbox Reverse Geocoding -----------------------------
Future<Map> getParsedReverseGeocoding(LatLng latLng) async {
final response =  Map<String, dynamic>.from(await getReverseGeocodingGivenLatLngUsingMapbox(latLng));

  Map feature = response['features'][0];
  List address = feature['place_name'].split(RegExp(', '));

  Map revGeocode = {
    'name': address[0],
    'address': address.sublist(1).join(", "),
    'place': feature['place_name'],
    'location': latLng
  };
  return revGeocode;
}

// ----------------------------- Mapbox Directions API -----------------------------
Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response = await getCyclingRouteUsingMapbox(sourceLatLng, destinationLatLng);
  
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

LatLng getCenterCoordinatesForPolyline(Map geometry) {
  List coordinates = geometry['coordinates'];
  int pos = (coordinates.length / 2).round();
  return LatLng(coordinates[pos][1], coordinates[pos][0]);
}

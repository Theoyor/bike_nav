import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/navigation/nav_screen.dart';
import 'package:bike_nav/own/custom_bottom_sheet.dart';
import 'package:bike_nav/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/shared_prefs.dart';




class ReviewRideBottomSheet extends StatelessWidget{

  final String distance;
  final String dropOffTime;

  ReviewRideBottomSheet({Key? key, required this.distance,required this.dropOffTime}) : super(key: key);
  
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

  _handleStartButtonPressed(BuildContext context) async {

    LatLng sourceLatLng = getCurrentLatLngFromSharedPrefs();
    LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
    Map modifiedResponse = await getNavDirectionsAPIResponse(sourceLatLng, destinationLatLng);
    //if (!mounted) return;

    Navigator.push(context,MaterialPageRoute(builder: (_) => NavScreen(modifiedResponse: modifiedResponse,))); 
  }


  @override
  Widget build(BuildContext context){
    return Positioned(
    bottom: 0,
    child: CustomBottomSheet(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('$sourceAddress ➡ $destinationAddress'),
                  subtitle: Text('$distance km, $dropOffTime drop off'),
                ),

                ButtonBar(
                  children: [
                    RoundedButton(
                      borderRadius: 18.0, 
                      onPressed: (){_handleStartButtonPressed(context);},
                      icon: const Icon(Icons.navigation), 
                      label: const Text("Start Navigation")
                    )
                    ],
                ),
              ]),
        ),
      );
   
  }
}


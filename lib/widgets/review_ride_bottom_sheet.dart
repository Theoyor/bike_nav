import 'package:bike_nav/own/custom_bottom_sheet.dart';
import 'package:bike_nav/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../helpers/shared_prefs.dart';
import '../screens/turn_by_turn.dart';



class ReviewRideBottomSheet extends StatelessWidget{

  final String distance;
  final String dropOffTime;

  ReviewRideBottomSheet({Key? key, required this.distance,required this.dropOffTime}) : super(key: key);
  
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

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
                      onPressed:
                        () => Navigator.push(context,MaterialPageRoute(builder: (_) => const TurnByTurn())), 
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


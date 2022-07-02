import 'package:bike_nav/helpers/commons.dart';
import 'package:bike_nav/helpers/display_distance.dart';
import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/main.dart';
import 'package:bike_nav/navigation/nav_screen.dart';
import 'package:bike_nav/own/custom_bottom_sheet.dart';
import 'package:bike_nav/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/shared_prefs.dart';




class NavTopCard extends StatelessWidget{

  final Map<dynamic,dynamic> bannerInstructions;
  final int distanceToNextStep;
  NavTopCard({Key? key, required this.bannerInstructions, required this.distanceToNextStep}) : super(key: key);
  

  @override
  Widget build(BuildContext context){
    return Positioned(
    top: 0,
    child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(183, 160, 160, 160),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 2.0), 
              )
            ],
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width / 4,
                  child: getFittingDirectionSymbol(
                    bannerInstructions["primary"]["type"], 
                    bannerInstructions["primary"]["modifier"]
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListTile(
                    title: Text('${bannerInstructions["primary"]["text"]} in ${displayDistance(distanceToNextStep)}'),
                  ),
                )
                
                
              ]),
        ),
      );
   
  }
}

Widget getFittingDirectionSymbol(String type, String modifier){
  // normally Return an Icon or Image
  return Text("$type\n$modifier");

}


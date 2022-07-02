import 'package:bike_nav/helpers/commons.dart';
import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/main.dart';
import 'package:bike_nav/navigation/nav_screen.dart';
import 'package:bike_nav/own/custom_bottom_sheet.dart';
import 'package:bike_nav/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../helpers/shared_prefs.dart';




class NavBottomCard extends StatelessWidget{

  final Map<dynamic,dynamic> timeDist;
  late DateTime arrivalTime;
  NavBottomCard({Key? key, required this.timeDist}) : super(key: key){
    arrivalTime = DateTime.now().add(Duration(minutes: (timeDist["duration"]).round()));
  }
  
    _handleStopButtonPressed(BuildContext context) async { 
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Frame(),
        ),
        (route) => false,
      );
    }


  @override
  Widget build(BuildContext context){
    return Positioned(
    bottom: 0,
    child: CustomBottomSheet(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('${timeDist["duration"]} min, (${timeDist["distance"]} m)'),
                  subtitle: Text('Arrival at ${getDropOffTime(timeDist["duration"])}'),
                  trailing: IconButton(onPressed: (){_handleStopButtonPressed(context);}, icon: const Icon(Icons.clear)) ,
                ),
              ]),
        ),
      );
   
  }
}


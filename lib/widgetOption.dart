import 'package:bike_nav/main.dart';
import 'package:bike_nav/savedList.dart';
import 'package:bike_nav/searchBarUi.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import "package:material_floating_search_bar/material_floating_search_bar.dart";

class WidgetOption extends StatelessWidget{
  WidgetOption(this.index);
  final int index;


    

  

  @override
  Widget build(BuildContext context) {
    if (index ==0 ){
          return Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            imageProvider: AssetImage("assets/map(2).png"),
            initialScale: 2.0,
          ), 
          SearchBarUI(),
        ],
      );

    }else if(index == 1){
      return SavedList();
    }else{
      return const Center(
       child:  Text("index out of bounds")
      );
    }
  }

  
}
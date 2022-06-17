import 'package:bike_nav/own/saved_list.dart';
import 'package:bike_nav/own/search_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class WidgetOption extends StatelessWidget{
  
  final int index;

  WidgetOption({Key? key, required this.index}) : super(key: key);
  

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
      throw IndexError(index, 1);
    }
  }

  
}
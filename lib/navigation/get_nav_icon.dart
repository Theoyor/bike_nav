import 'dart:math';

import 'package:flutter/material.dart';

enum Transformvariant{
  rotate,
  flipX,
  flipY,
}

Widget getFittingDirectionSymbol(String type, String modifier){
  IconData chosen =  Icons.question_mark;
  int degree = 0;
  Transformvariant transformvariant = Transformvariant.rotate;

  switch (type) {
    case "turn":
      switch (modifier){
        case "right":
          chosen = Icons.turn_right;
          break;
        case "slight right":
          chosen = Icons.turn_slight_right;
          break;
        case "sharp right":
          chosen = Icons.turn_right;
          break;
        case "left":
          chosen = Icons.turn_left;
          break;
        case "slight left":
          chosen = Icons.turn_slight_left;
          break;
        case "sharp left":
          chosen = Icons.turn_left;
          break;
        
        default:
          chosen =  Icons.question_mark;
          break;
      }
      
      break;
    case "merge":
      if (modifier.contains("right")){
        chosen = Icons.call_merge;
      }else if (modifier.contains("left")){
        chosen = Icons.call_merge;
        transformvariant = Transformvariant.flipY;
      }else{
        chosen = Icons.merge;
      }
      break;
    case "depart":
      if (modifier.contains("right")){
        chosen = Icons.start;
      }else if (modifier.contains("left")){
        chosen = Icons.start;
        transformvariant = Transformvariant.flipY;
      }else{
        chosen = Icons.start;
        transformvariant = Transformvariant.rotate;
        degree = 270;
      }
      break;
    case "arrive":
      chosen = Icons.beenhere;
      break;
    case "fork":
      if (modifier.contains("right")){
        chosen = Icons.fork_right;
      }else if (modifier.contains("left")){
        chosen = Icons.fork_left;
      }else{
        chosen = Icons.question_mark;
      }
      break;
    case "off ramp":
      if (modifier.contains("right")){
        chosen = Icons.fork_right;
      }else if (modifier.contains("left")){
        chosen = Icons.fork_left;
      }else{
        chosen = Icons.question_mark;
      }
      break;
    case "roundabout":
      chosen = Icons.roundabout_left;
      break;
    default:
      chosen = Icons.question_mark;
      break;
      
  }

  return 
   CustomTransform(
    variant: transformvariant,
    degree: degree,
    child: Icon(
      chosen,
      color: Colors.black,
      size: 50,
    ),
  );

}


class CustomTransform extends StatelessWidget{

  Transformvariant variant;
  Widget child;
  int degree;
  CustomTransform({Key? key, required this.variant, required this.child, this.degree = 0}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if (variant == Transformvariant.rotate){
      return Transform.rotate(
        angle: degree * pi / degree,
        child: child,
      );
    }else if (variant == Transformvariant.flipX){
      return Transform(
        transform: Matrix4.rotationY(pi),
        child: child,
      );
    }else{
      return Transform(
        transform: Matrix4.rotationX(pi),
        child: child,
      );
    }
  }
}


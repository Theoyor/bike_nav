import 'package:bike_nav/helpers/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget{

  final Color color;
  final Color onPressedColor;
  final double borderRadius;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final Icon icon;
  final Widget label;

  RoundedButton({
    Key? key, 
    this.color = ColorConstants.blue700, 
    this.onPressedColor = ColorConstants.blue800,
    this.foregroundColor = ColorConstants.white,
    required this.borderRadius,
    required this.onPressed,
    required this.icon,
    required this.label
    }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )
        ),
        foregroundColor: MaterialStateProperty.all(foregroundColor),
        backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)){
            return onPressedColor;
          }
          return color;
        }    
        ),

      ),
      onPressed: onPressed, 
      icon: icon,
      label: label,
    );
  }

}
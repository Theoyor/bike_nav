import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget{

  final double height;
  final double width;
  final Widget child;
  const CustomBottomSheet({Key? key, required this.height,required this.width, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return 
      Container(
        height: height,
        width:width,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(183, 160, 160, 160),
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, -2.0), // shadow direction: bottom right
            )
        ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: child
    );
            
  }
} 
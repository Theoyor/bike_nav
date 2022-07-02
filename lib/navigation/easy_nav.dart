import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class EasyNav extends StatelessWidget{
  final int step;  

  EasyNav({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.125,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: AssetImage("assets/generated/$step.png")
            ),
          )    
        ),
      ],
    );
    
    
    
  }

}
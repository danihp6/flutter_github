import 'package:flutter/material.dart';

class WheelElement extends StatelessWidget {
  WheelElement(this.color,this.world);
  Color color;
  int world;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
      child: Container(
        color: color,
        child: Center(child: Text('Level $world',style: TextStyle(fontSize: 30),)),
        ),
      );
  }
}

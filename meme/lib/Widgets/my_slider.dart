import 'package:flutter/material.dart';

class HotBar extends StatefulWidget {
  double left;
  double right;
  Color barColor;
  double height;
  HotBar(
      {this.left = 8,
      this.right = 8,
      this.barColor = Colors.red,
      this.height = 4});

  @override
  _HotBarState createState() => _HotBarState();
}

class _HotBarState extends State<HotBar> {
  double initial = 0;
  double distance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:widget.left,right:widget.right),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: widget.barColor.withOpacity(0.5),
            ),
            height: widget.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Draggable(
                axis: Axis.horizontal,
                feedback: Icon(Icons.whatshot),
                child: Icon(Icons.whatshot),
              ),
              DragTarget(
                builder: (context, candidateData, rejectedData) => Container(
                  height: 10,
                  width: 10,
                  color:Colors.blue
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

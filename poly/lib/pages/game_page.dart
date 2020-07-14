import 'dart:ui';

import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Draw draw;
  Draw rect;
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.red;

  @override
  void initState() {
    draw = Draw(Paint()
      ..strokeCap = strokeType
      ..isAntiAlias = true
      ..color = selectedColor.withOpacity(opacity)
      ..strokeWidth = strokeWidth);
    rect = Draw(Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.yellow
      ..strokeWidth = 3.0);
    rect.points = [
      Offset(100, 100),
      Offset(100, 200),
      Offset(200, 200),
      Offset(200, 100),
      Offset(100, 100)
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: CustomPaint(
          size: Size.infinite,
          painter: Painter(draw: draw, rect: rect),
        ),
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            draw.addPoint(renderBox.globalToLocal(details.globalPosition));
          });
        },
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            draw.addPoint(renderBox.globalToLocal(details.globalPosition));
          });
        },
        onPanEnd: (details) {
          draw.close();
          setState(() {});
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              draw.clear();
            });
          });
        },
      ),
    );
  }
}

class Painter extends CustomPainter {
  Draw draw;
  Draw rect;
  Painter({@required this.draw, this.rect});
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(PointMode.polygon, rect.points, rect.paint);
    for (int i = 0; i < draw.points.length - 1; i++) {
      if (draw.points[i] != null && draw.points[i + 1] != null) {
        //Drawing line when two consecutive points are available
        canvas.drawLine(draw.points[i], draw.points[i + 1], draw.paint);
      } else if (draw.points[i] != null && draw.points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(draw.points[i]);
        offsetPoints
            .add(Offset(draw.points[i].dx + 0.1, draw.points[i].dy + 0.1));

        //Draw points when two points are not next to each other
        canvas.drawPoints(PointMode.points, offsetPoints, draw.paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Draw {
  Paint _paint;
  List<Offset> _points;

  Draw(paint) {
    _paint = paint;
    _points = List();
  }

  List<Offset> get points => this._points;

  set points(points) => _points = points;

  get paint => this._paint;

  addPoint(Offset offset) => _points.add(offset);

  close() => _points.add(_points.first);

  clear() => _points.clear();
}

class Line{
  Offset _point1;
  Offset _point2;

  Line(point1,point2){
    _point1 = point1;
    _point2 = point2;
  }

  
}
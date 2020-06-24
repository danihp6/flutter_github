import 'dart:async';

import 'package:flutter/material.dart';

class FadingDismissible extends StatefulWidget {
  Widget child;
  Function confirmDismiss;
  Function onDismissed;
  DismissDirection direction;
  Key key;
  FadingDismissible(
      {@required this.key,
      @required this.child,
      this.confirmDismiss,
      this.onDismissed,
      this.direction = DismissDirection.horizontal});

  @override
  _FadingDismissibleState createState() => _FadingDismissibleState();
}

class _FadingDismissibleState extends State<FadingDismissible> {
  double opacity = 1.0;
  StreamController<double> controller = StreamController<double>();
  Stream stream;
  double startPosition;

  @override
  void initState() {
    super.initState();
    stream = controller.stream;
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key,
      onDismissed: widget.onDismissed,
      confirmDismiss: widget.confirmDismiss,
      direction: widget.direction,
      child: StreamBuilder(
        stream: stream,
        initialData: 1.0,
        builder: (context, snapshot) {
          return Listener(
            child: Opacity(
              opacity: snapshot.data,
              child: widget.child,
            ),
            onPointerDown: (event) {
              startPosition = event.position.dx;
            },
            onPointerUp: (event) {
              opacity = 1.0;
              controller.add(opacity);
            },
            onPointerMove: (details) {
              if (details.position.dx < startPosition) {
                var move = startPosition - details.position.dx;
                move = 2 * move / MediaQuery.of(context).size.width;

                opacity = 1 - move;
                if(opacity<0)opacity=0;

                controller.add(opacity);
              }
              if (details.position.dx > startPosition) {
                var move = details.position.dx - startPosition;
                move = 2 * move / MediaQuery.of(context).size.width;

                opacity = 1 - move;
                if(opacity<0)opacity=0;

                controller.add(opacity);
              }
            },
          );
        },
      ),
    );
  }
}

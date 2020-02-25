import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

const int TIMER = -1;
const int CHRONOMETER = 1;

class ClockWidget extends StatefulWidget {
  ClockWidget({@required this.start ,@required this.duration,this.operation=TIMER,@required this.onDone});
  int start;
  int duration;
  int operation;
  Function onDone;

  @override
  _ClockWidgetState createState() => _ClockWidgetState();

  
}

class _ClockWidgetState extends State<ClockWidget> {
int _current;
Color _color=Colors.black;

void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: widget.duration),
    new Duration(seconds:1),
  );

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { 
      _current = widget.start + widget.operation * duration.elapsed.inSeconds; 
      if(_current==widget.duration~/2)_color=Colors.yellow;
      if(_current==widget.duration~/4)_color=Colors.red;
    });
  });

  sub.onDone(() {
    widget.onDone();
    sub.cancel();
  });
}

@override
void initState() { 
  super.initState();
  _current = widget.start;
  startTimer();
}

Widget build(BuildContext context) {
  return Center(child: Text("Timer: $_current",style: TextStyle(
    fontSize: 20,
    color: _color
  ),));
}
}

int durationByDateTime(DateTime dateTime){
    return dateTime.difference(DateTime.now()).inSeconds;
  }
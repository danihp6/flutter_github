import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class HotSlider extends StatefulWidget {
  double value;
  Function(dynamic) onDragCompleted;
  double max;
  double min;
  bool isHotSliderActived;
  Color color;
  bool isHandlerActived;
  HotSlider(
      {this.value = 0,
      this.onDragCompleted,
      this.min = 0,
      this.max = 5,
      this.isHotSliderActived = false,
      this.isHandlerActived = true,
      this.color});

  @override
  _HotSliderState createState() => _HotSliderState();
}

class _HotSliderState extends State<HotSlider> {
  double _value;
  double _max;
  double _min;
  Color _color;
  bool _isHandlerActived ;

  @override
  void initState() {
    _value = widget.value;
    _min = widget.min;
    _max = widget.max;
    _color = widget.color;
    _isHandlerActived = widget.isHandlerActived;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_color == Theme.of(context).sliderTheme.thumbColor)_color = Theme.of(context).sliderTheme.valueIndicatorColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isHotSliderActived) return Container();
    
    return FlutterSlider(
      values: [_value],
      max: _max,
      min: _min,
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _value = lowerValue;
        if (lowerValue == _max)
          _color = Colors.yellowAccent[700];
        else if (lowerValue > (_max - _min) / 2)
          _color = Colors.redAccent;
        else
          _color = Colors.blueAccent;

        setState(() {});
      },
      handlerAnimation: FlutterSliderHandlerAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.bounceIn,
          duration: Duration(milliseconds: 500),
          scale: 1 + 1 * _value * 0.015),
      rightHandler: FlutterSliderHandler(
        disabled: !_isHandlerActived,
      ),
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(
          color: Theme.of(context).sliderTheme.thumbColor,
          shape: BoxShape.circle
        ),
          child: Icon(Icons.whatshot, color: _color, size: 30)),
      trackBar:
          FlutterSliderTrackBar(activeTrackBar: BoxDecoration(color: _color),inactiveTrackBar: BoxDecoration(color: Theme.of(context).sliderTheme.thumbColor)),
      step: FlutterSliderStep(
          step: 20, // default
          isPercentRange:
              true, // ranges are percents, 0% to 20% and so on... . default is true
          rangeList: [
            FlutterSliderRangeStep(from: 1, to: 20, step: 1),
            FlutterSliderRangeStep(from: 21, to: 40, step: 2),
            FlutterSliderRangeStep(from: 41, to: 60, step: 3),
            FlutterSliderRangeStep(from: 61, to: 80, step: 4),
            FlutterSliderRangeStep(from: 81, to: 99, step: 5),

          ]),
      tooltip: FlutterSliderTooltip(
        format: (value) => double.parse(value).toInt().toString(),
        textStyle: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 16
        )
      ),
      onDragCompleted: (handlerIndex, lowerValue, upperValue) async {
        _isHandlerActived = false;
        await widget.onDragCompleted(lowerValue);
        print('hola');
        _isHandlerActived = true;
      },
    );
  }
}

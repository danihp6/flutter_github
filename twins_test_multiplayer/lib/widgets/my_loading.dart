import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
MyLoading(this.state);
String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
          Text(state)
        ],
      ),
    );
  }
}
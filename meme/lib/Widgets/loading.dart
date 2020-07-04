import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
          )),
    );
  }
}

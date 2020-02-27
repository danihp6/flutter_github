import 'package:flutter/material.dart';

class WorldPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final int world = ModalRoute.of(context).settings.arguments;
    return Scaffold(
          appBar: AppBar(title:Text('WORLD ${world.toString()}')),
    );
  }
}
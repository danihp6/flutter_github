import 'package:flutter/material.dart';

class MemesHeader extends StatelessWidget {
  const MemesHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 60, right: 60, top: 40),
          child: Image.asset(
            'assets/images/bufon.png',
          ),
        ),
        Text(
          'MEMES',
          style: TextStyle(fontSize: 100, fontFamily: 'AvocadoCreamy'),
        ),
        Text(
          'for you',
          style: TextStyle(fontSize: 25, fontFamily: 'AvocadoCreamy'),
        ),
      ],
    );
  }
}
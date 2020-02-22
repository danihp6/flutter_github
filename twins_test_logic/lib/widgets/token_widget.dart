import 'package:flutter/material.dart';
import 'package:twins_test_logic/models/token.dart';


class TokenWidget extends StatefulWidget {
  TokenWidget(this.token);
  Token token;

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
       child: Image.asset(widget.token.image,fit: BoxFit.cover,),
    );
  }
}
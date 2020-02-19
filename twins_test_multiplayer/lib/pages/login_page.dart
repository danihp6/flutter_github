import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/models/player.dart';

import '../db.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Login')),
          body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
              ),
              FlatButton(
                child:Text('Entrar'),onPressed: ()=>newPlayer(Player(name:_controller.text)).then((value) => Navigator.of(context).pushNamed('/',arguments: value)),
              )
            ],
          ),
        ),
      ),
    );
  }
  
}


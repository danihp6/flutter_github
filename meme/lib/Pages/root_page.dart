import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/log_in_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Pages/tabs_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:splashscreen/splashscreen.dart';
import '../Widgets/memes_header.dart';

import '../Controller/auth.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.getAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return LogInPage();
        FirebaseUser firebaseUser = snapshot.data;
        return FutureBuilder(
            future: db.getUserByEmail(firebaseUser.email),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return SplashScreen();
              db.userId = snapshot.data;
              return MainPage();
            });
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text('Cargando...'),
          ),
          preferredSize: Size.fromHeight(40)),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Colors.orange[200],
                Colors.orange[100],
                Colors.white
              ],
                  stops: [
                0.3,
                0.5,
                0.8
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Column(
            children: <Widget>[MemesHeader(), Expanded(child: Loading())],
          ),
        ),
      ),
    );
  }
}

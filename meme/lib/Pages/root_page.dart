import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/log_in_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Widgets/loading.dart';

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
              if (!snapshot.hasData) return Loading();
              db.userId = snapshot.data;
              return MainPage();
            });
      },
    );
  }
}

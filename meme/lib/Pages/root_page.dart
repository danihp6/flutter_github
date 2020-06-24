import 'package:flutter/material.dart';
import 'package:meme/Pages/log_in_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Widgets/loading.dart';

import '../Controller/auth.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.initAuth(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return Loading();
        AuthStatus authStatus = snapshot.data;
        switch (authStatus) {
          case AuthStatus.notSignedIn:
            return LogInPage(refresh: refresh);
          case AuthStatus.signedIn:
            return MainPage(refresh: refresh);
        }
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/local_storage.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/log_in_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Pages/tabs_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/theme_changer.dart';
import 'package:provider/provider.dart';
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
    storage.initStorage().then((_) {
      final theme = Provider.of<ThemeChanger>(context,listen: false);
      theme.themeMode = storage.themeMode ?? ThemeMode.system;
      print('eyyy');
      setState(() {
        
      });
    });
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
            future: db.getUserByEmail(showDialogUserName, firebaseUser.email),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return SplashScreen();
              db.userId = snapshot.data;
              return MainPage();
            });
      },
    );
  }

  Future<String> showDialogUserName() {
    String userName = '';
    String userNameError = '';
    TextEditingController userNameController = TextEditingController();
    Future<bool> validate(Function setState) async {
      if (userName == '') {
        print('vacio');
        setState(() {
          userNameError = 'El nombre no puede estar vacio';
        });
        return false;
      } else if (await db.userNameExists(userName)) {
        return false;
      } else
        return true;
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => WillPopScope(
            onWillPop: () {},
            child: Dialog(
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Elige un nombre de usuario'),
                      TextField(
                          controller: userNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              labelText: 'nombre de usuario',
                              prefixIcon: Icon(Icons.person),
                              suffixIcon: userNameController.text.length > 0
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          userName = '';
                                          userNameError = '';
                                          userNameController.clear();
                                        });
                                      })
                                  : null,
                              errorText:
                                  userNameError != '' ? userNameError : null),
                          maxLength: 15,
                          onChanged: (value) {
                            setState(() {
                              userName = value;
                            });
                          }),
                      FlatButton(
                          onPressed: () async {
                            if (await validate(setState)) {
                              navigator.pop(context, userName);
                              userNameController.dispose();
                            }
                          },
                          child: Text(
                            'Aceptar',
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
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

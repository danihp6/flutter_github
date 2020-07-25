import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

class MyAppAvailability {
  Future openEmailApp(BuildContext context) {
    try {
      AppAvailability.launchApp(
              Platform.isIOS ? "message://" : "com.google.android.gm")
          .then((_) {
        print("App Email launched!");
      }).catchError((err) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("App Email not found!")));
        print(err);
      });
    } catch (e) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Email App not found!")));
    }
  }
}

MyAppAvailability apps = MyAppAvailability();
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messagingStreamController = StreamController<String>.broadcast();
  Stream<String> get message => _messagingStreamController.stream;
  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print('==== FCM TOKEN ====');
      print(token);
      //====PHONE====
      //eTt6XOoUTv6Jx1kA0YketU:APA91bEMEvrd3VBiO4Uqt3Pw96KTQKDDs2rC_A0Xjg_r6qRexKBV0s9S9stADXlP7woEPN6rWo2VhAr7-Q47AwXpt5J6_LPm9L58nkSzyhVOU5ZX3YkO7ROjzXAQgcOIhAE810rxOMVA
      //====PORTATIL====
      //cGBH_XE4ZXc:APA91bHiR-Nre-R5-J0duWFLn1eSHT0kBvCXX1LlJ_ItNhHxlXqYUxK45V24X9sMQINjFqh5B9UeJxlg-ZYPMAo7lFF03eB3heGiC4-Y22eQX9So5OkLmOminaULglPFM2WXPQjVF6k1
    });

    _firebaseMessaging.configure(
      onMessage: (info) {
        print('==== ON MESSAGE ====');
        print(info);
        String argumento = 'no-data';
        if (Platform.isAndroid) {
          argumento = info['data']['comida'] ?? 'no-data';
        }
        _messagingStreamController.sink.add(argumento);
      },
      onLaunch: (info) {
        print('==== ON LAUNCH ====');
        print(info);
      },
      onResume: (info) {
        print('==== ON RESUME ====');
        print(info);
        // final notification = info["data"]['comida'];
        // print(notification);
      },
    );
  }

  dispose() {
    _messagingStreamController?.close();
  }
}

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meme/Models/Notification.dart';
import 'local_storage.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Notification> _notifications;

  final _messagingStreamController = StreamController<List<Notification>>.broadcast();
  Stream<List<Notification>> get notification => _messagingStreamController.stream;
  initNotifications() {
    _notifications = storage.notifications ?? <Notification>[];
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print('==== FCM TOKEN ====');
      print(token);
      //====PHONE====
      //dhCZIN-TR6WZ7PsCNNgXwn:APA91bEhQ5iclG3-Y2u53nvvjBUisZXNe4O32bDFLhQSSZMzcodUt6bjGDVqWAh5bYE5cCXQIxMkzsQyYUApBCbXk7yM4Z9xpHiS-N77TxApJ-0rzAJh9q5yHmHemyttBEHQMIXOXZFj
      //====PORTATIL====
      //cGBH_XE4ZXc:APA91bHiR-Nre-R5-J0duWFLn1eSHT0kBvCXX1LlJ_ItNhHxlXqYUxK45V24X9sMQINjFqh5B9UeJxlg-ZYPMAo7lFF03eB3heGiC4-Y22eQX9So5OkLmOminaULglPFM2WXPQjVF6k1
      //====PC====
      //cyLsHHyglmk:APA91bFqwweq9d6q5qPlkYx94e-Qvm6x9NwNuwnxIfsCJRH_KXDpeD1dzOip_KhRdKqT7agOfYXUcZjVHCohsQ3XfiysiK3iekvyWtixml0Ky9P2rlXxzSBSfWK2xSd9_pUftccxluy0
    });

    _firebaseMessaging.configure(
      onMessage: (info) async {
        
        print('==== ON MESSAGE ====');
        print(info);
        Notification notification = Notification.fromMap(info);
        _notifications.add(notification);
        storage.notifications = _notifications;
        _messagingStreamController.sink.add(_notifications);
      },
      onLaunch: (info) {
        print('==== ON LAUNCH ====');
        print(info);
      },
      onResume: (info) {
        print('==== ON RESUME ====');
        print(info);
      },
    );
  }

  dispose() {
    _messagingStreamController?.close();
  }

  get notifications => this._notifications;
}

PushNotificationProvider pushProvider = PushNotificationProvider();

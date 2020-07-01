import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meme/Models/Notification.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messagingStreamController =
      StreamController<List<Notification>>.broadcast();
  Stream<List<Notification>> get notification =>
      _messagingStreamController.stream;
  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((value) {
      print('--------------------------TOKEN--------------------------------');
      print(value);
    });


    _firebaseMessaging.configure(
      onMessage: onNotification,
      onLaunch: onNotification,
      onResume: onNotification,
    );
  }

  Future<String> getToken()async=>await _firebaseMessaging.getToken();

  Future onNotification(Map<String, dynamic> info) {
    print(info);
    // Notification notification = Notification.fromMap(info);
    // _notifications.add(notification);
    // _messagingStreamController.sink.add(_notifications);
  }

  dispose() {
    _messagingStreamController?.close();
  }

}

PushNotificationProvider pushProvider = PushNotificationProvider();

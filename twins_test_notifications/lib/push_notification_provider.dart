import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';



class PushNotificationProvider{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messagingStreamController=StreamController<String>.broadcast();
  Stream<String> get message => _messagingStreamController.stream;
  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print('==== FCM TOKEN ====');  
      print(token);
      //d5JRzh5_fRI:APA91bH5NlKVLZKJIWkx0aVOzXxfwo_2APlifLIPsO6TUXdJZvabbVE6oH9kA7yR_Hb6ts6tBhxSR7fC3fYbKt4PjIolnuhwwBYbjTaIFeiq66-zuBixXh8WQJ-w1BXJvIFU66X7iX3j
    });

    _firebaseMessaging.configure(
      onMessage: (info){
        print('==== ON MESSAGE ====');
        print(info);

        String argumento = 'no-data';
        if(Platform.isAndroid){
          argumento=info['data']['comida']??'no-data';
        }
        _messagingStreamController.sink.add(argumento);
      },
      onLaunch: (info){
        print('==== ON LAUNCH ====');
        print(info);
        
      },
      onResume: (info){
        print('==== ON RESUME ====');
        print(info);
        // final notification = info["data"]['comida'];
        // print(notification);
      },
    );
  }

  dispose(){
    _messagingStreamController?.close();
  }
}
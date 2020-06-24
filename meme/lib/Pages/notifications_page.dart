import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/notification.dart';
import '../Models/Notification.dart' as mynotification;

class NotificationsPage extends StatelessWidget {
  String userId;
  NotificationsPage({@required this.userId});
  
  @override
  Widget build(BuildContext context) {
                print(userId);
    return Scaffold(
      body: StreamBuilder(
          stream: getNotifications(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            List<mynotification.Notification> notifications = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => SizedBox(height: 10,),
                itemBuilder: (context, index) { 
                  mynotification.Notification notification = notifications[index];
                  return SizedBox(
                    height: 70,
                    child: NotificationWidget(notification: notification));
                }
              ),
            );
          }),
    );
  }
}



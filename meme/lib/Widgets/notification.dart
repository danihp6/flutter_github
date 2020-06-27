import 'package:flutter/material.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/fading_dismissible.dart';
import 'package:meme/Widgets/follow_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Models/Notification.dart' as mynotification;
import 'loading.dart';

class NotificationWidget extends StatelessWidget {
  mynotification.Notification notification;
  NotificationWidget({
    @required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return FadingDismissible(
      key: UniqueKey(),
      onDismissed: (direction) =>
          db.deleteNotification(db.userId, notification.id),
      child: Row(
        children: [
          StreamBuilder(
              stream: db.getUser(notification.sender),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Expanded(
                  child: Row(children: [
                    GestureDetector(
                      child: UserAvatar(
                        url: user.avatar,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: UserPage(
                            userId: user.id,
                          ))),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(text: notification.body),
                              ],
                            ),
                          ),
                          Text(getPastTime(notification.dateTime)),
                        ],
                      ),
                    )
                  ]),
                );
              }),
          if (notification.post != null)
            StreamBuilder(
                stream: db.getPost(
                    'users/${notification.sender}/posts/${notification.post}'),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  Post post = snapshot.data;
                  return GestureDetector(
                    child: Image.network(post.media),
                    onTap: () => Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: PostPage(
                          userId: notification.sender,
                          postId: notification.post,
                        ))),
                  );
                })
          else
            FollowButton(userId: notification.sender)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meme/Controller/configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/fading_dismissible.dart';
import 'package:meme/Widgets/slide_left_route.dart';
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
      onDismissed: (direction) => deleteNotification(configuration.getUserId(),notification.id),
      child: Row(
        children: [
          StreamBuilder(
              stream: getUser(notification.sender),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Expanded(
                  child: Row(children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.getAvatar()),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: UserPage(
                            userId: user.getId(),
                          ))),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(text: notification.body),
                          ],
                        ),
                      ),
                    )
                  ]),
                );
              }),
          StreamBuilder(
              stream: getPost(
                  'users/${notification.sender}/posts/${notification.post}'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                Post post = snapshot.data;
                return GestureDetector(
                  child: Image.network(post.getMedia()),
                  onTap: () => Navigator.push(
                      context,
                      SlideLeftRoute(
                          page: PostPage(
                        userId: notification.sender,
                        postId: notification.post,
                      ))),
                );
              }),
        ],
      ),
    );
  }
}

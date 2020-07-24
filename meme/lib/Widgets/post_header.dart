import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/template_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'post_more_button.dart';
import 'package:meme/Widgets/share_button.dart';
import 'package:meme/Widgets/user_avatar.dart';

class PostHeader extends StatelessWidget {
  Post post;
  PostList postList;
  User author;
  GlobalKey<ScaffoldState> scaffoldState;
  PostHeader(
      {@required this.post,
      this.postList,
      @required this.author,
      @required this.scaffoldState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 40, child: UserAvatar(user: author)),
        SizedBox(width: 10),
        Text(
          author.userName,
          style: Theme.of(context).textTheme.headline1,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (post.template != null)
                StreamBuilder(
                    stream: db.getTemplate(post.template),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      Template template = snapshot.data;
                      return TemplateButton(
                        template: template,
                      );
                    }),
              ShareButton(
                  authorId: post.author,
                  postId: post.id,
                  scaffoldState: scaffoldState),
              PostMoreButton(
                post: post,
                postList: postList,
                scaffoldState: scaffoldState,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TemplateButton extends StatelessWidget {
  const TemplateButton({Key key, @required this.template}) : super(key: key);
  final Template template;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.filter_frames),
        onPressed: () {
          showModalTemplate(context,template);
        });
  }

}
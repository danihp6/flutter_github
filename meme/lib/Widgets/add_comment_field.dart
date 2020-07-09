import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/string_functions.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/select_post_from_post_list_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import 'package:meme/Widgets/video_player.dart';
import 'loading.dart';
import '../Models/Notification.dart' as mynotification;

class AddCommentField extends StatefulWidget {
  User user;
  Post post;
  FocusNode focusNode;
  Comment commentResponse;
  Function cancelResponse;
  AddCommentField(
      {@required this.user,
      @required this.post,
      @required this.focusNode,
      this.commentResponse,
      this.cancelResponse});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  String text;
  TextEditingController controller;
  bool isMentionsShowed;
  String userSearch = '';
  List<String> userMentions = [];
  int startWordIndex;
  String media = '';
  MediaType mediaType;

  @override
  void initState() {
    text = '';
    isMentionsShowed = false;
    controller = new TextEditingController();
    controller.addListener(() {
      isMentionsShowed = false;
      if (controller.selection.baseOffset > 0) {
        startWordIndex = startIndexWordAtPosition(
            controller.value.text, controller.selection.baseOffset - 1);
        if (startWordIndex != -1) {
          if (controller.value.text[startWordIndex] == '@') {
            isMentionsShowed = true;
            userSearch = nextWord(controller.value.text
                .substring(startWordIndex + 1, (controller.value.text.length)));
          }
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void sendComment() async {
      userMentions = wordsStartWith(text, '@');
      if (widget.commentResponse != null) {
        db.newInnerComment(
            widget.post.author,
            widget.post.id,
            widget.commentResponse.id,
            new Comment(text, <String>[], db.userId, DateTime.now(), <String>[],
                1, media, mediaType));
        widget.cancelResponse();
      } else
        db.newOuterComment(
            widget.post.author,
            widget.post.id,
            new Comment(text, <String>[], db.userId, DateTime.now(), <String>[],
                0, media, mediaType));
      userMentions.forEach((userName) async {
        String id =
            await db.userIdByUserName(userName.substring(1, userName.length));
        db.newNotification(
            id,
            new mynotification.Notification(
                'Te han mencionado',
                widget.user.userName + ' te ha mencionado',
                widget.post.author,
                widget.post.id,
                DateTime.now()));
      });
      controller.clear();
      text = '';
      media = '';
      widget.focusNode.unfocus();
    }

    selectMedia(Post post) {
      setState(() {
        media = post.media;
        mediaType = post.mediaType;
        Navigator.pop(context);
      });
    }

    return Column(
      children: <Widget>[
        if (isMentionsShowed)
          FutureBuilder(
              future: db.userSearch(userSearch),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                List<User> users = snapshot.data;
                return ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                    child: Text(users[index].userName),
                    onTap: () {
                      String textBefore = controller.selection
                              .textBefore(text)
                              .substring(0, startWordIndex + 1) ??
                          '';
                      String textAfter = controller.selection
                              .textAfter(text)
                              .substring(
                                  restOffWord(
                                      text, controller.selection.baseOffset),
                                  controller.selection
                                      .textAfter(text)
                                      .length) ??
                          '';
                      text = textBefore + users[index].userName + textAfter;
                      controller.text = text;
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(
                              offset: textBefore.length +
                                  users[index].userName.length));
                      setState(() {});
                    },
                  ),
                );
              }),
        if (widget.commentResponse != null)
          Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) => widget.cancelResponse(),
            child: Text(
                'Respondiendo al comentario: ${widget.commentResponse.text}'),
          ),
        if (media != '')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: mediaType == MediaType.image
                          ? Image.network(media)
                          : VideoPlayerWidget(
                              url: media,
                            ),
                    )),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        media = '';
                        mediaType = null;
                      });
                    })
              ],
            ),
          ),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
                height: 30, width: 30, child: UserAvatar(user: widget.user)),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: text.length > 0
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                controller.clear();
                                text = '';
                              });
                            })
                        : !widget.focusNode.hasFocus
                            ? Icon(Icons.comment)
                            : null,
                    hintText: 'Escribe un comentario',
                    border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                controller: controller,
                focusNode: widget.focusNode,
              ),
            ),
            if (text.length == 0)
              IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: SelectPostFromPostListPage(
                          onTap: selectMedia,
                        )));
                  }),
            if (text.length > 0)
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendComment,
              )
          ],
        ),
      ],
    );
  }
}

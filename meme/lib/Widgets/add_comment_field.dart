import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/string_functions.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/user_avatar.dart';
import 'loading.dart';

class AddCommentField extends StatefulWidget {
  User user;
  String postId;
  AddCommentField({@required this.user, @required this.postId});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  String text;
  TextEditingController controller;
  FocusNode focus;
  bool isMentionsShowed;
  String userSearch = '';
  List<String> userMentions = [];
  int startWordIndex;

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
    focus = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void sendComment() {
      userMentions = wordsStartWith(text, '@');
      db.newComment(
          db.userId,
          widget.postId,
          new Comment(
              text, <String>[], db.userId, DateTime.now(), <String>[], 0));
      controller.clear();
      text = '';
      focus.unfocus();
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
                        : Icon(Icons.comment),
                    hintText: 'Escribe un comentario',
                    border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                controller: controller,
                focusNode: focus,
              ),
            ),
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

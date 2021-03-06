import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/comment.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Models/Comment.dart';

class CommentsPage extends StatefulWidget {
  String postId;
  String authorId;
  String description;
  CommentsPage(
      {@required this.postId,
      @required this.authorId,
      @required this.description});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  FocusNode focusNode;
  Comment commentResponse;
  bool colapseComments;
  String selectedCommentId;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    response(Comment comment) {
      setState(() {
        selectedCommentId = comment.id;
        commentResponse = comment;
        focusNode.requestFocus();
      });
    }

    cancelResponse() {
      setState(() {
        selectedCommentId = '';
        commentResponse = null;
        focusNode.unfocus();
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text('Comentarios'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.visibility_off), onPressed: (){
              setState(() {
                colapseComments = false;
              });
            }),
            IconButton(icon: Icon(Icons.visibility), onPressed: (){
              setState(() {
                colapseComments = true;
              });
            }),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (widget.description != '')
                      StreamBuilder(
                        stream: db.getUser(widget.authorId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          User user = snapshot.data;
                          return Row(
                            children: [
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: UserAvatar(user: user)),
                              SizedBox(width: 10),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                        text: user.userName + ' ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: widget.description),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    if (widget.description != '') Divider(),
                    StreamBuilder(
                        stream:
                            db.getOuterComments(widget.authorId, widget.postId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<Comment> parentComments = snapshot.data;
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: parentComments.length,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 5,
                                  ),
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                  comment: parentComments[index],
                                  response: response,
                                  colapseComments: colapseComments,
                                  selectedCommentId:selectedCommentId,
                                  cancelResponse:cancelResponse
                                );
                              });
                        }),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder(
              stream: db.getUser(db.userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Container(
                  color: Colors.grey[300],
                  child: AddCommentField(
                      user: user,
                      postAuthorId: widget.authorId,
                      postId: widget.postId,
                      focusNode: focusNode,
                      commentResponse: commentResponse,
                      cancelResponse: cancelResponse),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

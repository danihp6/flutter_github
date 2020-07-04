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
  Post post;
  CommentsPage({@required this.post});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  FocusNode focusNode;
  Comment commentResponse;

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

    response(Comment comment){
      setState(() {
        commentResponse = comment;
        focusNode.requestFocus();
        
      });
    }

    cancelResponse(){
      setState(() {
        commentResponse = null;
        focusNode.unfocus();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if(widget.post.description!='')
                    StreamBuilder(
                      stream: db.getUser(widget.post.author),
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: widget.post.description),
                            ],
                          ),
                        ),
                      ],
                    );
                      },
                    ),
                    if(widget.post.description!='')
                    Divider(),
                    StreamBuilder(
                        stream:
                            db.getOuterComments(widget.post.author, widget.post.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData) return Loading();
                          List<Comment> parentComments = snapshot.data;
                          return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: parentComments.length,
                              separatorBuilder: (context, index) => SizedBox(height: 5,),
                              itemBuilder: (context, index) {
                                return CommentWidget(
                                      comment: parentComments[index],
                                      response:response
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
                    post: widget.post,
                    focusNode: focusNode,
                    commentResponse:commentResponse,
                    cancelResponse:cancelResponse
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/like_comment_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Controller/db.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  Comment outerComment;
  bool activeInnerComments;
  bool activeLikesAndTime;
  Function response;
  CommentWidget(
      {@required this.comment,
      this.activeInnerComments = true,
      this.activeLikesAndTime = true,
      this.outerComment,
      this.response});


  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Comment _comment;
  bool _isShowedInnedComments = false;
  List<String> _innerCommentsId;

  @override
  Widget build(BuildContext context) {
    _comment = widget.comment;
    _innerCommentsId = _comment.comments;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: StreamBuilder(
              stream: db.getUser(_comment.authorId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    if (db.userId == _comment.authorId)
                      IconSlideAction(
                        caption: 'Borrar',
                        color: Colors.deepOrangeAccent,
                        icon: Icons.delete,
                        onTap: () => _comment.level == 0
                            ? db.deleteOuterComment(
                                _comment.authorId, _comment.postId, _comment.id)
                            : db.deleteInnerComment(
                                _comment.authorId,
                                _comment.postId,
                                widget.outerComment.id,
                                _comment.id),
                      ),
                  ],
                  child: Row(
                    children: [
                      SizedBox(
                          width: 30, height: 30, child: UserAvatar(user: user)),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                                text: user.userName + ' ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: _comment.text),
                            if(_comment.level == 0)
                            TextSpan(
                                text: ' Responder',
                                style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = ()=>widget.response(_comment) )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_comment.likes.length.toString()),
                              SizedBox(
                                width: 30,
                                child: LikeCommentButton(comment: _comment),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(getPastTime(_comment.dateTime))
                            ]),
                      )
                    ],
                  ),
                );
              }),
        ),
        if (widget.activeInnerComments &&
            _comment.comments.length > 0 &&
            !_isShowedInnedComments)
          SizedBox(
            height: 20,
            child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    _isShowedInnedComments = !_isShowedInnedComments;
                  });
                },
                child: _innerCommentsId.length == 1
                    ? Text('Ver ' + 1.toString() + ' respuesta')
                    : Text('Ver ' +
                        _innerCommentsId.length.toString() +
                        ' respuestas')),
          ),
        if (_isShowedInnedComments)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _comment.comments.length,
              itemBuilder: (context, index) {
                String commentId = _innerCommentsId[index];
                return StreamBuilder(
                    stream: db.getComment(
                        _comment.userPostId, _comment.postId, commentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      Comment comment = snapshot.data;
                      print(comment.id);
                      return CommentWidget(
                          comment: comment, outerComment: _comment);
                    });
              },
            ),
          ),
        if (_isShowedInnedComments && _comment.level == 0)
          SizedBox(
            height: 20,
            child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    _isShowedInnedComments = !_isShowedInnedComments;
                  });
                },
                child: _innerCommentsId.length == 1
                    ? Text('Esconder respuesta')
                    : Text('Esconder respuestas')),
          ),
        if (_isShowedInnedComments && _comment.level == 0)
          Divider(
            thickness: 1,
            indent: 50,
            endIndent: 50,
            height: 8,
          )
      ],
    );
  }
}

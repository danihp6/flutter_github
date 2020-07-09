import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/like_comment_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/user_avatar.dart';
import 'package:meme/Widgets/video_player.dart';
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
        StreamBuilder(
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
                      color: Theme.of(context).accentColor,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                      text: user.userName + ' ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: _comment.text),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                          child: Row(children: [
                            Text(_comment.likes.length.toString()),
                            LikeCommentButton(comment: _comment),
                            SizedBox(
                              width: 2,
                            ),
                            Text(getPastTime(_comment.dateTime)),
                            if (_comment.level == 0)
                              FlatButton(
                                  child: Text(
                                    ' Responder',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => widget.response(_comment))
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
            if(_comment.media != '')
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 200,
                child: AspectRatio(aspectRatio: 1,
                child: _comment.mediaType == MediaType.image
                    ? Image.network(_comment.media)
                    : VideoPlayerWidget(
                        url: _comment.media,
                      ),)),
          ),
        if (widget.activeInnerComments &&
            _innerCommentsId.length > 0 &&
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
        if (_isShowedInnedComments) SizedBox(height: 5),
        if (_isShowedInnedComments)
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _comment.comments.length,
            separatorBuilder: (context, index) => SizedBox(height: 5),
            itemBuilder: (context, index) {
              String commentId = _innerCommentsId[index];
              return StreamBuilder(
                  stream: db.getComment(
                      _comment.userPostId, _comment.postId, commentId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    Comment comment = snapshot.data;
                    return CommentWidget(
                        comment: comment, outerComment: _comment);
                  });
            },
          ),
        if (_isShowedInnedComments &&
            _comment.level == 0 &&
            _innerCommentsId.length > 0)
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
        if (_isShowedInnedComments &&
            _comment.level == 0 &&
            _innerCommentsId.length > 0)
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

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
import 'package:rxdart/rxdart.dart';
import '../Controller/db.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  Comment outerComment;
  bool activeInnerComments;
  bool activeResponse;
  bool colapseComments;
  Function response;
  Function cancelResponse;
  String selectedCommentId;
  CommentWidget(
      {@required this.comment,
      this.activeInnerComments = true,
      this.activeResponse = true,
      this.colapseComments,
      this.outerComment,
      this.selectedCommentId,
      this.cancelResponse,
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
    if (widget.colapseComments != null) {
      _isShowedInnedComments = widget.colapseComments ? true : false;
      widget.colapseComments = null;
    }

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
                  if (db.userId == _comment.authorId ||
                      db.userId == _comment.userPostId)
                    IconSlideAction(
                        caption: 'Borrar',
                        color: Theme.of(context).accentColor,
                        icon: Icons.delete,
                        onTap: () {
                          widget.cancelResponse();
                          _comment.level == 0
                              ? db.deleteOuterComment(_comment.authorId,
                                  _comment.postId, _comment.id)
                              : db.deleteInnerComment(
                                  _comment.authorId,
                                  _comment.postId,
                                  widget.outerComment.id,
                                  _comment.id);
                        }),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.selectedCommentId == _comment.id
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : null,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                    TextSpan(
                                        text: _comment.text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                            child: Row(children: [
                              Text(_comment.likes.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 15)),
                              SizedBox(
                                  width: 30,
                                  child: LikeCommentButton(comment: _comment)),
                              SizedBox(
                                width: 2,
                              ),
                              Text(getPastTime(_comment.dateTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 15)),
                              if (widget.activeResponse)
                                FlatButton(
                                    child: Text(
                                        widget.selectedCommentId != _comment.id
                                            ? 'Responder'
                                            : 'Cancelar',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(fontSize: 14)),
                                    onPressed:
                                        widget.selectedCommentId != _comment.id
                                            ? () => widget.response(_comment)
                                            : () => widget.cancelResponse())
                            ]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        if (_comment.media != '')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 200,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _comment.mediaType == MediaType.image
                      ? CachedNetworkImage(
                          imageUrl: _comment.media,
                          placeholder: (context, url) => Loading(),
                          errorWidget: (context, url, error) => Container(),
                        )
                      : VideoPlayerWidget(
                          url: _comment.media,
                        ),
                )),
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
              child: Text(
                  _innerCommentsId.length == 1
                      ? 'Ver ' + 1.toString() + ' respuesta'
                      : 'Ver ' +
                          _innerCommentsId.length.toString() +
                          ' respuestas',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14)),
            ),
          ),
        if (_isShowedInnedComments && _innerCommentsId.isNotEmpty) SizedBox(height: 5),
        if (_isShowedInnedComments && _innerCommentsId.isNotEmpty)
          StreamBuilder(
            stream: CombineLatestStream.list(_innerCommentsId.reversed.map(
                    (commentId) => db.getComment(
                        _comment.userPostId, _comment.postId, commentId)))
                .asBroadcastStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              List<Comment> comments = snapshot.data;
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _comment.comments.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) => CommentWidget(
                  comment: comments[index],
                  outerComment: _comment,
                  response: widget.response,
                  selectedCommentId: widget.selectedCommentId,
                  cancelResponse: widget.cancelResponse,
                ),
              );
            },
          ),
        if (_isShowedInnedComments &&
            _comment.level == 0 &&
            _innerCommentsId.isNotEmpty)
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
                child: Text(
                    _innerCommentsId.length == 1
                        ? 'Esconder respuesta'
                        : 'Esconder respuestas',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 14))),
          ),
        if (_innerCommentsId.isEmpty) SizedBox(height: 5),
        if (_isShowedInnedComments &&
            _comment.level == 0 &&
            _innerCommentsId.isNotEmpty)
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

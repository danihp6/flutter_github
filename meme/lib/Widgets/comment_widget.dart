import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';
import '../Controller/db.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  bool activeInnerComments;
  CommentWidget({this.comment, this.activeInnerComments});

  bool isShowedInnedComments = false;

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  
  @override
  Widget build(BuildContext context) {
    Comment _comment = widget.comment;
    bool _isShowedInnedComments = widget.isShowedInnedComments;
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              StreamBuilder(
                  stream: getUser(_comment.getAuthorId()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    User user = snapshot.data;
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(user.getImage()),
                        ),
                        SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                  text: user.getName() + ' ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: _comment.getComment()),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(_comment.getLikes().toString()),
                  SizedBox(
                    width: 30,
                    child: IconButton(
                        icon: Icon(Icons.favorite_border),
                        iconSize: 15,
                        onPressed: () {}),
                  ),
                  Text(_comment.getPastTime())
                ]),
              )
            ],
          ),
        ),
        if (widget.activeInnerComments &&
            _comment.getComments().length > 0 &&
            !_isShowedInnedComments)
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 20,
              child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      widget.isShowedInnedComments = !_isShowedInnedComments;
                    });
                  },
                  child: Text('Ver ' +
                      _comment.getComments().length.toString() +
                      ' comentarios')),
            ),
          ),
        if (_isShowedInnedComments && _comment.getLevel() == 0)
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 20,
              child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      widget.isShowedInnedComments = !_isShowedInnedComments;
                    });
                  },
                  child: Text('Esconder comentarios')),
            ),
          ),
        if (_isShowedInnedComments)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _comment.getComments().length,
            itemBuilder: (context, index) {
              var comments = _comment.getComments();
              return StreamBuilder(
                stream: getComment(_comment.getPublicationId(), comments[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    Comment comment = snapshot.data;
                  return CommentWidget(
                    comment: comment,
                    activeInnerComments: true,
                  );
                }
              );
            },
          ),
        if (_isShowedInnedComments && _comment.getLevel() == 0)
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

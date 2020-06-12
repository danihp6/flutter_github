import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';

class CommentWidget extends StatefulWidget {
  Comment comment;
  bool activeInnerComments;
  int level;
  CommentWidget({this.comment, this.activeInnerComments,this.level});

  bool isShowedInnedComments = false;

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    Comment _comment = widget.comment;
    bool _isShowedInnedComments = widget.isShowedInnedComments;
    int _level = widget.level;
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(_comment.getAuthor().getImage()),
              ),
              SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                        text: _comment.getAuthor().getName() + ' ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: _comment.getComment()),
                  ],
                ),
              ),
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
        if (widget.activeInnerComments && _comment.getComments().length>0 && !_isShowedInnedComments)
          Align(
            alignment: Alignment.topLeft,
                      child: SizedBox(
              height: 20,
              child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  onPressed: (){setState(() {widget.isShowedInnedComments=!_isShowedInnedComments;});},
                  child:
                      Text('Ver ' + _comment.getComments().length.toString() + ' comentarios')),
            ),
          ),
          if (_isShowedInnedComments && _level == 0)
          Align(
            alignment: Alignment.topLeft,
                      child: SizedBox(
              height: 20,
              child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0),
                  onPressed: (){setState(() {widget.isShowedInnedComments=!_isShowedInnedComments;});},
                  child:
                      Text('Esconder comentarios')),
            ),
          ),
          if(_isShowedInnedComments)
        ListView.builder(
          shrinkWrap: true,
          itemCount: _comment.getComments().length,
          itemBuilder: (context, index) {
            var comments = _comment.getComments();
            return CommentWidget(
              comment: comments[index],
              activeInnerComments: true,
              level: _level + 1,
            );
          },
        ),
          if(_isShowedInnedComments && _level == 0)
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/favourite_button.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/stream_tag_viewer.dart';
import 'package:meme/Widgets/tag_selector.dart';
import 'package:meme/Widgets/tags_viewer.dart';
import 'hot_slider.dart';

import 'comment.dart';

class PostDescription extends StatefulWidget {
  Post post;
  User author;

  PostDescription({@required this.post, @required this.author});

  @override
  _PostDescriptionState createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  double _min = 0;
  double _max = 5;
  bool _isHotSliderActived = false;
  bool _isHandlerActived = true;
  double _value;
  Color _color = Colors.black;

  @override
  void initState() {
    try {
      _value = widget.post.hotPoints[db.userId].toDouble();
      if (_value == _max)
        _color = Colors.yellowAccent[700];
      else if (_value > (_max - _min) / 2)
        _color = Colors.redAccent;
      else
        _color = Colors.blueAccent;
    } catch (e) {
      _value = 50;
      _color = Colors.black;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future onDragCompleted(double value) async {
      setState(() {
        db.changeHotPoints(
            widget.author.id, widget.post.id, db.userId, value.toInt());
        _value = value;
        if (value == _max)
          _color = Colors.yellowAccent[700];
        else if (value > (_max - _min) / 2)
          _color = Colors.redAccent;
        else
          _color = Colors.blueAccent;
      });
      return Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _isHotSliderActived = false;
          _isHandlerActived = true;
        });
      });
    }

    return Column(
      children: [
        if (_isHotSliderActived)
          SizedBox(
            height: 50,
            child: HotSlider(
              value: _value,
              min: _min,
              max: _max,
              isHandlerActived: _isHandlerActived,
              color: _color,
              isHotSliderActived: _isHotSliderActived,
              onDragCompleted: (value) => onDragCompleted(value),
            ),
          ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.whatshot),
                  iconSize: 35,
                  color: _color,
                  onPressed: () {
                    setState(() {
                      _isHotSliderActived = !_isHotSliderActived;
                    });
                  }),
              Text(widget.post.getTotalHotPoints().toString(),
                  style: TextStyle(fontSize: 18)),
              IconButton(
                icon: Icon(Icons.comment),
                iconSize: 35,
                onPressed: () => Navigator.of(context).push(SlideLeftRoute(
                    page: CommentsPage(
                  post: widget.post,
                ))),
              ),
              StreamBuilder(
                  stream: db.getComments(widget.author.id, widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Container();
                    List<Comment> comments = snapshot.data;
                    return Text(comments.length.toString(),
                        style: TextStyle(fontSize: 18));
                  }),
              FavouriteButton(post: widget.post),
              Text(widget.post.favourites.length.toString(),
                  style: TextStyle(fontSize: 18))
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 8),
          child: Column(
            children: <Widget>[
              if (widget.post.description != '')
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                              text: widget.author.userName + ' ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.post.description)
                        ]),
                  ),
                ),
              if (widget.post.tags.length > 0)
                SizedBox(
                  height: 30,
                  child: StreamTagViewer(
                    tagsId: widget.post.tags,
                  ),
                ),
              SizedBox(
                height: 3,
              ),
              StreamBuilder(
                  stream:
                      db.getBestComment(widget.post.author, widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Container();
                    Comment bestComment = snapshot.data;
                    return Column(
                      children: [
                        CommentWidget(
                          comment: bestComment,
                          activeInnerComments: false,
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Publicada hace ' + getPastTime(widget.post.dateTime),
                    style: TextStyle(fontSize: 13),
                  )),
            ],
          ),
        )
      ],
    );
  }
}

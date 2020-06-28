import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/my_slider.dart';
import 'package:meme/Widgets/post_description.dart';
import 'package:meme/Widgets/post_header.dart';
import 'package:meme/Widgets/video_player.dart';
import '../Controller/db.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class PostWidget extends StatefulWidget {
  Post post;
  PostList postList;
  bool activeAlwaysShowedComments;
  PostWidget(
      {@required this.post,
      this.postList,
      this.activeAlwaysShowedComments = false});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  @override
  Widget build(BuildContext context) {
    bool _isShowedComments = configuration.getIsShowedComments();
    List<String> favourites = widget.post.favourites;

    addOrRemoveFavourite(String userId, String postId) {
      String postPath = 'users/${widget.post.authorId}/posts/${widget.post.id}';
      print(favourites.contains(db.userId));
      if (!favourites.contains(db.userId))
        db.addPostPathInFavourites(userId, postPath);
      else
        db.deletePostPathInFavourites(userId, postPath);
    }

    return Container(
      child: Column(children: [
        if (_isShowedComments || widget.activeAlwaysShowedComments)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
                height: 50,
                child: PostHeader(
                  post: widget.post,
                  postList: widget.postList,
                )),
          ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: widget.post.mediaType == 'image'
                      ? Image.network(
                          widget.post.media,
                          fit: BoxFit.cover,
                        )
                      : VideoPlayerWidget(url: widget.post.media),
                ),
                onDoubleTap: () => addOrRemoveFavourite(db.userId,
                    'users/${widget.post.authorId}/posts/${widget.post.id}')),
            MySlider()
          ],
        ),
        if (_isShowedComments || widget.activeAlwaysShowedComments)
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
            child: PostDescription(post: widget.post),
          )
      ]),
    );
  }
}

class MySlider extends StatefulWidget {
  double value;
  MySlider({
    double value = 50,
  });

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value;
  double _max = 100;
  double _min = 0;
  Color _iconColor = Colors.black;
  Color _trackBarColor = Colors.black;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      values: [_value],
      max: _max,
      min: _min,
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _value = lowerValue;
        if (lowerValue > (_max - _min) / 2) {
          _trackBarColor = Colors.redAccent;
          _iconColor = Colors.redAccent;
        } else {
          _trackBarColor = Colors.blueAccent;
          _iconColor = Colors.blueAccent;
        }
        setState(() {});
      },
      handlerAnimation: FlutterSliderHandlerAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.bounceIn,
          duration: Duration(milliseconds: 500),
          scale: 1 + 1 * _value * 0.015),
      handler: FlutterSliderHandler(
          child: Icon(Icons.whatshot, color: _iconColor, size: 30),
          decoration: BoxDecoration(),
          opacity: 0.8),
      trackBar: FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(color: _trackBarColor)),
      step: FlutterSliderStep(
          step: 5, // default
          isPercentRange:
              true, // ranges are percents, 0% to 20% and so on... . default is true
          rangeList: [
            FlutterSliderRangeStep(from: 1, to: 20, step: 20),
            FlutterSliderRangeStep(from: 21, to: 39, step: 20),
            FlutterSliderRangeStep(from: 40, to: 49, step: 10),
            FlutterSliderRangeStep(from: 50, to: 50, step: 1),
            FlutterSliderRangeStep(from: 51, to: 60, step: 10),
            FlutterSliderRangeStep(from: 61, to: 80, step: 20),
            FlutterSliderRangeStep(from: 81, to: 100, step: 20),
          ]),
      tooltip: FlutterSliderTooltip(
          format: (value) => value.substring(0, value.length - 2),
          rightSuffix: Icon(Icons.whatshot, size: 20, color: _iconColor),
          textStyle: TextStyle(fontSize: 16)),
      centeredOrigin: true,
    );
  }
}

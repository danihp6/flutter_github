import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  String url;
  File file;
  VideoPlayerWidget({this.url, this.file});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print(widget.file);
    _controller = widget.file == null
        ? VideoPlayerController.network(widget.url)
        : VideoPlayerController.file(widget.file);
    _controller
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.addListener(() {
          setState(() {});
        });
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                VideoPlayer(_controller),
                _PlayPauseOverlay(
                  controller: _controller,
                ),
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          )
        : Container();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

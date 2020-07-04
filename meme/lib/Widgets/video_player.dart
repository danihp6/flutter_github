import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class VideoPlayerWidget extends StatefulWidget {
  String url;
  File file;
  bool isPausable;
  VideoPlayerWidget({this.url, this.file, this.isPausable = true});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  bool _isManualPaused;

  @override
  void initState() {
    super.initState();
    _isManualPaused = false;
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
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  manualPause() {
    _isManualPaused = !_isManualPaused;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return _controller.value.initialized
        ? VisibilityDetector(
            key: UniqueKey(),
            onVisibilityChanged: (info) {
              if(!mounted)return;
              if (info.visibleFraction > 0.8 &&
                  !_controller.value.isPlaying &&
                  !_isManualPaused)
                setState(() {
                  _controller.play();
                });
              if (info.visibleFraction < 0.8 && _controller.value.isPlaying)
                setState(() {
                  _controller.pause();
                });
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  width: size,
                  height: size,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ClipRect(
                          child: OverflowBox(
                              alignment: Alignment.center,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                      width: size,
                                      height:
                                          size / _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller))))),
                      _PlayPauseOverlay(
                        controller: _controller,
                        isPausable: widget.isPausable,
                        manualPause: manualPause,
                      ),
                    ],
                  ),
                ),
                if (widget.isPausable)
                  VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          )
        : Loading();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  _PlayPauseOverlay(
      {Key key, this.controller, this.isPausable, this.manualPause})
      : super(key: key);

  VideoPlayerController controller;
  bool isPausable;
  Function manualPause;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: !controller.value.isPlaying ? 1.0 : 0.0,
            duration: Duration(seconds: 5),
            child: Container(
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
        ),
        if (isPausable)
          GestureDetector(
            onTap: () {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
              manualPause();
            },
          ),
      ],
    );
  }
}

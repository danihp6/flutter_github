import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/configuration.dart';

import 'package:meme/Widgets/loading.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class VideoPlayerWidget extends StatefulWidget {
  Key key;
  String url;
  File file;
  bool isPausable;
  double aspectRatio;
  VideoPlayerWidget(
      {this.url,
      this.file,
      this.isPausable = true,
      this.key,
      this.aspectRatio = 1});
  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  CachedVideoPlayerController _controller;
  bool _isManualPaused;

  @override
  void initState() {
    super.initState();
    _isManualPaused = false;
    initController();
  }

  initController() async {
    if (_controller != null) {
      final oldController = _controller;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();
      });
    }

    _controller = widget.file == null
        ? CachedVideoPlayerController.network(widget.url)
        : CachedVideoPlayerController.file(widget.file);
    _controller
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.addListener(() {
          setState(() {});
        });
        _controller.setLooping(true);
        if (widget.isPausable)
          _controller.setVolume(configuration.volume);
        else
          _controller.setVolume(0);
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
    if (!_controller.value.initialized) return Loading();

    if (_controller.value.hasError) return Container();

    var size = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        VisibilityDetector(
          key: UniqueKey(),
          onVisibilityChanged: (info) {
            if (!mounted) return;
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
                height: size / widget.aspectRatio,
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
                                    child: CachedVideoPlayer(_controller))))),
                    if (widget.isPausable)
                      _PlayPauseOverlay(controller: _controller),
                  ],
                ),
              ),
              if (widget.isPausable)
                VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          ),
        ),
        if(widget.isPausable)
        GestureDetector(
          onTap: () {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
            manualPause();
          },
          onDoubleTap: () {
            configuration.volume = _controller.value.volume == 0 ? 1 : 0;
            _controller.setVolume(configuration.volume);
          },
        )
      ],
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  CachedVideoPlayerController controller;

  _PlayPauseOverlay({this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.volume != 0
              ? SizedBox.shrink()
              : Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.volume_off,
                    color: Colors.white.withOpacity(0.7),
                    size: 40,
                  ),
                ),
        ),
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
                      color: Colors.white.withOpacity(0.8),
                      size: 100.0,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

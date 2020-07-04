import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/video_player.dart';
import 'package:transparent_image/transparent_image.dart';

class PostsCarousel extends StatefulWidget {
  PostsCarousel({@required this.posts, @required this.onTap});

  List<String> posts;
  Function onTap;

  @override
  _PostsCarouselState createState() => _PostsCarouselState();
}

class _PostsCarouselState extends State<PostsCarousel> {
  bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = false;
  }

  List<Widget> carousel(List<String> posts) => posts
      .map((postPath) => StreamBuilder(
          stream: db.getPostByPath(postPath),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            Post post = snapshot.data;
            return GestureDetector(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: post.mediaType == 'image'
                      ? FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(post.media))
                      : VideoPlayerWidget(
                          url: post.media,
                          isPausable: false,
                        ),
                ),
                onTap: () => widget.onTap(post));
          }))
      .toList();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        print(info.visibleFraction.toString());
        if (info.visibleFraction < 0.8 &&
            info.visibleFraction > 0.1 &&
            _visible == true &&
            widget.posts.length > 1)
          setState(() {
            _visible = false;
          });
        if (info.visibleFraction > 0.8 &&
            _visible == false &&
            widget.posts.length > 1)
          setState(() {
            _visible = true;
          });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              initialPage: 0,
              autoPlay: _visible,
              autoPlayAnimationDuration: Duration(seconds: 5),
              autoPlayInterval: Duration(seconds: 8),
              autoPlayCurve: Curves.decelerate,
              height: 240,
              pauseAutoPlayOnManualNavigate: true,

            ),
            items: carousel(widget.posts),
          ),
          if (widget.posts.length > 1)
            AnimatedOpacity(
                opacity: _visible ? 0 : 1,
                duration: Duration(seconds: 5),
                child: Icon(
                  Icons.play_arrow,
                  size: 70,
                  color: Colors.black54,
                ))
        ],
      ),
    );
  }
}

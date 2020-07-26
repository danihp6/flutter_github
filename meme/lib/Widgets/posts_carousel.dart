import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/video_player.dart';
import 'package:transparent_image/transparent_image.dart';

class PostsCarousel extends StatefulWidget {
  PostsCarousel(
      {@required this.posts, @required this.onTap, this.height = 200});

  List<Post> posts;
  Function onTap;
  double height;

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

  List<Widget> carousel(List<Post> posts) => posts
      .map((post) => GestureDetector(
          child: post.mediaType == MediaType.image
              ? AspectRatio(
                aspectRatio: post.aspectRatio,
                              child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: CachedNetworkImageProvider(post.media)),
              )
              : VideoPlayerWidget(
                  url: post.media,
                  isPausable: false,
                  aspectRatio: post.aspectRatio,
                ),
          onTap: () => widget.onTap(context,post)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
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
                pauseAutoPlayOnManualNavigate: true,
                height: widget.height),
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

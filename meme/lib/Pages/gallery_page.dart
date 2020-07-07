import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class GalleryPage extends StatefulWidget {
  Function onTap;
  MediaPage page;

  GalleryPage({@required this.onTap, @required this.page});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Media selectedMedia;
  List<Media> mediaList;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    print('holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(widget.page);
    if (widget.page != null) {
      mediaList = widget.page.items;
      print(mediaList);
      selectedMedia = mediaList.first;
    provider = ExtendedMemoryImageProvider((await selectedMedia.getFile()).readAsBytesSync());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('weeeeeeeeeeeeeeeeeeeee');
    print(widget.page);
    if (widget.page == null) return Scaffold(body: Loading());

    return Scaffold(
        body: Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: MediaProvider(media: selectedMedia),
        ),
        Expanded(
          child: GridView.builder(
              itemCount: mediaList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
              itemBuilder: (context, index) {
                return GestureDetector(
                    child: MediaProvider(media: mediaList[index]),
                    onTap: () {
                      setState(() {
                        selectedMedia = mediaList[index];
                      });
                    });
              }),
        ),
      ],
    ));
  }
}

class MediaProvider extends StatelessWidget {
  Media media;
  MediaProvider({@required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.mediaType == MediaType.image)
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: MemoryImage(kTransparentImage),
        image: MediaImageProvider(
          media: media,
        ),
      );

    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: MemoryImage(kTransparentImage),
      image: MediaThumbnailProvider(
        media: media,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class GalleryPage extends StatelessWidget {
  Function onTap;
  MediaPage page;

  GalleryPage({@required this.onTap, @required this.page});
  @override
  Widget build(BuildContext context) {
    if (page == null) return Scaffold(body: Loading());
    List<Media> mediaList = page.items;
    return Scaffold(
        body: GridView.builder(
            itemCount: mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: MediaProvider(media: mediaList[index]),
                  onTap: ()=>onTap(mediaList[index]));
            }));
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

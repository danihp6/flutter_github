
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

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
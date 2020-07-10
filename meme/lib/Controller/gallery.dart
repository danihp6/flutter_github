import 'dart:io';
import 'dart:typed_data';

import 'package:media_gallery/media_gallery.dart';

class Gallery {
  Future<List<MyMedia>> getMediaGallery() async {
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );
    print(collections);
    MediaPage page = await collections.first.getMedias(
      take: 50,
    );
    return await Future.wait(page.items.map((media) => mediaToMyMedia(media)));
  }
}

Gallery gallery = Gallery();

class MyMedia {
  double _aspectRatio;

  MyMedia(aspectRatio) {
    this._aspectRatio = aspectRatio.toDouble();
  }

  get aspectRatio => this._aspectRatio;

  set aspectRatio(aspectRatio) => this._aspectRatio = aspectRatio;
}

class ImageMedia extends MyMedia {
  Uint8List _image;

  ImageMedia(image, aspectRatio) : super(aspectRatio) {
    this._image = image;
  }

  get image => this._image;
  set image(image) => this._image = image;
}

class VideoMedia extends MyMedia {
  File _video;
  Uint8List _thumbnail;

  VideoMedia(video, thumbnail, aspectRatio) : super(aspectRatio) {
    this._video = video;
    this._thumbnail = thumbnail;
  }

  File get video => this._video;

  get thumbnail => this._thumbnail;
}

Future<MyMedia> mediaToMyMedia(Media media) async {
  if (media.mediaType == MediaType.image)
    return ImageMedia(await (await media.getFile()).readAsBytes(),1);
  else
    return VideoMedia(await media.getFile(), await media.getThumbnail(),1);
}

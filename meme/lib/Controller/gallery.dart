import 'dart:io';
import 'dart:typed_data';

import 'package:media_gallery/media_gallery.dart';

const int NEXT_PAGE = 50;

class Gallery {
  List<MediaCollection> _mediaCollections;

  List<MyMediaCollection> _collections = [MyMediaCollection('Images'),MyMediaCollection('Videos')];

  List<MyMediaCollection> get collections => this._collections;

  getMediaGallery() async {
    _mediaCollections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );

    // _collections = _mediaCollections
    //     .map((collection) => MyMediaCollection(collection.name))
    //     .toList();

    await loadMedia(0);
  }

  changeCollection(int index) async {
    if (_collections[index].pagination == 0) await loadMedia(index);
  }

  Future loadMedia(int index) async {
    _collections[index].media.addAll(await Future.wait(
        (await _mediaCollections.first.getMedias(
          mediaType: index == 0 ? MediaType.image:MediaType.video,
                skip: _collections[index]._pagination,
                take: _collections[index]._pagination + NEXT_PAGE))
            .items
            .map((media) => mediaToMyMedia(media))));
    _collections[index]._pagination += NEXT_PAGE;
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

class MyMediaCollection {
  int _pagination;
  List<MyMedia> _media;
  String _name;

  MyMediaCollection(name) {
    this._name = name;
    this._pagination = 0;
    this._media = [];
  }

  int get pagination => this._pagination;

  List<MyMedia> get media => this._media;

  set media(List<MyMedia> media) => this._media = media;

  String get name => this._name;
}

Future<MyMedia> mediaToMyMedia(Media media) async {
  if (media.mediaType == MediaType.image)
    return ImageMedia(await (await media.getFile()).readAsBytes(), 1);
  else
    return VideoMedia(await media.getFile(), await media.getThumbnail(), 1);
}

import 'package:media_gallery/media_gallery.dart';

class Gallery {
  MediaPage _imagePage;
  MediaPage _videoPage;

  get imagePage => _imagePage;

  set imagePage(imagePage) => _imagePage = imagePage;

  get videoPage => _videoPage;

  set videoPage(videoPage) => _videoPage = videoPage;

  Future getMediaGallery() async {
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );
    _imagePage = await collections.first.getMedias(
      mediaType: MediaType.image,
      take: 50,
    );
    _videoPage = await collections.first.getMedias(
      mediaType: MediaType.video,
      take: 50,
    );
  }
}

Gallery gallery = Gallery();
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/image_functions.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/thumbnail_video.dart';
import 'package:meme/Widgets/video_player.dart';

class GalleryPage extends StatefulWidget {
  Function onTap;
  String mediaType;
  GalleryPage({@required this.onTap,this.mediaType = 'image'});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  MediaPage imagePage;
  MediaPage videoPage;

  Future getMediaGallery() async {
    final List<MediaCollection> collections =
        await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );
    imagePage = await collections.first.getMedias(
      mediaType: MediaType.image,
      take: 50,
    );
    videoPage = await collections.first.getMedias(
      mediaType: MediaType.video,
      take: 50,
    );
  }

  @override
  void initState() {
    getMediaGallery().then((_) {setState(() {
      
    });});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Media> medias = widget.mediaType=='image'? imagePage.items:videoPage.items;
    return Scaffold(
        body: GridView.builder(
      itemCount: medias.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return FutureBuilder(
            future: medias[index].getFile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              File file = snapshot.data;
              String mediaType = medias[index].mediaType == MediaType.image
                  ? 'image'
                  : 'video';
              return Padding(
                padding: const EdgeInsets.all(1),
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      child: mediaType == 'image'
                          ? Image.file(file, fit: BoxFit.cover)
                          : ThumbnailVideoWidget(
                              video: file,
                            ),
                      onTap: () => widget.onTap(file, mediaType),
                    )),
              );
            });
      },
    ));
  }
}

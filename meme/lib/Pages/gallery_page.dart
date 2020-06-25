import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/thumbnail_video.dart';
import 'package:meme/Widgets/video_player.dart';

class GalleryPage extends StatelessWidget {
  Function onTap;
  GalleryPage({@required this.onTap});

   MediaPage imagePage;
   MediaPage videoPage;

  Future<List<Media>> getMediaGalerry() async {
    final List<MediaCollection> collections = await MediaGallery.listMediaCollections(
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
    return imagePage.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getMediaGalerry(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            List<Media> mediaList = snapshot.data;
            return GridView.builder(
              itemCount: mediaList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: mediaList[index].getFile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      File file = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(1),
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              child: mediaList[index].mediaType==MediaType.image?Image.file(file, fit: BoxFit.cover):ThumbnailVideoWidget(video: file,),
                              onTap: () => onTap(file),
                            )),
                      );
                    });
              },
            );
          }),
    );
  }
}

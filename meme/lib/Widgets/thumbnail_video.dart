import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailVideoWidget extends StatelessWidget {
  File video;
  ThumbnailVideoWidget({@required this.video});

  @override
  Widget build(BuildContext context) {
    Future<File> genThumbnailFile() async {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: video.path,
        imageFormat: ImageFormat.WEBP,
        quality: 25,
      );
      return File(thumbnail);
    }

    return FutureBuilder(
        future: genThumbnailFile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return Loading();
          File file = snapshot.data;
          return Image.file(file, fit: BoxFit.cover);
        });
  }
}

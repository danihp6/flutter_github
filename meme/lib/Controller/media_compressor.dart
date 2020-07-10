import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:meme/Controller/gallery.dart';

class MediaCompressor {
  final _videoCompressor = FlutterVideoCompress();

  Future<void> compress(MyMedia media) async {
    if(media is ImageMedia){
      ImageMedia imageMedia = media;
      imageMedia.image = await _compressImage(imageMedia.image);
    } else{
      VideoMedia videoMedia = media;
      await _compressVideo(videoMedia.video.path);
    }
  }

  Future<Uint8List> _compressImage(Uint8List image) async {
    return await FlutterImageCompress.compressWithList(image,
        format: CompressFormat.jpeg,
        minHeight: 1080,
        minWidth: 1080,
        quality: 80);
  }

  Future<String> _compressVideo(String path) async {
    return (await FlutterVideoCompress()
            .compressVideo(path, quality: VideoQuality.DefaultQuality))
        .path;
  }
}

MediaCompressor mediaCompressor = MediaCompressor();
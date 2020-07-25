import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meme/Controller/datetime_functions.dart';
import 'package:path_provider/path_provider.dart';

class Downloader {
  Future initialize({bool debug = true}) async {
    await FlutterDownloader.initialize(
        debug: debug // optional: set false to disable printing logs to console
        );
  }

  Future download(String url) async {
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.parent.parent.parent.parent.path}/Meme';
    print(dirPath);
    await Directory(dirPath).create(recursive: true);
    final String fileName = '${timestamp()}.jpeg';
    
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dirPath,
      fileName: fileName,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }
}

Downloader downloader = Downloader();
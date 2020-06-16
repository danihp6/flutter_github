import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery/image_gallery.dart';
import 'package:meme/Controller/image_functions.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class ImagesGalleryPage extends StatefulWidget {
  @override
  _ImagesGalleryPageState createState() => _ImagesGalleryPageState();
}

class _ImagesGalleryPageState extends State<ImagesGalleryPage> {
  var images;

      @override
    void initState() {
      super.initState();
      FlutterGallaryPlugin.getAllImages.then((value){ 
        setState(() {
          images = value;
        });
        });
    }

  @override
  Widget build(BuildContext context) {

    onSelectFile(File file) async {
      File cropedImage = await cropImage(file);
      if (cropedImage != null)
        Navigator.push(context,
            SlideLeftRoute(page: UploadPublicationPage(file: cropedImage)));
    }

    if (images == null) return Container();
    images = List<String>.from(images['URIList']);

    return GridView.builder(
      itemCount: images.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        File file = File(images[index]);
        return Padding(
          padding: const EdgeInsets.all(1),
          child: SizedBox(
              width: 50,
              height: 50,
              child: GestureDetector(
                child: Image.file(file, fit: BoxFit.cover),
                onTap: () => onSelectFile(file),
              )),
        );
      },
    );
  }
}

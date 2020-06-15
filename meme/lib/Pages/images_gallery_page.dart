import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery/image_gallery.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class ImagesGalleryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    
      Future<File> cropImage(image) async {
      return await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            title: '',
          ));
    }

    onSelectFile(File file) async {
      File cropedImage = await cropImage(file);
      if(file!=null)
      Navigator.push(context, SlideLeftRoute(page:UploadPublicationPage(file: cropedImage)));
    }
    
    return FutureBuilder(
          future: FlutterGallaryPlugin.getAllImages,
          builder: (context,snapshot){
            if(snapshot.hasError)print(snapshot.error);
            if(!snapshot.hasData)CircularProgressIndicator();
            List<String> images = List<String>.from(snapshot.data['URIList']);
            return GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context,index){
                File file = File(images[index]);
                return Padding(
                  padding: const EdgeInsets.all(1),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      child: Image.file(file,fit:BoxFit.cover),
                      onTap: ()=>onSelectFile(file),
                      )
                    ),
                );
              },
            );
          },
        );
  }
}
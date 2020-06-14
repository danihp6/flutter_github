import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Pages/publication_upload_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class GalleryPublicationButton extends StatefulWidget {
  @override
  _GalleryPublicationButtonState createState() =>
      _GalleryPublicationButtonState();
}

class _GalleryPublicationButtonState extends State<GalleryPublicationButton> {
  File image;
  @override
  Widget build(BuildContext context) {
    Future<void> cropImage(image) async {
      image = await ImageCropper.cropImage(
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
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: '',
          )).then((image){ if(image!=null)Navigator.push(context, SlideLeftRoute(page:PublicationUploadPage(image: image,)));});
    }

      Future<void> selectImage() async {
        PickedFile pickedImage =
            await ImagePicker().getImage(source: ImageSource.gallery);
        cropImage(pickedImage);
      }

      return FloatingActionButton(
        heroTag: 'galleryPublication',
        onPressed: selectImage,
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.image),
      );
    }
}

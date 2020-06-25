import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/image_functions.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/gallery_page.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class SelectImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    onSelectFile(File file) async {
      File cropedImage = await cropImage(file);
      if (cropedImage != null)
        Navigator.push(context,
            SlideLeftRoute(page: UploadPublicationPage(file: cropedImage)));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Nuevo post'),
        ),
        body: TabBarView(
          children: [
            GalleryPage(
              onTap: onSelectFile,
            ),
            CameraPage()
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.grey[300],
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.image,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.camera,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

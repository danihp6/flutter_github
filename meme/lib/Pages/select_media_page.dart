import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/image_functions.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/gallery_page.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class SelectMediaPage extends StatefulWidget {
  @override
  _SelectMediaPageState createState() => _SelectMediaPageState();
}

class _SelectMediaPageState extends State<SelectMediaPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  String mediaType = 'image';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    onSelectFile(File file, String mediaType) async {
      print(mediaType == 'video');
      if (mediaType == 'image') {
        File cropedImage = await cropImage(file);
        if (cropedImage != null)
          Navigator.push(context,
              SlideLeftRoute(page: UploadPublicationPage(file: cropedImage,mediaType:mediaType)));
      }
      if(mediaType == 'video'){
        Navigator.push(context,
              SlideLeftRoute(page: UploadPublicationPage(file: file,mediaType:mediaType)));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Nuevo post'),
        actions: <Widget>[
          if(tabController.index == 0)
          IconButton(
            icon: Icon(Icons.image),
            onPressed:(){
              setState(() {
                mediaType == 'image'? mediaType = 'video':mediaType = 'image';
                print(mediaType);
              });
            } ,
          )
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GalleryPage(onTap: onSelectFile,mediaType: mediaType,
          ),
          CameraPage()
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: TabBar(
          controller: tabController,
          onTap: (index){setState(() {
            
          });},
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
    );
  }
}

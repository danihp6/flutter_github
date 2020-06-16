import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/images_gallery_page.dart';

class SelectImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Text('Nueva publicación'),
          ),
          body: TabBarView(
            children: [
              ImagesGalleryPage(),
              CameraPage()
              ],
          ),
          bottomNavigationBar: Container(
            color: Colors.grey[300],
            child: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.image,size: 30,color: Colors.black,),
                ),
                Tab(
                  icon: Icon(Icons.camera,size: 30,color: Colors.black,),
                ),
              ],
            ),
          ),


          ),
    );
  }
}

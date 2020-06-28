import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/image_functions.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/gallery_page.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/gallery.dart';

class SelectMediaPage extends StatefulWidget {
  @override
  _SelectMediaPageState createState() => _SelectMediaPageState();
}

class _SelectMediaPageState extends State<SelectMediaPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  MediaPage page;
  IconData icon = Icons.image;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    gallery.getMediaGallery().then((_) {
       setState(() {
         page = gallery.imagePage;
       });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    onSelectMedia(Media media) async {
      File file = await media.getFile();
      if (media.mediaType == MediaType.image) {
        File cropedImage = await cropImage(file);
        if (cropedImage != null)
          Navigator.push(
              context,
              SlideLeftRoute(
                  page: UploadPublicationPage(
                      file: cropedImage, mediaType: 'image')));
      } else
        Navigator.push(
            context,
            SlideLeftRoute(
                page: UploadPublicationPage(file: file, mediaType: 'video')));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Nuevo post'),
          actions: <Widget>[
            if (tabController.index == 0)
              IconButton(
                icon: Icon(icon),
                onPressed: () {
                  setState(() {
                    page = page == gallery.imagePage
                        ? gallery.videoPage
                        : gallery.imagePage;
                    icon = icon == Icons.image ? Icons.slideshow : Icons.image;
                    print(icon);
                  });
                },
              )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GalleryPage(
            onTap: onSelectMedia,
            page: page,
          ),
          CameraPage()
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        child: SizedBox(
          height: 40,
          child: TabBar(
            controller: tabController,
            onTap: (index) {
              setState(() {});
            },
            tabs: [
              Tab(
                icon: Icon(
                  icon,
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

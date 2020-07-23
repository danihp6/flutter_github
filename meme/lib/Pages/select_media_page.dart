import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Pages/camera_page.dart';
import 'package:meme/Pages/gallery_page.dart';
import 'package:meme/Pages/template_page.dart';

class SelectMediaPage extends StatefulWidget {
  @override
  _SelectMediaPageState createState() => _SelectMediaPageState();
}

class _SelectMediaPageState extends State<SelectMediaPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  MediaPage page;
  

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(

      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          GalleryPage(
            onMediaSelected: navigator.goUploadPublication
          ),
          TemplatePage(),
          CameraPage(),
          
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
                  Icons.image,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.filter_frames,
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

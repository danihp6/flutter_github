import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/PostList.dart';
import '../Widgets/tag_selector.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'gallery_page.dart';

class NewPostListPage extends StatefulWidget {
  @override
  _NewPostListPageState createState() => _NewPostListPageState();
}

class _NewPostListPageState extends State<NewPostListPage> {
  String _name = '';
  File _file;
  String _image = '';
  String _imageLocation = '';

  @override
  void initState() {
    gallery.getMediaGallery().then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future createPostList() async {
      if (_name != '') {
        db.newPostList(
            db.userId,
            new PostList(_name, _image, _imageLocation, <String>[], db.userId,
                DateTime.now()),
            _file);
        Navigator.pop(context);
      }
    }

    selectImage(File file) {
      setState(() {
        _file = file;
      });
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva categoria'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Nombre de la lista'),
                  autofocus: true,
                  onChanged: (value) => _name = value,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: _file != null
                        ? Expanded(child: Image.file(_file))
                        : Container(),
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    SlideLeftRoute(
                        page: GalleryPage(
                            onTap: selectImage, page: gallery.imagePage))),
              ),
              Text('Selecciona una imagen'),
              SizedBox(height: 30),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text('Crear categoria'),
                onPressed: createPostList,
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'images_gallery_page.dart';

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
  Widget build(BuildContext context) {

    Future createPostList() async {
      if (_name != '') {
        if(_file != null){
          var map = await uploadMedia(_file);
          _image = map['media'];
          _imageLocation = map['location'];
        }
        newPostList(configuration.getUserId(),
            new PostList(_name, _image,_imageLocation, <String>[], configuration.getUserId()));
        Navigator.pop(context);
      }
    }

    selectImage(File file){
      print(_file);
      setState(() {
        _file = file;
      });
      print(_file);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva categoria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                          child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[300],
                  child: _file!=null?Expanded(child:Image.file(_file)):Container(),
                  
                ),
              ),
              onTap: ()=>Navigator.push(context, SlideLeftRoute(page:ImagesGalleryPage(onTap: selectImage))),
            ),
            Text('Selecciona una imagen'),
            SizedBox(height: 10,),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre de la lista'
                ),
                autofocus: true,
                onChanged: (value) => _name = value,
              ),
            ),
            SizedBox(height: 30),
            RaisedButton(
              child: Text('Crear categoria'),
              onPressed: createPostList,
            )
          ],
        ),
      ),
    );
  }
}
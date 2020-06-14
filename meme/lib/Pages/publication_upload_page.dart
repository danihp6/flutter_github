import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Publication.dart';
import '../Controller/storage.dart';

class PublicationUploadPage extends StatefulWidget {
  File image;
  PublicationUploadPage({this.image});

  @override
  _PublicationUploadPageState createState() => _PublicationUploadPageState();
}

class _PublicationUploadPageState extends State<PublicationUploadPage> {
  File _image;
  String _description = '';
  @override
  Widget build(BuildContext context) {
    _image = widget.image;

    uploadPublication() {
      uploadImage(_image).then((map) => newPublication(
          configuration.getUserId(),
          new Publication(map['image'], configuration.getUserId(), _description, <String>[],
              DateTime.now(),map['url'])));
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Nueva publicación'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(_image),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descripción',
                ),
                onChanged: (description) {
                  setState(() {
                    _description = description;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: uploadPublication,
              child: Text(
                'Subir',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

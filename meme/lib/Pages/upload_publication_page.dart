import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/Publication.dart';

class UploadPublicationPage extends StatefulWidget {
  File file;

  UploadPublicationPage({@required this.file});

  @override
  _UploadPublicationPageState createState() => _UploadPublicationPageState();
}

class _UploadPublicationPageState extends State<UploadPublicationPage> {
  File _file;
  String _description = '';


  @override
  Widget build(BuildContext context) {
    _file = widget.file;
    uploadPublication() {
      uploadImage(_file).then((map) => newPublication(
          configuration.getUserId(),
          new Publication(map['image'], configuration.getUserId(), _description,
              <String>[], DateTime.now(), map['url'])));
      Navigator.pop(context);
      Navigator.pop(context);
    }

    return SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.file(_file),
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
      ),
    );
  }
}

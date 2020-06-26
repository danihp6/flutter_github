import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Widgets/video_player.dart';
import '../Widgets/tag_selector.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import '../Models/Post.dart';

class UploadPublicationPage extends StatefulWidget {
  File file;
  String mediaType;

  UploadPublicationPage({@required this.file, @required this.mediaType});

  @override
  _UploadPublicationPageState createState() => _UploadPublicationPageState();
}

class _UploadPublicationPageState extends State<UploadPublicationPage> {
  File _file;
  String _description = '';
  List<String> keyWords = <String>[];

  @override
  Widget build(BuildContext context) {
    _file = widget.file;
    uploadPublication() {
      mediaStorage.uploadMedia(_file).then((map) => db.newPost(
          db.userId,
          new Post(map['media'], _description, widget.mediaType, <String>[],
              DateTime.now(), map['location'], db.userId, keyWords)));
      Navigator.pop(context);
      Navigator.pop(context);
    }

    void addKeyWord(String value) {
      setState(() {
        keyWords.add(value.toLowerCase());
      });
    }

    void removeKeyWord(int index) {
      setState(() {
        keyWords.removeAt(index);
      });
    }

    print(widget.mediaType);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.mediaType == 'image'
                  ? Image.file(_file)
                  : VideoPlayerWidget(file: _file),
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
              TagSelector(
                tags: keyWords,
                onFieldSubmitted: addKeyWord,
                onClearTag: removeKeyWord,
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

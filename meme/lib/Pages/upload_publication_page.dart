import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Widgets/loading.dart';
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
  List<Tag> tags = <Tag>[];
  bool activedUpload;

  @override
  void initState() {
    activedUpload = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _file = widget.file;
    uploadPublication() async {
      setState(() {
        activedUpload = false;
      });

      List<String> tagsId = await db.createTags(tags);
      String postId = await db.newPost(
          db.userId,
          new Post('', _description, widget.mediaType, <String>[],
              DateTime.now(), '', db.userId, tagsId, Map<String, dynamic>()),
          _file);
      tagsId.forEach((id) {
        db.addPostToTag(id,db.userId,postId );
      });
      Navigator.pop(context);
      Navigator.pop(context);
    }

    void addKeyWord(String value) {
      if (tags.length < 5)
        setState(() {
          tags.add(Tag(value.toLowerCase(), <String>[]));
        });
    }

    void removeKeyWord(int index) {
      setState(() {
        tags.removeAt(index);
      });
    }

    print(widget.mediaType);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.mediaType == 'image'
                  ? AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(_file, fit: BoxFit.cover))
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
                tags: tags,
                onFieldSubmitted: addKeyWord,
                onClearTag: removeKeyWord,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: activedUpload
                          ? () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 100,
                    child: RaisedButton(
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      onPressed: activedUpload ? uploadPublication : null,
                      child: Text(
                        'Subir',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              if (!activedUpload)
                Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Loading(),
                    SizedBox(height: 10),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

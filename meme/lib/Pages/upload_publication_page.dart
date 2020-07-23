import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:meme/Widgets/template_row.dart';
import '../Widgets/video_player.dart';

import '../Models/Post.dart';
import '../Widgets/tag_selector.dart';

class UploadPublicationPage extends StatefulWidget {
  MyMedia media;
  Template template;
  UploadPublicationPage({@required this.media, this.template});

  @override
  _UploadPublicationPageState createState() => _UploadPublicationPageState();
}

class _UploadPublicationPageState extends State<UploadPublicationPage> {
  MyMedia _media;
  String _description = '';
  List<Tag> tags = <Tag>[];
  bool activedUpload;

  @override
  void initState() {
    _media = widget.media;
    activedUpload = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uploadPublication() async {
      setState(() {
        activedUpload = false;
      });

      List<String> tagsId = await db.createTags(tags);
      String postId = await db.newPost(
          db.userId,
          new Post(
              '',
              _description,
              _media is ImageMedia ? MediaType.image : MediaType.video,
              <String>[],
              '',
              db.userId,
              tagsId,
              Map<String, dynamic>(),
              _media.aspectRatio,
              widget.template.id),
          _media);
      tagsId.forEach((id) {
        db.addPostToTag(id, db.userId, postId);
      });
      navigator.pop(context);
      navigator.pop(context);
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

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            title: Text('Subir'),
          ),
        ),
        body: ScrollColumnExpandable(
          children: <Widget>[
            _media is ImageMedia
                ? AspectRatio(
                    aspectRatio: _media.aspectRatio,
                    child: Image.memory(
                      (_media as ImageMedia).image,
                      fit: BoxFit.cover,
                    ))
                : VideoPlayerWidget(
                    file: (_media as VideoMedia).video,
                    aspectRatio: _media.aspectRatio,
                  ),
            if (widget.template != null)
              TemplateRow(template: widget.template),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TagSelector(
                        tags: tags,
                        onFieldSubmitted: addKeyWord,
                        onClearTag: removeKeyWord,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            child: RaisedButton(
                              color: Colors.red,
                              onPressed: activedUpload
                                  ? () {
                                      navigator.pop(context);
                                      navigator.pop(context);
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
                              onPressed:
                                  activedUpload ? uploadPublication : null,
                              child: Text(
                                'Subir',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
import '../Widgets/video_player.dart';

import '../Models/Post.dart';
import '../Widgets/tag_selector.dart';

class UploadPublicationPage extends StatefulWidget {
  Function futureMedia;
  Template template;
  UploadPublicationPage({@required this.futureMedia, this.template});

  @override
  _UploadPublicationPageState createState() => _UploadPublicationPageState();
}

class _UploadPublicationPageState extends State<UploadPublicationPage> {
  MyMedia _media;
  String _description = '';
  List<Tag> tags = <Tag>[];
  String tag = '';
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    getMedia();
    if (widget.template != null) tags.add(Tag(widget.template.name));
    super.initState();
  }

  Future getMedia() async {
    _media = await widget.futureMedia();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future uploadPublication() async {
      List<String> tagsId = await db.createTags(tags);
      print('-----------------TAGS');
      print(tagsId);
      Post post = Post(
          '',
          _description,
          _media is ImageMedia ? MediaType.image : MediaType.video,
          <String>[],
          db.userId,
          tagsId,
          Map<String, dynamic>(),
          _media.aspectRatio,
          widget.template != null ? widget.template.id : null);

      String postId = await db.newPost(db.userId, post, _media);

      tagsId.forEach((id) {
        db.addPostToTag(id, db.userId, postId);
      });
      print('-----------------TAGS');
      print(tagsId);
    }

    setTag(String text) {
      setState(() {
        tag = text;
      });
    }

    void addKeyWord() {
      if (tags.length < 5)
        setState(() {
          tags.add(Tag(tag.toLowerCase()));
          tag = '';
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
        body: _media != null
            ? ScrollColumnExpandable(
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
                          Divider(
                            indent: 50,
                            endIndent: 50,
                          ),
                          TagSelector(
                              tags: tags,
                              onFieldSubmitted: addKeyWord,
                              onClearTag: removeKeyWord,
                              tag: tag,
                              setTag: setTag,
                              focusNode: focusNode),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.clear, size: 50),
                                      onPressed: () {
                                        navigator.pop(context);
                                        navigator.pop(context);
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.file_upload,
                                        size: 50,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () async {
                                        focusNode.unfocus();
                                        if (tag.isNotEmpty)
                                          await showModalTag(
                                              context, addKeyWord);
                                        uploadPublication();
                                        navigator.pop(context);
                                        navigator.pop(context);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Loading(),
      ),
    );
  }

  Future showModalTag(BuildContext context, void addKeyWord()) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Añadir el tag:',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                  '#$tag',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        iconSize: 30,
                        color: Colors.red,
                        icon: Icon(Icons.clear),
                        onPressed: () => Navigator.pop(context)),
                    IconButton(
                        iconSize: 30,
                        color: Theme.of(context).accentColor,
                        icon: Icon(Icons.done),
                        onPressed: () {
                          addKeyWord();
                          Navigator.pop(context);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }
}

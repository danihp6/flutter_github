import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import '../Models/Post.dart';

class UploadPublicationPage extends StatefulWidget {
  File file;

  UploadPublicationPage({@required this.file});

  @override
  _UploadPublicationPageState createState() => _UploadPublicationPageState();
}

class _UploadPublicationPageState extends State<UploadPublicationPage> {
  File _file;
  String _description = '';
  List<String> keyWords = [];
  TextEditingController keyWordsController;

  @override
  void initState() {
    super.initState();
    keyWordsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _file = widget.file;
    uploadPublication() {
      uploadMedia(_file).then((map) => newPost(
          configuration.getUserId(),
          new Post(map['media'], _description, <String>[], DateTime.now(),
              map['location'], configuration.getUserId(), keyWords)));
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
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tags',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear), 
                        onPressed: (){
                          setState(() {
                            keyWordsController.clear();
                          });
                        }
                        )),
                  onFieldSubmitted: (value) {
                    setState(() {
                      keyWords.add(value.toLowerCase());
                      keyWordsController.clear();
                    });
                  },
                  controller: keyWordsController,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 25,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: keyWords.length,
                    separatorBuilder: (context, index) => SizedBox(
                      width: 6,
                    ),
                    itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Text(keyWords[index]),
                              SizedBox(
                                width: 20,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 20,
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      keyWords.removeAt(index);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        )),
                  )),
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

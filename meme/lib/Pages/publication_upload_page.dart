

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PublicationUploadPage extends StatelessWidget {
  String userId;
  PublicationUploadPage({this.userId});

  @override
  Widget build(BuildContext context) {
    Future<void> selectFile() async {
      PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva publicación'),
      ),
      body: Column(
        children: [
          RaisedButton(
            onPressed: selectFile,
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Pages/publication_upload_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class NewPublicationButton extends StatelessWidget {
  Function openPublicationOptions;
  NewPublicationButton({this.openPublicationOptions});

  @override
  Widget build(BuildContext context) {


    return FloatingActionButton(
      heroTag: 'newPublication',
      onPressed: openPublicationOptions,
      backgroundColor: Colors.deepOrange,
      child: Icon(Icons.file_upload),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/publication_description_widget.dart';
import 'package:meme/Widgets/publication_header.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PublicationWidget extends StatefulWidget {
  Publication publication;
  PublicationWidget({this.publication});

  @override
  _PublicationWidgetState createState() => _PublicationWidgetState();
}

class _PublicationWidgetState extends State<PublicationWidget> {
  bool _isShowedComments;
  Publication _publication;

  @override
  Widget build(BuildContext context) {
    _isShowedComments = configuration.getIsShowedComments();
    _publication = widget.publication;

    return Container(
      child: Column(children: [
        if(_isShowedComments)
        Padding(
          padding: const EdgeInsets.only(left:8),
          child: PublicationHeaderWidget(publication: _publication,),
        ),
        Image.network(
          _publication.getImage(),
          fit: BoxFit.contain,
        ),
        if (_isShowedComments)
          Padding(
            padding: const EdgeInsets.only(right: 15,left:15,top: 10),
            child: PublicationDescriptionWidget(publication: _publication),
          )
      ]),
    );
  }
}


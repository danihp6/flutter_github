import 'package:flutter/material.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Widgets/publication.dart';

class CategoryPublicationList extends StatelessWidget {
  CategoryPublicationList({
    @required this.publications,
  });

  List<Publication> publications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: publications.length,
        itemBuilder: (BuildContext context, int index) {
          return PublicationWidget(publication: publications[index]);
        });
  }
}

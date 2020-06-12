import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Widgets/publication.dart';
import '../Widgets/floating_buttons.dart';

class FavouriteCategoryPage extends StatefulWidget {
  FavouriteCategory favouriteCategory;
  FavouriteCategoryPage({this.favouriteCategory});

  @override
  _FavouriteCategoryPageState createState() => _FavouriteCategoryPageState();
}

class _FavouriteCategoryPageState extends State<FavouriteCategoryPage> {
  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
    return Scaffold(
      floatingActionButton: FloatingButtons(refresh: (){setState(() {});},),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                AppBar(
                  title: Text(_favouriteCategory.getName()),
                  backgroundColor: Colors.deepOrange,
                  elevation: 0,
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(height:80,child: Image.network(_favouriteCategory.getImage())),
                      Text(_favouriteCategory.getName())
                    ],
                  ),
                )
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert), 
                onPressed: (){}
                )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              var publications = _favouriteCategory.getPublications();
              return Column(
                children: [
                  if(index!=0 && !configuration.getIsShowedComments()) SizedBox(height: 10,),
                  PublicationWidget(publication: publications[index],),
                ],
              );
            }, childCount: _favouriteCategory.getPublications().length),
          )
        ]));
  }
}

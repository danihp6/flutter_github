import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/publication.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:meme/Widgets/new_favourite_category.dart';

class FavouritesCategoriesList2 extends StatefulWidget {
  List<FavouriteCategory> favouritesCategories;

  FavouritesCategoriesList2({this.favouritesCategories});

  @override
  _FavouritesCategoriesListState2 createState() =>
      _FavouritesCategoriesListState2();
}

class _FavouritesCategoriesListState2 extends State<FavouritesCategoriesList2> {

  @override
  Widget build(BuildContext context) {
    List<FavouriteCategory> favouritesCategories = widget.favouritesCategories;
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                child: Column(
                  children: [
                    Text(favouritesCategories[index].getName()),
                  ],
                ),
              );
            },
            childCount: favouritesCategories.length,
          ),
        )
      ],
    );
  }
}

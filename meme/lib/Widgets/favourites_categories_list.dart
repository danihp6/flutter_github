import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/new_favourite_category.dart';

class FavouritesCategoriesList extends StatefulWidget {
  List<FavouriteCategory> favouritesCategories;

  FavouritesCategoriesList({this.favouritesCategories});

  @override
  _FavouritesCategoriesListState createState() =>
      _FavouritesCategoriesListState();
}

class _FavouritesCategoriesListState extends State<FavouritesCategoriesList> {
  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    itemCount: widget.favouritesCategories.length,
    itemBuilder: (BuildContext context, int index) {
      return FavouriteCategoryWidget(
          favouriteCategory: widget.favouritesCategories[index],
        );
    });
  }
}

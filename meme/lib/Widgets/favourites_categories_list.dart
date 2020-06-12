import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:meme/Widgets/new_favourite_category.dart';

class FavouritesCategoriesList extends StatefulWidget {
  List<FavouriteCategory> favouritesCategories;
  int indexSelectioned;
  Function setIndexSelectioned;

  FavouritesCategoriesList({this.favouritesCategories,this.indexSelectioned,this.setIndexSelectioned});

  @override
  _FavouritesCategoriesListState createState() =>
      _FavouritesCategoriesListState();
}

class _FavouritesCategoriesListState extends State<FavouritesCategoriesList> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionListener =
      ItemPositionsListener.create();
  int _indexSelectioned;
  

  @override
  Widget build(BuildContext context) {
    _indexSelectioned = widget.indexSelectioned;
    return ScrollablePositionedList.builder(
    physics: _indexSelectioned==-1? AlwaysScrollableScrollPhysics():NeverScrollableScrollPhysics(),
    itemScrollController: itemScrollController,
    itemPositionsListener: itemPositionListener,
    itemCount: widget.favouritesCategories.length,
    itemBuilder: (BuildContext context, int index) {
      Function jumpToMyIndex =
          () => itemScrollController.jumpTo(index: index);
      bool isSelectedCategory = index == _indexSelectioned;
      Function selectCategory = () {
        if(isSelectedCategory) widget.setIndexSelectioned(-1);
        else widget.setIndexSelectioned(index);
        jumpToMyIndex();
      };
      return FavouriteCategoryWidget(
          favouriteCategory: widget.favouritesCategories[index],
          selectCategory: selectCategory,
          isSelectedCategory: isSelectedCategory,
        );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Widgets/category_publication_list.dart';
import 'package:meme/Widgets/publication.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Models/FavouriteCategory.dart';
import '../Models/Publication.dart';

class FavouriteCategoryWidget2 extends StatefulWidget {
  FavouriteCategory favouriteCategory;
  ItemScrollController itemScrollController;
  Function selectCategory;
  bool isSelectedCategory;
  FavouriteCategoryWidget2(
      {this.favouriteCategory, this.selectCategory, this.isSelectedCategory});

  @override
  _FavouriteCategoryWidgetState2 createState() =>
      _FavouriteCategoryWidgetState2();
}

class _FavouriteCategoryWidgetState2 extends State<FavouriteCategoryWidget2> {
  bool _isSelected = false;

  Widget _buidTiles(FavouriteCategory favouriteCategory){
    var publications = favouriteCategory.getPublications();
    if(favouriteCategory.children.isEmpty)return ListTile(
      title: Text(root.title),
      leading: Icon(Icons.arrow_forward_ios),
      onTap: ()=>Navigator.of(_context).push(_NewPage(root.page)),
      );
    return ExpansionTileCustom(
      leading: Icon(Icons.folder),
      key: PageStorageKey<Entry>(root),
      title:Text(root.title),
      children: root.children.map(_buidTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
    _isSelected = widget.isSelectedCategory;
    IconData _icon =
        _isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;
    List<Publication> publications = _favouriteCategory.getPublications();

    
  }
  }
}

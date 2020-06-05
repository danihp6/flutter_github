import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Widgets/category_publication_list.dart';
import 'package:meme/Widgets/publication.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FavouriteCategoryWidget extends StatefulWidget {
  FavouriteCategory favouriteCategory;
  ItemScrollController itemScrollController;
  Function selectCategory;
  bool isSelectedCategory;
  FavouriteCategoryWidget(
      {this.favouriteCategory, this.selectCategory, this.isSelectedCategory});

  @override
  _FavouriteCategoryWidgetState createState() =>
      _FavouriteCategoryWidgetState();
}

class _FavouriteCategoryWidgetState extends State<FavouriteCategoryWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
    _isSelected = widget.isSelectedCategory;
    IconData _icon =
        _isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;
    List<Publication> publications = _favouriteCategory.getPublications();
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 70,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey[300],
                    child: Image.network(_favouriteCategory.getImage()),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _favouriteCategory.getName(),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Icon(_icon)]),
                  )
                ],
              ),
            ),
            onTap: widget.selectCategory,
          ),
          _isSelected
              ? Container(
                height: 2000,
                  child: CategoryPublicationList(publications: publications),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

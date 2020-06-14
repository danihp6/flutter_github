import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'slide_left_route.dart';
import '../Pages/favourite_category_page.dart';

class FavouriteCategoryWidget extends StatefulWidget {
  FavouriteCategory favouriteCategory;

  FavouriteCategoryWidget({this.favouriteCategory});

  @override
  _FavouriteCategoryWidgetState createState() =>
      _FavouriteCategoryWidgetState();
}

class _FavouriteCategoryWidgetState extends State<FavouriteCategoryWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 70,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              color: Colors.grey[300],
              child: _favouriteCategory.getImage() != ''
                  ? Image.network(_favouriteCategory.getImage())
                  : null,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _favouriteCategory.getName(),
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  _favouriteCategory.getPublications().length.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(),
            _favouriteCategory.getName()!='Subidas'?Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 30,
                  child: PopupMenuButton(
                    child: Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              Text('Eliminar categoria')
                            ],
                          ),
                          value: ()=>deleteFavouriteCategory(_favouriteCategory),
                        )
                      ];
                    },
                    onSelected: (function)=>function(),
                  ),
                ),
              ),
            ):Container()
          ],
        ),
      ),
      onTap: () => Navigator.of(context).push(SlideLeftRoute(
          page: FavouriteCategoryPage(favouriteCategory: _favouriteCategory))),
    );
  }
}

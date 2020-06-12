import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/favourite_header.dart';
import 'package:meme/Widgets/new_favourite_category.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../Models/Publication.dart';
import 'package:meme/Widgets/favourites_categories_list.dart';

class FavouritePage extends StatefulWidget {
  User user;
  FavouritePage({this.user});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  User _user;  

  @override
  Widget build(BuildContext context) {
    _user = widget.user;

    return SafeArea(
          child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:[
                FavouriteHeader(user: _user),
                NewFavouriteCategory(),
                Expanded(child: FavouritesCategoriesList(favouritesCategories:_user.getFavouritesCategories()))
              ]
              ),
          ),
        ),
      ),
    );
  }
}


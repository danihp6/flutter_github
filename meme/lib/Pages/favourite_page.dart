import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/favourite_header.dart';
import 'package:meme/Widgets/new_favourite_category.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../Models/Publication.dart';
import 'package:meme/Widgets/favourites_categories_list.dart';
import 'package:meme/Widgets/user_info.dart';

class FavouritePage extends StatefulWidget {

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  User _user;
  int _indexSelectioned = -1;

  

  @override
  Widget build(BuildContext context) {
    _user = UserInfo.of(context).user;

    Function setIndexSelectioned = (index){
    setState(() {
      _indexSelectioned = index;
    });
  };
    return SafeArea(
          child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:[
                if(_indexSelectioned==-1)
                FavouriteHeader(user: _user),
                if(_indexSelectioned==-1)
                NewFavouriteCategory(),
                Expanded(child: FavouritesCategoriesList(favouritesCategories:_user.getFavouritesCategories(),indexSelectioned: _indexSelectioned,setIndexSelectioned:setIndexSelectioned))
              ]
              ),
          ),
        ),
      ),
    );
  }
}

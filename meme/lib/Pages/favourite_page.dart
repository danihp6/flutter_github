import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/favourite_header.dart';
import 'package:meme/Widgets/new_favourite_category.dart';
import '../Models/Publication.dart';
import 'package:meme/Widgets/favourites_categories_list.dart';

class FavouritePage extends StatefulWidget {
  String userId;
  FavouritePage({@required this.userId});
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  String _userId;
  @override
  Widget build(BuildContext context) {
    _userId = widget.userId;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: getUser(_userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  User user = snapshot.data;
                  String publications = user.getPublications();
                  List<String> favouritesCategories =
                      user.getFavouritesCategories();
                  return Column(
                    children: [
                      FavouriteHeader(user: user),
                      NewFavouriteCategory(userId: _userId),
                      StreamBuilder(
                        stream: getFavouriteCategory(publications),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          FavouriteCategory favouriteCategory = snapshot.data;
                          return FavouriteCategoryWidget(
                            favouriteCategory: favouriteCategory,
                          );
                        },
                      ),
                      StreamBuilder(
                         stream: getFavouritesCategoriesFromUser(_userId),
                         builder: (context,snapshot){
                           if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          List<FavouriteCategory> favouritesCategories = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: favouritesCategories.length,
                            itemBuilder: (context,index){
                              return FavouriteCategoryWidget(favouriteCategory: favouritesCategories[index],);
                            },
                          );
                         },
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

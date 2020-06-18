import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/favourite_categories_list.dart';
import 'package:meme/Widgets/favourite_header.dart';
import 'package:meme/Widgets/new_favourite_category.dart';

class FavouritePage extends StatelessWidget {
  String userId;
  FavouritePage({@required this.userId});
  @override


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: getUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  User user = snapshot.data;
                  return Column(
                    children: [
                      FavouriteHeader(user: user),
                      NewFavouriteCategory(userId: userId),
                      Expanded(child: FavouritesCategoriesList(user: user)),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
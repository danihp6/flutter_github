import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_category.dart';
import 'package:meme/Widgets/slide_left_route.dart';

import 'favourite_category_page.dart';

class FavouritesCategoriesList extends StatelessWidget {
  FavouritesCategoriesList({
    @required this.user,
  });

  User user;

  @override
  Widget build(BuildContext context) {

      goToFavouriteCategory(favouriteCategory) {
    Navigator.of(context).push(SlideLeftRoute(
        page: FavouriteCategoryPage(favouriteCategory: favouriteCategory)));
  }

    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
            stream:
                getFavouriteCategory(user.getPublications()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              FavouriteCategory favouriteCategory =
                  snapshot.data;
              return FavouriteCategoryWidget(
                favouriteCategory: favouriteCategory,
                activeMoreOptions: false,
                onTap: () =>
                    goToFavouriteCategory(favouriteCategory),
              );
            },
          ),
          StreamBuilder(
            stream: getFavouriteCategory(
                user.getFavouritesPublications()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              FavouriteCategory favouriteCategory =
                  snapshot.data;
              return FavouriteCategoryWidget(
                favouriteCategory: favouriteCategory,
                activeMoreOptions: false,
                onTap: () =>
                    goToFavouriteCategory(favouriteCategory),
              );
            },
          ),
          StreamBuilder(
            stream: getFavouritesCategoriesFromUser(user.getId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData)
                return CircularProgressIndicator();
              List<FavouriteCategory> favouritesCategories =
                  snapshot.data;
              return ListView.builder(
                  itemCount: favouritesCategories.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder:
                      (BuildContext context, int index) {
                    return StreamBuilder(
                        stream: getFavouriteCategory(
                            favouritesCategories[index]
                                .getId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            print(snapshot.error);
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          FavouriteCategory
                              favouriteCategory =
                              snapshot.data;
                          return FavouriteCategoryWidget(
                            favouriteCategory:
                                favouriteCategory,
                            onTap: () =>
                                goToFavouriteCategory(
                                    favouriteCategory),
                          );
                        });
                  });
            },
          )
        ],
      ),
    );
  }
}

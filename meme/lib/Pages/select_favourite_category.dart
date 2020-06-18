import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Widgets/favourite_category.dart';

class SelectFavouriteCategory extends StatelessWidget {
  String publicationId;
  SelectFavouriteCategory({@required this.publicationId});

  @override
  Widget build(BuildContext context) {

    addPublicationAndGoBack(String favouriteCategoryId){
      addPublicationToFavouriteCategory(publicationId,favouriteCategoryId);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una lista'),
      ),
          body: StreamBuilder(
          stream: getFavouritesCategoriesFromUser(configuration.getUserId()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return CircularProgressIndicator();
            List<FavouriteCategory> favouritesCategories = snapshot.data;
            return ListView.builder(
              itemCount: favouritesCategories.length,
              itemBuilder: (context, index) {
                return FavouriteCategoryWidget(
                  favouriteCategory: favouritesCategories[index],
                  activeMoreOptions: false,
                  onTap: ()=>addPublicationAndGoBack(favouritesCategories[index].getId()),
                );
              },
            );
          }),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/select_favourite_category.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PublicationMenu extends StatelessWidget {
  Publication publication;
  User user;
  FavouriteCategory favouriteCategory;

  PublicationMenu(
      {@required this.publication,
      @required this.user,
      @required this.favouriteCategory});

  @override
  Widget build(BuildContext context) {

    deletePublicationAndImage(){
      deletePublication(publication);
      deleteImage(publication.getUrl());
    }

    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return [
          if(favouriteCategory.getName() == 'Subidos')
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.delete),
                Text('Eliminar publicación'),
              ],
            ),
            value: deletePublicationAndImage,
          ),
          if(favouriteCategory.getName() != 'Subidos' && favouriteCategory.getName() != 'Favoritos')
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.remove),
                Text('Quitar de la lista'),
              ],
            ),
            value: () => removePublicationOnFavouriteCategory(publication.getId(),favouriteCategory.getId()),
          ),
          PopupMenuItem(
            child: Row(
              children: [Icon(Icons.add), Text('Añadir a categoria')],
            ),
            value: () => Navigator.push(
                context,
                SlideLeftRoute(
                    page: SelectFavouriteCategory(
                        publicationId: publication.getId()))),
          )
        ];
      },
      onSelected: (function) => function(),
    );
  }
}
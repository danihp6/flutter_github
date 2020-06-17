import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/favourite_publication_button.dart';

class PublicationHeaderWidget extends StatelessWidget {
  Publication publication;
  FavouriteCategory favouriteCategory;
  PublicationHeaderWidget(
      {@required this.publication, @required this.favouriteCategory});

  @override
  Widget build(BuildContext context) {
    String author = publication.getAuthorId();
    print(publication.getFavourites());

    Future<void> deleteOrRemovePublication(Publication publication, User user) {
      if (publication.getAuthorId() == configuration.getUserId() &&
          favouriteCategory.getName() == 'Subidos') {
        print('borrar');
        deleteImage(publication.getUrl());
        deletePublication(publication);
      } else {
        print('remover');
        removePublicationOnFavouriteCategory(publication.getId(), user);
      }
    }

    return StreamBuilder(
        stream: getUser(author),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return CircularProgressIndicator();
          User user = snapshot.data;
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.getImage()),
              ),
              SizedBox(width: 10),
              Text(
                user.getName(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      publication.getFavourites().length.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                        stream: getUser(configuration.getUserId()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          User user = snapshot.data;
                          return Row(
                            children: [
                              FavouritePublicationButton(
                                  publicationId: publication.getId(),
                                  user: user),
                              SizedBox(
                                width: 35,
                                child: PopupMenuButton(
                                  child: Icon(Icons.more_vert),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            Text('Eliminar publicación'),
                                          ],
                                        ),
                                        value: () =>
                                            deleteOrRemovePublication(
                                                publication, user),
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {}),
                                            Text('Añadir a categoria')
                                          ],
                                        ),
                                      )
                                    ];
                                  },
                                  onSelected: (function) => function(),
                                ),
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

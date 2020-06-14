import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';

class PublicationHeaderWidget extends StatelessWidget {
  Publication publication;
  PublicationHeaderWidget({this.publication});

  @override
  Widget build(BuildContext context) {
    String author = publication.getAuthorId();

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
                      width: 35,
                      child: IconButton(
                          icon: Icon(Icons.star_border),
                          iconSize: 30,
                          onPressed: () {}),
                    ),
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
                              value: () => deletePublication(publication),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add), onPressed: () {}),
                                  Text('Añadir a categoria')
                                ],
                              ),
                            )
                          ];
                        },
                        onSelected: (function)=>function(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}

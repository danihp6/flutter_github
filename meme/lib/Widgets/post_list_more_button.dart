import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/PostList.dart';

class PostListMoreButton extends StatelessWidget {
  PostListMoreButton({@required this.postList, this.scaffoldState});

  PostList postList;
  GlobalKey<ScaffoldState> scaffoldState;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                height: 200,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Eliminar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (postList.imageLocation != '')
                            mediaStorage.deleteFile(postList.imageLocation);
                          db.deletePostList(db.userId, postList.id);
                          Navigator.pop(context);
                        },
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Report.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/select_post_list_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'report_modal_bottom_sheet.dart';

class PostMoreButton extends StatelessWidget {
  PostMoreButton(
      {@required this.post, @required this.scaffoldState, this.postList});

  Post post;
  GlobalKey<ScaffoldState> scaffoldState;
  PostList postList;

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
                          onPressed: () => Navigator.push(
                              context,
                              SlideLeftRoute(
                                  page: SelectPostList(post: post))),
                          child: Row(
                            children: [
                              Icon(Icons.add,color: Theme.of(context).accentColor,),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Añadir a categoria')
                            ],
                          ),
                        ),
                      if (
                          postList == null &&
                          post.author == db.userId)
                        FlatButton(
                          onPressed: () => db.deletePost(db.userId, post.id),
                          child: Row(
                            children: [
                              Icon(Icons.delete,color: Theme.of(context).accentColor,),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Eliminar publicación'),
                            ],
                          ),
                        ),
                      if (
                          postList != null &&
                          postList.author == db.userId)
                        FlatButton(
                          onPressed: () => db.deletePostPathInPostList(
                              db.userId, postList.id, post.author, post.id),
                          child: Row(
                            children: [
                              Icon(Icons.remove),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Quitar de la lista'),
                            ],
                          ),
                        ),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.report,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Denunciar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ReportModalBottomSheet(
                                    reportedUserId: post.id,
                                    scaffoldState: scaffoldState,
                                    reportType:  ReportType.Post,
                                  ));
                        },
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/add_comment_field.dart';
import 'package:meme/Widgets/comment_widget.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PublicationDescriptionWidget extends StatelessWidget {
  Publication publication;
  PublicationDescriptionWidget({
    @required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            publication.getDescription(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        StreamBuilder(
            stream: getComments(publication.getId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return CircularProgressIndicator();
              List<Comment> comments = snapshot.data;
              if (comments.length == 0) return Container();
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CommentWidget(
                        comment: getBestComment(comments),
                        activeInnerComments: false,
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 20,
                      child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(0),
                          onPressed: () =>
                              Navigator.of(context).push(SlideLeftRoute(
                                  page: CommentsPage(
                                publicationId: publication.getId(),
                              ))),
                          child: Text('Ver ' +
                              comments.length.toString() +
                              ' comentarios')),
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<Object>(
            stream: getUser(configuration.getUserId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return CircularProgressIndicator();
              User user = snapshot.data;
              return SizedBox(
                  height: 50,
                  child: AddCommentField(
                      user: user, publicationId: publication.getId()));
            }),
        Align(alignment:Alignment.topLeft,child: Text('Publicada hace ' + publication.getPastTime(),style: TextStyle(
          fontSize: 13
        ),)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/comments_page.dart';
import 'package:meme/Widgets/comment_widget.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class PublicationDescriptionWidget extends StatelessWidget {
  Publication publication;
  PublicationDescriptionWidget({
    @required this.publication,
  });

  @override
  Widget build(BuildContext context) {
    User author = publication.getAuthor();
    List<Comment> comments = publication.getComments();
    return Column(
      children: [
        
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            publication.getDescription(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        if(comments.length>0)
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: SizedBox(
            height: 30,
            child: CommentWidget(comment: publication.getBestComment(),activeInnerComments: false,),
          ),
        ),
        Container(
          child: Row(
            children: [
              if(comments.length>0)
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 20,
                  child: FlatButton(
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      onPressed: ()=>Navigator.of(context).push(SlideLeftRoute(page: CommentsPage(comments: comments,))),
                      child: Text('Ver ' + comments.length.toString() + ' comentarios')),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Publicada hace '+publication.getPastTime()),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

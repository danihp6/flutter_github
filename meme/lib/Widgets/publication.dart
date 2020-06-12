import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/User.dart';

class PublicationWidget extends StatefulWidget {
  Publication publication;
  PublicationWidget({this.publication});

  @override
  _PublicationWidgetState createState() => _PublicationWidgetState();
}

class _PublicationWidgetState extends State<PublicationWidget> {
  bool _isShowedComments;
  Publication _publication;
  User _author;
  List<Comment> _comments;
  @override
  Widget build(BuildContext context) {
    _isShowedComments = configuration.getIsShowedComments();
    _publication = widget.publication;
    _author = _publication.getAuthor();
    _comments = _publication.getComments();
    return Container(
      child: Column(children: [
        Image.network(
          _publication.getImage(),
          fit: BoxFit.contain,
        ),
        if (_isShowedComments)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(_author.getImage()),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _author.getName(),
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _publication.getFavourites().toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.star_border),
                                iconSize: 30,
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _publication.getDescription(),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundImage:
                            NetworkImage(_comments[0].getAuthor().getImage()),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _comments[0].getAuthor().getName(),
                        style: TextStyle(fontSize: 13, color: Colors.blue),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _comments[0].getComment(),
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_comments[0].getLikes().toString()),
                              IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  iconSize: 15,
                                  onPressed: () {})
                            ]),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          height: 20,
                          child: FlatButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Text('Ver comentarios')),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_publication.getPastTime()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5)
              ],
            ),
          )
      ]),
    );
  }
}

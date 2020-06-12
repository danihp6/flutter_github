import 'package:flutter/material.dart';
import 'package:meme/Models/Publication.dart';

class PublicationHeaderWidget extends StatelessWidget {
  Publication publication;
  PublicationHeaderWidget({this.publication});

  @override
  Widget build(BuildContext context) {
    var author = publication.getAuthor();

    return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(author.getImage()),
              ),
              SizedBox(width: 10),
              Text(
                author.getName(),
                style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      publication.getFavourites().toString(),
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
          );
  }
}
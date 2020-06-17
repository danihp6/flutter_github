import 'package:flutter/material.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import '../Controller/db.dart';

class FavouritePublicationButton extends StatefulWidget {
  String publicationId;
  User user;
  FavouritePublicationButton({@required this.publicationId,@required this.user});

  @override
  _FavouritePublicationButtonState createState() => _FavouritePublicationButtonState();
}

class _FavouritePublicationButtonState extends State<FavouritePublicationButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getFavouriteCategory(widget.user.getFavouritesPublications()),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) return CircularProgressIndicator();
          FavouriteCategory favouriteCategory = snapshot.data;
          if(favouriteCategory.getPublications().contains(widget.publicationId))
        return Icon(
Icons.star,size: 30
        );

        return IconButton(
            icon: Icon(Icons.star_border),
            iconSize: 30,
            padding: EdgeInsets.all(0),
            onPressed: (){
              setState(() {
                addPublicationToFavouriteCategory(widget.publicationId,widget.user);
              });
            });
      }
    );
  }
}

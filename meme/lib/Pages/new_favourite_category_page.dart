import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';

class NewFavouriteCategoryPage extends StatelessWidget {
  String userId;
  NewFavouriteCategoryPage({this.userId});

  @override
  Widget build(BuildContext context) {
    String name = '';

    void validateName() {
      if (name != '') {
        newFavouriteCategory(new FavouriteCategory(name, '', <String>[],userId));
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva categoria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nombre de la categoria'),
            TextField(
              autofocus: true,
              onChanged: (value) => name = value,
            ),
            SizedBox(height: 30),
            RaisedButton(
              child: Text('Crear categoria'),
              onPressed: validateName,
            )
          ],
        ),
      ),
    );
  }
}

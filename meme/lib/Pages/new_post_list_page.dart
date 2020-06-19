import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/PostList.dart';

class NewPostListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String name = '';

    void validateName() {
      if (name != '') {
        newPostList(configuration.getUserId(),new PostList(name, '', <String>[],configuration.getUserId()));
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

import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/favourite_category_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'Models/Publication.dart';
import 'Pages/home_page.dart';
import 'Pages/favourite_page.dart';
import 'Widgets/favourite_category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User user;
  User user2;
  User user3;
  @override
  Widget build(BuildContext context) {
    user2 = User(
        'joaquin',
        'https://www.marketingdirecto.com/wp-content/uploads/2018/06/ronaldo.jpg',
        0,
        0,
        '', <FavouriteCategory>[]);
    user3 = User(
        'maria',
        'https://www.marketingdirecto.com/wp-content/uploads/2018/06/ronaldo.jpg',
        0,
        0,
        '', <FavouriteCategory>[]);
    user = User(
        'danihp6',
        'https://www.marketingdirecto.com/wp-content/uploads/2018/06/ronaldo.jpg',
        2000,
        100,
        'Cuenta de memes to guapos\nSeguidme para más memes.', [
      FavouriteCategory(
          'Subidas',
          'https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',
          [
            Publication(
                'https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',
                user2,
                'Publicación to guapa',
                345,
                [
                  Comment('Me encanta bro', 34, user2,
                      DateTime.now().subtract(Duration(seconds: 10)), <Comment>[
                    Comment( '@' + user2.getName() + ' tu poia', 0, user3, DateTime.now(), <Comment>[
                      Comment('@' + user3.getName() +' siy la ostia', 0, user3, DateTime.now(), <Comment>[])
                    ])
                  ]),
                  Comment(
                      'Me encanta bro',
                      34,
                      user2,
                      DateTime.now().subtract(Duration(seconds: 10)),
                      <Comment>[])
                ],
                DateTime.now().subtract(Duration(seconds: 1))),
            Publication(
                'https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',
                user2,
                'Publicación to guapa',
                345,
                [
                  Comment('Me encanta bro', 34, user2,
                      DateTime.now().subtract(Duration(seconds: 10)), <Comment>[
                    Comment('tu poia', 0, user3, DateTime.now(), <Comment>[])
                  ]),
                  Comment(
                      'Me encanta bro',
                      34,
                      user2,
                      DateTime.now().subtract(Duration(seconds: 10)),
                      <Comment>[])
                ],
                DateTime.now().subtract(Duration(seconds: 1))),
          ]),
      FavouriteCategory(
          'Favoritas',
          'https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',
          <Publication>[]),
      FavouriteCategory(
          'Memes Graciosos',
          'https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',
          <Publication>[])
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(user: user),
    );
  }
}

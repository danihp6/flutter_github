import 'package:flutter/material.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/favourite_category_page.dart';
import 'package:meme/Pages/main_page.dart';
import 'package:meme/Widgets/user_info.dart';
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
  @override
  Widget build(BuildContext context) {
    user2 = User('@joaquin','https://www.marketingdirecto.com/wp-content/uploads/2018/06/ronaldo.jpg',0,0,'',<FavouriteCategory>[]);
    user = 
    User('@danihp6','https://www.marketingdirecto.com/wp-content/uploads/2018/06/ronaldo.jpg',2000,100,'Cuenta de memes to guapos\nSeguidme para más memes.',
      [FavouriteCategory('Subidas','https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg', [
      Publication('https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg',user2,'Publicación to guapa',345,[Comment('Me encanta bro',34,user2,DateTime.now().subtract(Duration(seconds: 10)))],DateTime.now().subtract(Duration(seconds: 1))),
      Publication('https://lh3.googleusercontent.com/proxy/ZtelXgJHxCFmccCUihM9oeG6SYlSh5CefK4Wg2by3gVTabeFnhEn6cQ2yWPuWF9oZSZGoGd7GBHPY9EtaR5P1Whe5-B9tvGmKwkC2Uw3sZwWqq5iGEm4zIV9UYJCjjmKlAWpoQ',user2,'Publicación to guapa',345,[Comment('Me encanta bro',34,user2,DateTime.now().subtract(Duration(seconds: 10)))],DateTime.now().subtract(Duration(seconds: 1))),
      Publication('https://scontent-mad1-1.cdninstagram.com/v/t51.2885-15/e15/103484927_626079317997050_4510752617786613997_n.jpg?_nc_ht=scontent-mad1-1.cdninstagram.com&_nc_cat=1&_nc_ohc=wzxpSwa4zu0AX8r0-hW&oh=858efbe181c205d93ce1f781dea9cee4&oe=5F0C57AF',user2,'Publicación to guapa',345,[Comment('Me encanta bro',34,user2,DateTime.now().subtract(Duration(seconds: 10)))],DateTime.now().subtract(Duration(seconds: 1))),
    ]),
    FavouriteCategory('Favoritas','https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg', <Publication>[
    ]),
    FavouriteCategory('Memes Graciosos','https://cdn.memegenerator.es/imagenes/memes/full/31/21/31219721.jpg', <Publication>[
    ])]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserInfo(user:user,child: MainPage(),),
    );
  }
}
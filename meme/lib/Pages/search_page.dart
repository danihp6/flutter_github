import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/post.dart';
import '../Controller/db.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SearchBar(
                onSearch: userSearch,
                onItemFound: (item, index) {
                  if (item is User) return CircleAvatar(
                    backgroundImage: NetworkImage(item.getAvatar()),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/post.dart';
import '../Controller/db.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Future<List<dynamic>> search(String search){
      if(search[0]=='@'){
        search = search.substring(1);
        return userSearch(search);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SearchBar(
                onSearch: search,
                onItemFound: (item, index) {
                  if (item is User)
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(item.getAvatar()),
                        ),
                        SizedBox(width: 8,),
                        Text(item.getUserName())
                      ],
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

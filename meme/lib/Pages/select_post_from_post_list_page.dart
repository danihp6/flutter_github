import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/new_post_list_button.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/post_list_carousel.dart';

class SelectPostFromPostListPage extends StatelessWidget {
Function onTap;
SelectPostFromPostListPage({@required this.onTap});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un meme'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: db.getPostLists(db.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  List<PostList> postLists = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postLists.length,
                      itemBuilder: (context, index) {
                        return PostListCarousel(
                          postList: postLists[index],
                          activeMoreOptions: false,
                          onTapPost: onTap,
                          onTapPostList: (postList)=>print(postList),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
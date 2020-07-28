import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_new_button.dart';
import 'package:meme/Widgets/post_list.dart';
import '../Models/Post.dart';

class SelectPostList extends StatelessWidget {
  String postId;
  String authorId;

  SelectPostList({@required this.postId,@required this.authorId});

  @override
  Widget build(BuildContext context) {
    addPublicationAndGoBack( String postListId) {
      db.addPostInPostList(db.userId, postId,authorId, postListId);
      navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una lista'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostListNewButton(),
            StreamBuilder(
                stream: db.getPostLists(db.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  List<PostList> postLists = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postLists.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5,
                      ),
                      itemBuilder: (context, index) {
                        return PostListWidget(
                          postList: postLists[index],
                          activeMoreOptions: false,
                          onTap: () {
                            addPublicationAndGoBack(postLists[index].id);
                          },
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

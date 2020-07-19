import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/upload_button.dart';
import '../Models/Post.dart';
import '../Controller/db.dart';

class PostListPage extends StatelessWidget {
  String postListId;
  String authorId;
  PostListPage({@required this.postListId,@required this.authorId});


  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        body: StreamBuilder(
            stream: db.getPostList(authorId, postListId),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData) return Loading();
              PostList postList = snapshot.data;
              List<String> posts = postList.posts;
              return CustomScrollView(slivers: [
                SliverAppBar(
                  backgroundColor: Colors.deepOrange,
                  pinned: true,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(postList.name),
                    background: postList.image != ''
                        ? Padding(
                            padding: const EdgeInsets.all(50),
                            child: CachedNetworkImage(
                              imageUrl: postList.image,
                              placeholder: (context, url) => Loading(),
                              errorWidget: (context, url, error) => Container(),
                            ),
                          )
                        : Container(),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return StreamBuilder(
                      stream: db.getPostByPath(posts[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData) return Loading();
                        Post post = snapshot.data;
                        return Column(children: [
                          PostWidget(
                            post: post,
                            postList: postList,
                            scaffoldState: scaffoldState,
                          )
                        ]);
                      });
                }, childCount: posts.length)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                )
              ]);
            }));
  }
}

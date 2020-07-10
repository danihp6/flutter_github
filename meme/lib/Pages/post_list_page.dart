import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/icon_button_comments.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/upload_button.dart';
import '../Models/Post.dart';
import '../Controller/db.dart';

class PostListPage extends StatefulWidget {
  PostList postList;
  PostListPage({@required this.postList});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    PostList _postList = widget.postList;
    return Scaffold(
        key: scaffoldState,
        body: StreamBuilder(
            stream: db.getPostList(_postList.author, _postList.id),
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
                    title: Text(_postList.name),
                    background: _postList.image != ''
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
                  actions: [
                    IconButtonComments(
                      refresh: () {
                        setState(() {});
                      },
                    )
                  ],
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
                          if (index != 0 &&
                              !configuration.getIsShowedComments())
                            SizedBox(
                              height: 10,
                            ),
                          PostWidget(
                            post: post,
                            postList: _postList,
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

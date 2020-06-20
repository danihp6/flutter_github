import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Widgets/icon_button_comments.dart';
import 'package:meme/Widgets/post.dart';
import '../Widgets/floating_buttons.dart';
import '../Models/Post.dart';
import '../Controller/db.dart';

class PostListPage extends StatefulWidget {
  PostList postList;
  PostListPage({this.postList});

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    PostList _postList = widget.postList;
    return Scaffold(
        floatingActionButton: FloatingButtons(
          refresh: () {
            setState(() {});
          },
        ),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(_postList.getName()),
              background: _postList.getImage() != ''
                  ? Padding(
                      padding: const EdgeInsets.all(50),
                      child: Image.network(_postList.getImage()),
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
          StreamBuilder(
              stream: getPostsPathFromPostList(
                  _postList.getAuthorId(), _postList.getId()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: CircularProgressIndicator(),
                  );
                List<String> postPaths = snapshot.data;
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return StreamBuilder(
                      stream: getPost(postPaths[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
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
                          )
                        ]);
                      });
                }, childCount: postPaths.length));
              }),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          )
        ]));
  }
}

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
  @override
  Widget build(BuildContext context) {
    PostList _postList = widget.postList;
    return Scaffold(
        floatingActionButton: UploadButton(
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
              stream: db.getPostsPathFromPostList(
                  _postList.getAuthorId(), _postList.getId()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Loading(),
                  );
                List<String> postPaths = snapshot.data;
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return StreamBuilder(
                      stream: db.getPost(postPaths[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData)
                          return Loading();
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

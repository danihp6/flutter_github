import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/new_post_list_button.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Pages/post_list_page.dart';

class UserPageBody extends StatefulWidget {
  UserPageBody({
    @required this.user,
  });

  User user;

  @override
  _UserPageBodyState createState() => _UserPageBodyState();
}

class _UserPageBodyState extends State<UserPageBody>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostList postList;

    goToPostList() {
      Navigator.of(context)
          .push(SlideLeftRoute(page: PostListPage(postList: postList)));
    }

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.perm_media,
                size: 30,
              ),
            ),
          ],
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.deepOrange,
        ),
        Expanded(
          child: TabBarView(controller: tabController, children: [
            Column(children: [
              NewPostListButton(userId: widget.user.getId()),
              ]),
            Container()
          ]),
        )
      ],
    );
  }
}

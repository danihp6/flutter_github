import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/post_list_page.dart';
import 'package:meme/Pages/post_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/post_list_new_button.dart';
import 'package:meme/Widgets/post.dart';
import 'package:meme/Widgets/post_list.dart';
import 'package:meme/Widgets/post_list_carousel.dart';
import 'package:meme/Widgets/share_button.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_more_button.dart';
import 'package:meme/Widgets/user_page_header.dart';
import 'package:rxdart/streams.dart';


class UserPage extends StatefulWidget {
  String userId;
  
  UserPage({@required this.userId});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool blocked;
  bool currentUserBlocked;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: db.getUser(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            User user = snapshot.data;
            List<String> favourites = user.favourites;
            return StreamBuilder(
              stream: db.getUser(db.userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return Loading();
            User currentUser = snapshot.data;
            blocked = currentUser.blockedUsers.contains(user.id);
            currentUserBlocked = user.blockedUsers.contains(currentUser.id);
                return Scaffold(
                  key: scaffoldState,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: AppBar(
                      backgroundColor: Colors.deepOrange,
                      title: Text(user.userName),
                      actions: <Widget>[
                        ShareButton(
                            userId: user.id,
                            scaffoldState: scaffoldState),
                        UserMoreButton(
                            user: user,
                            scaffoldState: scaffoldState,
                            blocked: blocked,
                            youAreBlocked: currentUserBlocked)
                      ],
                    ),
                  ),
                  body: !blocked && !currentUserBlocked
                      ? NestedScrollView(
                          headerSliverBuilder: (context, _) => [
                            SliverToBoxAdapter(
                                child: 
                                       UserPageHeader(
                                          user: user,
                                          scaffoldState: scaffoldState),
                                    
                            )
                          ],
                          body: Column(
                            children: <Widget>[
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
                                    Icons.star,
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
                            ),
                              Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    PostsStream(
                                        scaffoldState: scaffoldState, userId: user.id,),
                                    favourites.isNotEmpty
                                        ? FavouritesStream(
                                            favourites: favourites,
                                            scaffoldState: scaffoldState)
                                        : Center(
                                            child: Text('Usuario sin favoritos',style:Theme.of(context).textTheme.bodyText1)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PostListsStream(
                                        userId: user.id,
                                      ),
                                    )
                                  ]),
                            ),
                                          ],
                                        ),
                                      ): Center(
                          child: Text('Usuario bloqueado',
                              style:Theme.of(context).textTheme.bodyText1)),
                                    );
              }
            );}));

  }
}

class PostListsStream extends StatefulWidget {
  const PostListsStream({
    Key key,
    @required this.userId
  }) : super(key: key);

  final String userId;

  @override
  _PostListsStreamState createState() => _PostListsStreamState();
}

class _PostListsStreamState extends State<PostListsStream> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: db.getPostLists(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return Loading();
        List<PostList> postlists = snapshot.data;
        if (postlists.isEmpty)
          return Center(child: Text('Usuario sin listas',style:Theme.of(context).textTheme.bodyText1));
        return ListView.builder(
          shrinkWrap: true,
          itemCount: postlists.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PostListCarousel(
              postList: postlists[index],
              onTapPostList: navigator.goPostList,
              onTapPost: navigator.goPost,
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FavouritesStream extends StatefulWidget {
  const FavouritesStream({
    Key key,
    @required this.favourites,
    @required this.scaffoldState,
  }) : super(key: key);

  final List<String> favourites;
  final GlobalKey<ScaffoldState> scaffoldState;

  @override
  _FavouritesStreamState createState() => _FavouritesStreamState();
}

class _FavouritesStreamState extends State<FavouritesStream> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CombineLatestStream.list(
              widget.favourites.map((favourite) => db.getPostByPath(favourite)))
          .asBroadcastStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return Loading();
        List<Post> posts = snapshot.data;
        print(posts);
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) => PostWidget(
            post: posts[index],
            scaffoldState: widget.scaffoldState,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PostsStream extends StatefulWidget {
  const PostsStream({Key key, this.scaffoldState,@required this.userId}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldState;
  final String userId;

  @override
  _PostsStreamState createState() => _PostsStreamState();
}

class _PostsStreamState extends State<PostsStream> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getPosts(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (!snapshot.hasData) return Loading();
        List<Post> posts = snapshot.data;
        if(posts.isEmpty)return Center(child: Text('Usuario sin publicaciones',style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16)));
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) => PostWidget(
            post: posts[index],
            scaffoldState: widget.scaffoldState,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
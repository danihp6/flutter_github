import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/user_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class UserListPage extends StatelessWidget {
  String title;
  List<String> userListId;
  UserListPage({@required this.title, @required this.userListId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: userListId.length,
          itemBuilder: (context, index) {
            return StreamBuilder(
              stream: db.getUser(userListId[index]),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData) return Loading();
                User user = snapshot.data;
                return GestureDetector(
                                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.getAvatar()),
                      ),
                      SizedBox(width: 10,),
                      Text(user.getUserName(),style: TextStyle(fontSize: 15),)
                    ],
                  ),
                  onTap: ()=>Navigator.push(context, SlideLeftRoute(page: UserPage(userId: user.getId(),))),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

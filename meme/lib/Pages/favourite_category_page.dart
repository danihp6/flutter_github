import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Widgets/publication.dart';
import '../Widgets/floating_buttons.dart';

class FavouriteCategoryPage extends StatefulWidget {
  String favouriteCategoryId;
  FavouriteCategoryPage({this.favouriteCategoryId});

  @override
  _FavouriteCategoryPageState createState() => _FavouriteCategoryPageState();
}

class _FavouriteCategoryPageState extends State<FavouriteCategoryPage> {
  @override
  Widget build(BuildContext context) {
    String _favouriteCategoryId = widget.favouriteCategoryId;
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
            flexibleSpace: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                if(snapshot.hasError)print(snapshot.error);
                if(!snapshot.hasData) return CircularProgressIndicator();
                FavouriteCategory favouriteCategory = snapshot.data;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(favouriteCategory.getName()),
                  background: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Image.network(favouriteCategory.getImage()),
                  ),
                );
              }
            ),
            actions: [
              IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
            ],
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate((context, index) {
          //     var publications = _favouriteCategory.getPublications();
          //     return Column(
          //       children: [
          //         if (index != 0 && !configuration.getIsShowedComments())
          //           SizedBox(
          //             height: 10,
          //           ),
          //         PublicationWidget(
          //           publication: publications[index],
          //         ),
          //       ],
          //     );
          //   }, childCount: _favouriteCategory.getPublications().length),
          // )
        ]));
  }
}

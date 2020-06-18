import 'package:flutter/material.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Widgets/icon_button_comments.dart';
import 'package:meme/Widgets/publication.dart';
import '../Widgets/floating_buttons.dart';

class FavouriteCategoryPage extends StatefulWidget {
  FavouriteCategory favouriteCategory;
  FavouriteCategoryPage({this.favouriteCategory});

  @override
  _FavouriteCategoryPageState createState() => _FavouriteCategoryPageState();
}

class _FavouriteCategoryPageState extends State<FavouriteCategoryPage> {
  @override
  Widget build(BuildContext context) {
    FavouriteCategory _favouriteCategory = widget.favouriteCategory;
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
                stream: getFavouriteCategory(_favouriteCategory.getId()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  FavouriteCategory favouriteCategory = snapshot.data;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(favouriteCategory.getName()),
                    background: favouriteCategory.getImage() != ''
                        ? Padding(
                            padding: const EdgeInsets.all(50),
                            child: Image.network(favouriteCategory.getImage()),
                          )
                        : Container(),
                  );
                }),
            actions: [
              IconButtonComments(
                refresh: () {
                  setState(() {});
                },
              )
            ],
          ),
          StreamBuilder(
            stream: getPublicationsFromFavouriteCategory(
                _favouriteCategory.getId()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (!snapshot.hasData)
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              List<Publication> publications = snapshot.data;
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(
                    children: [
                      if (index != 0 && !configuration.getIsShowedComments())
                        SizedBox(
                          height: 10,
                        ),
                      StreamBuilder(
                          stream: getPublication(publications[index].getId()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            Publication publication = snapshot.data;
                            return PublicationWidget(
                              publication: publication,
                              favouriteCategory: _favouriteCategory,
                            );
                          })
                    ],
                  );
                }, childCount: publications.length),
              );
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          )
        ]));
  }
}

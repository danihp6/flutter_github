import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Pages/tag_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/tag.dart';
import '../Controller/db.dart';

class StreamTagViewer extends StatelessWidget {
  List<String> tagsId;
  StreamTagViewer({
    @required this.tagsId,
  });

  

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: tagsId.length,
      separatorBuilder: (context, index) => SizedBox(
        width: 6,
      ),
      itemBuilder: (context, index) => StreamBuilder(
        stream: db.getTag(tagsId[index]),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Container();
                    Tag tag = snapshot.data;
          return TagWidget(tag: tag,isPointsShowed: false, onTap: ()=>Navigator.push(context, SlideLeftRoute(page: TagPage(tagId: tag.id))));
        }
      ),
    );
  }
}
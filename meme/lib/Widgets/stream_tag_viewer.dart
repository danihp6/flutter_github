import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';
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
          return Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(3)),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text('#'+tag.name,style: TextStyle(fontSize: 16),),
              ));
        }
      ),
    );
  }
}
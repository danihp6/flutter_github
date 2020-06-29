import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';

class TagViewer extends StatelessWidget {
  List<Tag> tags;
  Function onClearTag;
  TagViewer({
    @required this.tags,
    this.onClearTag
  });

  

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      separatorBuilder: (context, index) => SizedBox(
        width: 6,
      ),
      itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(3)),
            color: Colors.grey[300],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Text('#' + tags[index].name,style:TextStyle(fontSize: 16)),
                SizedBox(
                  width: 20,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                    icon: Icon(Icons.clear),
                    onPressed: () => onClearTag(index),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
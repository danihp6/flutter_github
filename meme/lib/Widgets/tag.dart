import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';

class TagWidget extends StatelessWidget {
  Tag tag;
  Function onTap;
  bool isNumberPublicationsShowed;
  TagWidget({@required this.tag, @required this.onTap,this.isNumberPublicationsShowed = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: Colors.grey[300],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  '#' + tag.name,
                  style: TextStyle(fontSize: 16),
                ),
              )),
          SizedBox(
            width: 5,
          ),
          if(isNumberPublicationsShowed)
          Text(
            tag.posts.length.toString() + ' publicación',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

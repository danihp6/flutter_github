import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Widgets/tags_viewer.dart';

class TagSelector extends StatefulWidget {
  List<Tag> tags;
  Function onFieldSubmitted;
  Function onClearTag;
  String tag;
  Function setTag;
  TagSelector(
      {@required this.tags,
      @required this.tag,
      @required this.onFieldSubmitted,
      @required this.onClearTag,
      @required this.setTag});

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  TextEditingController tagsController;

  @override
  void initState() {
    super.initState();
    tagsController = TextEditingController();
  }

  @override
  void dispose() {
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 30,
            child: widget.tags.isNotEmpty
                ? TagViewer(
                    tags: widget.tags,
                    onClearTag: widget.onClearTag,
                  )
                : Center(
                    child: Text('Añade tags',
                        style: TextStyle(color: Colors.black38)),
                  )),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tags',
                prefixIcon: widget.tag.length > 0
                    ? IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          setState(() {
                            widget.onFieldSubmitted();
                            tagsController.clear();
                          });
                        })
                    : null,
                suffixIcon: widget.tag.length > 0
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          tagsController.clear();

                          widget.setTag('');
                        })
                    : null),
            onChanged: (value) {
              widget.setTag(value);
            },
            onFieldSubmitted: (_) {
              widget.onFieldSubmitted();
              setState(() {
                tagsController.clear();
              });
            },
            controller: tagsController,
          ),
        ),
      ],
    );
  }
}

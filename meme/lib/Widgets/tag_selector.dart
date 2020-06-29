import 'package:flutter/material.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Widgets/tags_viewer.dart';

class TagSelector extends StatefulWidget {
  List<Tag> tags;
  Function onFieldSubmitted;
  Function onClearTag;
  TagSelector(
      {@required this.tags,
      @required this.onFieldSubmitted,
      @required this.onClearTag});

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  TextEditingController tagsController;
  String _tag = '';

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
            child: TagViewer(
              tags: widget.tags,
              onClearTag: widget.onClearTag,
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
                prefixIcon: _tag.length > 0
                    ? IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          setState(() {
                            widget.onFieldSubmitted(_tag);
                            _tag = '';
                            tagsController.clear();
                          });
                        })
                    : null,
                suffixIcon: _tag.length > 0
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _tag = '';
                            tagsController.clear();
                          });
                        })
                    : null),
            onChanged: (value) {
              setState(() {
                _tag = value;
              });
            },
            onFieldSubmitted: (tag) {
              widget.onFieldSubmitted(tag);
              setState(() {
                _tag = '';
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

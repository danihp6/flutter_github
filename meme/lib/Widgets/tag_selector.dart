import 'package:flutter/material.dart';
import 'package:meme/Widgets/tags_viewer.dart';

class TagSelector extends StatefulWidget {
  List<String> tags;
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
          width: 300,
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tags',
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        tagsController.clear();
                      });
                    })),
            onFieldSubmitted: (tag) {
              widget.onFieldSubmitted(tag);
              setState(() {
                tagsController.clear();
              });
            },
            controller: tagsController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 25,
            child: TagViewer(
              tags: widget.tags,
              onClearTag: widget.onClearTag,
            )),
      ],
    );
  }
}

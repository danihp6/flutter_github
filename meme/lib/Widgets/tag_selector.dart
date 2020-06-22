import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  List<String> tags;
  Function onFieldSubmitted;
  Function onClearTag;
  TagSelector({
    @required this.tags,
    @required this.onFieldSubmitted,
    @required this.onClearTag
  }) ;

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
            onFieldSubmitted: (tag){
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
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.tags.length,
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
                        Text(widget.tags[index]),
                        SizedBox(
                          width: 20,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 20,
                            icon: Icon(Icons.clear),
                            onPressed: () => widget.onClearTag(index),
                          ),
                        )
                      ],
                    ),
                  )),
            )),
      ],
    );
  }
}

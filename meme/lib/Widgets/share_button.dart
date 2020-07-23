import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/dynamic_links.dart';
import 'package:meme/Controller/navigator.dart';

class ShareButton extends StatelessWidget {
  String authorId;
  String postId;
  String userId;
  GlobalKey<ScaffoldState> scaffoldState;
  ShareButton(
      {this.postId, this.authorId, @required this.scaffoldState, this.userId});

  GlobalKey<ScaffoldState> _scaffoldState;
  @override
  Widget build(BuildContext context) {
    if (scaffoldState == null)
      _scaffoldState = configuration.mainScaffoldState;
    else
      _scaffoldState = scaffoldState;

    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () async {
        String link;
        if (postId != null)
          link = await dynamicLinks.postDynamicLink(true, authorId, postId);
        else if (userId != null)
          link = await dynamicLinks.userDynamicLink(true, userId);
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          link,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.white),
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.content_copy,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: link));
                            navigator.pop(context);
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: new Text("Copiado al portapapeles")));
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

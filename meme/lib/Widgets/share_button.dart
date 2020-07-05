import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/Configuration.dart';
import 'package:meme/Controller/dynamic_links.dart';

class ShareButton extends StatelessWidget {
  String authorId;
  String postId;
  ShareButton({@required this.postId,@required this.authorId});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () async {
        String link = await dynamicLinks.createDynamicLink(true,authorId,postId);
        configuration.scaffoldState.currentState.showBottomSheet(
          (context) {
            return Container(
              height: 200,
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
                            Navigator.pop(context);
                            configuration.scaffoldState.currentState
                                .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content:
                                        new Text("Copiado al portapapeles")));
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

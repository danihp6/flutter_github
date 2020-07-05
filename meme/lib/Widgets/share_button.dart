import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/Configuration.dart';

class ShareButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
        Scaffold.of(configuration.scaffoldState.currentContext).hi
        PersistentBottomSheetController bottomSheetController =
            configuration.scaffoldState.currentState.showBottomSheet(
          (context) {
            String link =
                'egejbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbrh';
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
                        )),
                        IconButton(
                          icon: Icon(
                            Icons.content_copy,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                                new ClipboardData(text: link));
                            Navigator.pop(context);
                            configuration.scaffoldState.currentState
                                .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: new Text(
                                        "Copiado al portapapeles")));
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
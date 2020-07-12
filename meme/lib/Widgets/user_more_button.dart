import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Report.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';

import 'report_modal_bottom_sheet.dart';

class UserMoreButton extends StatelessWidget {
  UserMoreButton(
      {@required this.user, @required this.scaffoldState, this.blocked});

  User user;
  GlobalKey<ScaffoldState> scaffoldState;
  bool blocked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                height: 200,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              blocked ? Icons.remove : Icons.block,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              blocked ? 'Desbloquear' : 'Bloquear',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (blocked)
                            db.unblock(db.userId, user.id);
                          else
                            db.block(db.userId, user.id);
                            Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.report,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Denunciar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ReportModalBottomSheet(
                                    reportedUserId: user.id,
                                    scaffoldState: scaffoldState,
                                    reportType: user is User
                                        ? ReportType.User
                                        : ReportType.Post,
                                  ));
                        },
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

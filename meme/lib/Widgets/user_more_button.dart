import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Report.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';

import 'report_modal_bottom_sheet.dart';

class UserMoreButton extends StatelessWidget {
  UserMoreButton(
      {@required this.user,
      @required this.scaffoldState,
      this.blocked,
      this.youAreBlocked});

  User user;
  GlobalKey<ScaffoldState> scaffoldState;
  bool blocked;
  bool youAreBlocked;

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
                      if (!youAreBlocked)
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
                            navigator.pop(context);
                            if (blocked)
                              db.unblock(db.userId, user.id);
                            else
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            Icons.block,
                                            size: 30,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          Text(
                                              'Estas seguro? no podrás acceder a el perfil de ${user.userName} ni él al tuyo',
                                              style: TextStyle(fontSize: 16)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () =>
                                                      navigator.pop(context),
                                                  child: Text('Cancelar')),
                                              FlatButton(
                                                  onPressed: () {
                                                    db.block(
                                                        db.userId, user.id);
                                                    navigator.pop(context);
                                                  },
                                                  child: Text('Bloquear'))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
                              'Reportar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          navigator.pop(context);
                          if (!await db.reporter(user.id, db.userId))
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ReportModalBottomSheet(
                                      reportedUserId: user.id,
                                      scaffoldState: scaffoldState,
                                      reportType: user is User
                                          ? ReportType.User
                                          : ReportType.Post,
                                    ));
                          else
                            scaffoldState.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                    'Ya ha sido reportado')));
                        },
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

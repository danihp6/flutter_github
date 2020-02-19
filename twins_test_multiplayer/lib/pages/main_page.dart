import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twins_test_multiplayer/models/player.dart';

import '../db.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DocumentReference playerRef = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                  stream: getPlayerByDocumentReference(playerRef),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text(snapshot.error.toString()));
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    Player player=snapshot.data;
                    return Column(
                      children: <Widget>[
                        Center(child: Text(player.name)),
                        RaisedButton(
                          child: Text('Buscar partida'),
                          onPressed: () => Navigator.of(context).pushNamed('/matchmaking',arguments: player),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

// StreamBuilder(
//                   stream: getPlayerById(ricardo),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError)
//                       return Center(child: Text(snapshot.error.toString()));
//                     if (!snapshot.hasData) return CircularProgressIndicator();
//                     Player player = snapshot.data;
//                     print(player.toString());
//                     return Column(
//                       children: <Widget>[
//                         Center(child: Text(player.name)),
//                         RaisedButton(
//                           child: Text('Buscar partida'),
//                           onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => MatchmakingPage(player))),
//                         ),
//                       ],
//                     );
//                   }),
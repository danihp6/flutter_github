const functions = require('firebase-functions');
//firebase deploy --only functions

const admin = require('firebase-admin');
admin.initializeApp();

exports.timer = functions.region('europe-west2').firestore
  .document('games/{gameId}')
  .onUpdate((change, context) => {
    const data = change.after.data();
    const previousData = change.before.data();
    if(data.state==1 && previousData.state==0){
      return admin.firestore().collection('games/${data.uid}/turns').add(
        {
          turnOfPlayer: Math.floor(Math.random() * 2),
          turn: 1,
          timer:new Date(new Date().setSeconds(new Date().getSeconds()+10))
        }
      )
    }

    // if ((data.state == 1 && previousData.state == 0) || (data.turn==previousData.turn + 1 && data.turn<4)){
    //   setTimeout(() => {
    //     return change.after.ref.set({
    //       turnOfPlayer: data.turnOfPlayer==0?1:0,
    //       turn: data.turn++,
    //       timer:new Date(new Date().setSeconds(new Date().getSeconds()+10))
    //     }, { merge: true });
    //   }, 10000);
    // }
    return null
  });

  // return change.after.ref.set({
  //   turnOfPlayer: Math.floor(Math.random() * 2),
  //   turn: 1,
  //   timer:new Date(new Date().setSeconds(new Date().getSeconds()+10))
  // }, { merge: true });
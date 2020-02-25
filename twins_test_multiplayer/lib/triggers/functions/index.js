const functions = require('firebase-functions');
//firebase deploy --only functions

const admin = require('firebase-admin');
admin.initializeApp();

exports.timer = functions.region('europe-west2').firestore
  .document('games/{gameId}')
  .onUpdate((change, context) => {
    const data = change.after.data();
    const previousData = change.before.data();

    if (data.state == 1 && previousData.state == 0){
      var cont=0
      var timer = setInterval(() => {
        if(cont==10)clearInterval(timer)
        return change.after.ref.set({
          timer: cont++
        }, { merge: true });
      }, 1000);
    }
  });
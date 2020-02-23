const functions = require('firebase-functions');
//firebase deploy --only functions

exports.timer = functions.region('europe-west2').firestore
    .document('games/{gameId}')
    .onUpdate((change, context) => {
    const data = change.after.data();
    const previousData = change.before.data();

      if (data.state == 1 && previousData.state==0) 
       var interval =setInterval(()=>{
           console.log(data.timer)
           if(data.timer==20)clearInterval(interval)
            change.after.ref.set({
                timer: data.timer + 1
              }, {merge: true});
       },1000)
    });
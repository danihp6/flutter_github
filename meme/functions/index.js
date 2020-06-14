const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.deleteComments = functions.firestore.document('Publications/{publicationId}').onDelete((snap,context)=>{
    var publicationId = context.params.publicationId
    var db = admin.firestore()
    var ref = db.collection('Publications').doc(publicationId).collection('comments')

    var deleted = deleteCollection(db,ref,500)
    return Promise.all([deleted])
})

function deleteCollection (db, collectionRef, batchSize) {
    var query = collectionRef.orderBy('__name__').limit(batchSize)

    return new Promise(function (resolve, reject) {
      deleteQueryBatch(db, query, batchSize, resolve, reject)
    })
  }

  function deleteQueryBatch (db, query, batchSize, resolve, reject) {
    query.get()
.then((snapshot) => {
        // When there are no documents left, we are done
        if (snapshot.size === 0) {
          return 0
        }

      // Delete documents in a batch
      var batch = db.batch()
      snapshot.docs.forEach(function (doc) {
        batch.delete(doc.ref)
      })

      return batch.commit().then(function () {
        return snapshot.size
      })
    }).then(function (numDeleted) {
      if (numDeleted <= batchSize) {
        resolve()
        return
      }
      else {
      // Recurse on the next process tick, to avoid
      // exploding the stack.
      return process.nextTick(function () {
        deleteQueryBatch(db, query, batchSize, resolve, reject)
      })
    }
  })
    .catch(reject)
  }
const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.onDeletePost = functions.firestore.document('users/{userId}/posts/{postId}').onDelete((snap, context) => {
  var userId = context.params.userId
  var postId = context.params.postId
  var path = 'users/' + userId + '/posts/' + postId
  var batchSize = 500
  var db = admin.firestore()
  var ref = db.collection('users').doc(userId).collection('posts').doc(postId).collection('comments')

  var deleted = deleteCollection(db, ref, batchSize)

  ref = db.collection('users')

  deleteFavourites(path,db,ref,batchSize)

  var query = ref.orderBy('__name__').limit(batchSize)
  query.get().then((snapshot)=>{
    console.log(snapshot.size)
    if (snapshot.size === 0) {
      return 0
    }
    snapshot.docs.forEach(function (doc) {
      console.log(doc.ref.collection('postLists'))
      deletePostInPostList(path,db,doc.ref.collection('postLists'),batchSize)
    })
  })
  return Promise.all([deleted])
})

function deletePostInPostList(path, db, collectionRef, batchSize) {
  var query = collectionRef.orderBy('__name__').limit(batchSize)

  return new Promise(function (resolve, reject) {
    deletePostInPostListInQuery(path, db, query, batchSize, resolve, reject)
  })
}

function deletePostInPostListInQuery(path, db, query, batchSize, resolve, reject) {
  query.get().then((snapshot) => {
    if (snapshot.size === 0) {
      return 0
    }

    var batch = db.batch()
    snapshot.docs.forEach(function (doc) {
      batch.update(doc.ref, {
        'posts': admin.firestore.FieldValue.arrayRemove(path)
      })
    })
    return batch.commit().then(function () {
      return snapshot.size
    })
  }).then(function (numChanged) {
    if (numChanged <= batchSize) {
      resolve()
      return
    }
    else {
      // Recurse on the next process tick, to avoid
      // exploding the stack.
      return process.nextTick(function () {
        deletePostInPostListInQuery(path,db, query, batchSize, resolve, reject)
      })
    }

  })
  .catch(reject);
}

function deleteFavourites(path, db, collectionRef, batchSize) {
  var query = collectionRef.orderBy('__name__').limit(batchSize)

  return new Promise(function (resolve, reject) {
    deleteFavouritesInQuery(path, db, query, batchSize, resolve, reject)
  })
}

function deleteFavouritesInQuery(path, db, query, batchSize, resolve, reject) {
  query.get().then((snapshot) => {
    if (snapshot.size === 0) {
      return 0
    }

    var batch = db.batch()
    snapshot.docs.forEach(function (doc) {
      batch.update(doc.ref, {
        'favourites': admin.firestore.FieldValue.arrayRemove(path)
      })
    })
    return batch.commit().then(function () {
      return snapshot.size
    })
  }).then(function (numChanged) {
    if (numChanged <= batchSize) {
      resolve()
      return
    }
    else {
      // Recurse on the next process tick, to avoid
      // exploding the stack.
      return process.nextTick(function () {
        deleteFavouritesInQuery(path,db, query, batchSize, resolve, reject)
      })
    }

  })
  .catch(reject);
}

function deleteCollection(db, collectionRef, batchSize) {

  let query = collectionRef.orderBy('__name__').limit(batchSize);

  return new Promise((resolve, reject) => {
    deleteQueryBatch(db, query, batchSize, resolve, reject);
  });
}

function deleteQueryBatch(db, query, batchSize, resolve, reject) {
  query.get()
    .then((snapshot) => {
      // When there are no documents left, we are done
      if (snapshot.size == 0) {
        return 0;
      }

      // Delete documents in a batch
      let batch = db.batch();
      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      return batch.commit().then(() => {
        return snapshot.size;
      });
    }).then((numDeleted) => {
      if (numDeleted === 0) {
        resolve();
        return;
      }

      // Recurse on the next process tick, to avoid
      // exploding the stack.
      process.nextTick(() => {
        deleteQueryBatch(db, query, batchSize, resolve, reject);
      });
    })
    .catch(reject);
}

exports.onNewPost = functions.firestore.document('users/{userId}/posts/{postId}').onCreate(async (snap, context) => {
  var userId = context.params.userId
  var postId = context.params.postId

  var userName = snap.data()['userName']

  const payload = {
    notification: {
      title: 'Nueva publicación',
      body: `${userName} ha subido una nueva publicación`,
    },
    data:{
      post:postId,
      sender:userId
    }
  };

  var db = admin.firestore()
  var ref = db.collection('users').doc(userId)

  ref.collection('notifications').add(payload)

  // var query = ref.orderBy('__name__')
  // var tokens

  // var token = 'fKpAghNZSPuyTSsXNlp3Ex:APA91bF4cIS2EsUlVIbBngRLeFyFzF4cnPwBN861SBazN3XbP4Hz2lLEkaZT3MGZh7e4QR751D_ieUTJTG-9w3xXgMmn2rhoihWC5tShcLF9IBy-ZFQEUsmnTjjWQT1qbF0gsERA5kfi'

  // const response = await admin.messaging().sendToDevice(token, payload);
})
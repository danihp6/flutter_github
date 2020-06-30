const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.onDeletePost = functions.region('europe-west2').firestore.document('users/{userId}/posts/{postId}').onDelete((snap, context) => {
  var userId = context.params.userId
  var postId = context.params.postId
  var path = 'users/' + userId + '/posts/' + postId
  var batchSize = 500
  var db = admin.firestore()
  var ref = db.collection('users').doc(userId).collection('posts').doc(postId).collection('comments')

  var deleted = deleteCollection(db, ref, batchSize)

  ref = db.collection('users')

  deleteFavourites(path, db, ref, batchSize)

  var query = ref.orderBy('__name__').limit(batchSize)
  query.get().then((snapshot) => {
    console.log(snapshot.size)
    if (snapshot.size === 0) {
      return 0
    }
    snapshot.docs.forEach(function (doc) {
      console.log(doc.ref.collection('postLists'))
      deletePostInPostList(path, db, doc.ref.collection('postLists'), batchSize)

      // ref = doc.collection('notifications')
      // query = ref.orderBy('__name__').limit(batchSize)

      // query.get().then((snapshot) => {
      //   if (snapshot.size === 0) {
      //     return 0
      //   }

      //   var notificationData
      //   var post
      //   snapshot.docs.forEach(function (doc) {
      //     notificationData = (await ref.get()).data()
      //     post = notificationData['post']

      //     if (post == userId) doc.delete()


      //   })
      // })
    })
  })

  var path = snap.data()['mediaLocation']
  console.log(path)
  var bucket = admin.storage().bucket()
  deleteMedia(path,bucket)
  return Promise.all([deleted])
})

function deleteMedia(path,bucket){
  bucket.file(path).delete()
}

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
        deletePostInPostListInQuery(path, db, query, batchSize, resolve, reject)
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
        deleteFavouritesInQuery(path, db, query, batchSize, resolve, reject)
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

// exports.onDeleteUser = functions.region('europe-west2').firestore.document('users/{userId}').onDelete(async (snap, context) => {
//   var userId = context.params.userId
//   FALTA COMENTARIOS DE TODAS LAS PUBLICACIONES
//   var batchSize = 500
//   var db = admin.firestore()

//   var ref = db.collection('users').doc(userId).collection('notifications')

//   deleteCollection(db, ref, batchSize)

//   ref = db.collection('users').doc(userId)

//   var query = ref.orderBy('__name__').limit(batchSize)

//   query.get((snapshot) => {
//     if (snapshot.size === 0) {
//       return 0
//     }

//     snapshot.docs.forEach(function (doc) {
//       ref = doc.collection('comments')
//       await deleteCollection(db, ref, batchSize)
//       doc.delete()
//     })
//   })

//   ref = db.collection('users')
//   query = ref.orderBy('__name__').limit(batchSize)

//   query.get((snapshot) => {
//     if (snapshot.size === 0) {
//       return 0
//     }

//     snapshot.docs.forEach(function (doc) {
//       doc.update({
//         'followers': admin.firestore.FieldValue.arrayRemove(userId),
//         'followed': admin.firestore.FieldValue.arrayRemove(userId)
//       })

//       ref = doc.collection('notifications')
//       query = ref.orderBy('__name__').limit(batchSize)

//       query.get((snapshot)=>{
//         if (snapshot.size === 0) {
//           return 0
//         }

//         var notificationData
//         snapshot.docs.forEach(function(doc){
//           notificationData = (await ref.get()).data()
//           sender = notificationData['sender']

//           if(sender==userId) doc.delete()
//         })
//       })

//     })
//   })


// })

// exports.onNewPost = functions.region('europe-west2').firestore.document('users/{userId}/posts/{postId}').onCreate(async (snap, context) => {
//   var userId = context.params.userId
//   var postId = context.params.postId

//   var db = admin.firestore()
//   var ref = db.collection('users').doc(userId)

//   var userData = (await ref.get()).data()

//   var userName = userData['userName']

//   const notification = {
//       title: 'Nueva publicación',
//       body: `${userName} ha subido una nueva publicación`,
//       post:postId,
//       sender:userId
//   };

//   var followers = userData['followers']

//   followers.forEach(id => {
//     ref = db.collection('users').doc(id)
//     ref.collection('notifications').add(notification)
//   });

// })

exports.newFollower = functions.region('europe-west2').firestore.document('users/{userId}').onUpdate(async (change, context) => {
  beforeFollowers = change.before.data()['followers']
  afterFollowers = change.after.data()['followers']

  if (beforeFollowers.length == afterFollowers.length) return 0

  var userId = context.params.userId

  var newFollower = afterFollowers[afterFollowers.length - 1]

  console.log(newFollower)

  var db = admin.firestore()
  var ref = db.collection('users').doc(newFollower)

  var userData = (await ref.get()).data()

  var userName = userData['userName']

  const notification = {
    title: 'Nuevo suscriptor',
    body: `${userName} te ha seguido`,
    sender: newFollower,
    dateTime: new Date(Date.now())
  };

  ref = db.collection('users').doc(userId)
  ref.collection('notifications').add(notification)

})

exports.onCreateNotification = functions.region('europe-west2').firestore.document('users/{userId}/notifications/{notificationId}').onCreate(async (snap, context) => {
  var notification = snap.data()

  var sender = notification['sender']
  var post = notification['post']

  var db = admin.firestore()
  var ref = db.collection('users').doc(sender)

  var userName = (await ref.get()).data()['userName']

  const payload = {
    notification: {
      title: 'Nueva publicación',
      body: `${userName} ha subido una nueva publicación`,
    },
    data: {
      post: post,
      sender: sender
    }
  };

  var userId = context.params.userId

  ref = db.collection('users').doc(userId)

  var tokens = (await ref.get()).data()['tokens']

  tokens.forEach(async token => {
    await admin.messaging().sendToDevice(token, payload);
  });
})
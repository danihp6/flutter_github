const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

var db = admin.firestore()

exports.onDeletePost = functions.region('europe-west2').firestore.document('users/{userId}/posts/{postId}').onDelete(async (snap, context) => {
  var path = snap.ref
  var batchSize = 500
  var commentsRef = path.collection('comments')

  deleteCollection(db, commentsRef, batchSize)

  var usersSnapshot = await db.collection('users').orderBy('__name__').limit(batchSize).get()

  usersSnapshot.docs.forEach(async(doc) => {
    doc.ref.update({
      'favourites': admin.firestore.FieldValue.arrayRemove(path)
    })

    var postListsSnapshot = await doc.ref.collection('postLists').orderBy('__name__').limit(batchSize).get()

    postListsSnapshot.docs.forEach((doc) => {
      doc.ref.update({
        'posts': admin.firestore.FieldValue.arrayRemove(path)
      })
    })

    var notificationsSnapshot = await doc.ref.collection('notifications').orderBy('__name__').limit(batchSize).get()

    notificationsSnapshot.docs.forEach((doc) => {
      var post = doc.data()['post']
      if (post == path) doc.ref.delete()
    })


  })

  var mediaPath = snap.data()['mediaLocation']
  var bucket = admin.storage().bucket()
  bucket.file(mediaPath).delete()

  tagsSnapshot = await db.collection('tags').orderBy('__name__').limit(batchSize).get()


  tagsSnapshot.docs.forEach(function (doc) {
    doc.ref.update({
      'posts': admin.firestore.FieldValue.arrayRemove(path)
    })
  })

})

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

exports.onDeleteUser = functions.region('europe-west2').firestore.document('users/{userId}').onDelete(async (snap, context) => {
  var path = snap.ref
  var batchSize = 500
  var userId = context.params.userId

  var mediaPath = snap.data()['avatarLocation']
  var bucket = admin.storage().bucket()
  bucket.file(mediaPath).delete()

  var notificationsRef = path.collection('notifications')

  deleteCollection(db,notificationsRef,batchSize)

  var postListsRef = path.collection('postLists')

  deleteCollection(db,postListsRef,batchSize)

  var postsRef = path.collection('posts')

  deleteCollection(db,postsRef,batchSize)

  var usersSnapshot = await db.collection('users').orderBy('__name__').limit(batchSize).get()

  usersSnapshot.docs.forEach(async(doc)=>{
    doc.ref.update({
      'followed': admin.firestore.FieldValue.arrayRemove(userId),
      'followers':admin.firestore.FieldValue.arrayRemove(userId)
    })

    var userNotifications = await doc.ref.collection('notifications').get()

    userNotifications.docs.forEach((doc)=>{
      var sender = doc.data()['sender']
      if (sender == userId) doc.ref.delete()
    })

    var userPostsSnapshot = await doc.ref.collection('posts').get()

    userPostsSnapshot.docs.forEach((doc)=>{
      var commentsSnapshot = await doc.ref.collection('comments').get()

      commentsSnapshot.docs.forEach((doc)=>{
        var userCommentId = doc.data()['authorId']

        if(userCommentId == userId)doc.ref.delete()
      })
    })
  })

})

exports.newFollower = functions.region('europe-west2').firestore.document('users/{userId}').onUpdate(async (change, context) => {
  beforeFollowers = change.before.data()['followers']
  afterFollowers = change.after.data()['followers']

  if (beforeFollowers.length == afterFollowers.length) return 0

  var path = snap.ref

  var newFollower = afterFollowers[afterFollowers.length - 1]

  var userName = (await db.collection('users').doc(newFollower).get()).data()['userName']

  const notification = {
    title: 'Nuevo suscriptor',
    body: `${userName} te ha seguido`,
    sender: newFollower,
    dateTime: new Date(Date.now())
  };


  path.collection('notifications').add(notification)

})

exports.onCreateNotification = functions.region('europe-west2').firestore.document('users/{userId}/notifications/{notificationId}').onCreate(async (snap, context) => {
  var notification = snap.data()

  var sender = notification['sender']
  var post = notification['post']

  var senderName = (await db.collection('users').doc(sender).get()).data()['userName']

  const payload = {
    notification: {
      title: 'Nueva publicación',
      body: `${senderName} ha subido una nueva publicación`,
    },
    data: {
      post: post,
      sender: sender
    }
  };

  tokens = (await db.collection('users').doc(context.params.userId).get()).data()['tokens']

  tokens.forEach(token => {
    admin.messaging().sendToDevice(token, payload);
  });
})
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var db = admin.firestore()
var auth = admin.auth()

exports.onDeletePost = functions.region('europe-west2').firestore.document('users/{userId}/posts/{postId}').onDelete(async (snap, context) => {
  var path = snap.ref.path
  var batchSize = 500
  var commentsRef = snap.ref.collection('comments')

  deleteCollection(db, commentsRef, batchSize)

  var usersSnapshot = await db.collection('users').orderBy('__name__').limit(batchSize).get()

  usersSnapshot.docs.forEach(async (doc) => {
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

  // var mediaPath = snap.data()['mediaLocation']
  // var bucket = admin.storage().bucket()
  // bucket.file(mediaPath).delete()

  tagsSnapshot = await db.collection('tags').orderBy('__name__').limit(batchSize).get()
  var postId = context.params.postId

  tagsSnapshot.docs.forEach(function (doc) {
    var points = doc.data()['points']
    var totalPoints = doc.data()['totalPoints']
    delete points[postId]
    doc.ref.update({
      'posts': admin.firestore.FieldValue.arrayRemove(path),
      'points': points,
      'totalPoints': totalPoints - snap.data()['totalPoints']
    })
  })

  var userId = context.params.userId
  var userRef = db.doc(`users/${userId}`)
  var points = (await userRef.get()).data()['points']
  var totalPoints = doc.data()['totalPoints']
  delete points[postId]

  userRef.update({
    'points': points,
    'totalPoints': totalPoints - snap.data()['totalPoints']
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
  var ref = snap.ref
  var batchSize = 500
  var userId = context.params.userId

  var mediaPath = snap.data()['avatarLocation']
  if (mediaPath != '') {
    var bucket = admin.storage().bucket()
    bucket.file(mediaPath).delete()
  }

  var reportsRef = ref.collection('reports')

  deleteCollection(db, reportsRef, batchSize)

  var notificationsRef = ref.collection('notifications')

  deleteCollection(db, notificationsRef, batchSize)

  var postListsRef = ref.collection('postLists')

  deleteCollection(db, postListsRef, batchSize)

  var postsRef = ref.collection('posts')

  deleteCollection(db, postsRef, batchSize)

  var usersSnapshot = await db.collection('users').orderBy('__name__').limit(batchSize).get()

  usersSnapshot.docs.forEach(async (doc) => {
    doc.ref.update({
      'followed': admin.firestore.FieldValue.arrayRemove(userId),
      'followers': admin.firestore.FieldValue.arrayRemove(userId)
    })

    var userNotifications = await doc.ref.collection('notifications').get()

    userNotifications.docs.forEach((doc) => {
      var sender = doc.data()['sender']
      if (sender == userId) doc.ref.delete()
    })

    var userPostsSnapshot = await doc.ref.collection('posts').get()

    userPostsSnapshot.docs.forEach(async (doc) => {
      var commentsSnapshot = await doc.ref.collection('comments').get()

      commentsSnapshot.docs.forEach((doc) => {
        var userCommentId = doc.data()['authorId']

        if (userCommentId == userId) doc.ref.delete()
      })
    })
  })

})

exports.newFollower = functions.region('europe-west2').firestore.document('users/{userId}').onUpdate(async (change, context) => {
  beforeFollowers = change.before.data()['followers']
  afterFollowers = change.after.data()['followers']

  if (beforeFollowers.length == afterFollowers.length) return 0


  var newFollower = afterFollowers[afterFollowers.length - 1]

  var userName = (await db.collection('users').doc(newFollower).get()).data()['userName']

  const notification = {
    title: 'Nuevo suscriptor',
    body: `${userName} te ha seguido`,
    sender: newFollower,
    dateTime: new Date(Date.now())
  };


  snap.ref.collection('notifications').add(notification)

})

exports.avoidTag = functions.region('europe-west2').firestore.document('tags/{tagId}').onUpdate(async (change, context) => {
  if (change.after.data()['posts'].length == 0) change.after.ref.delete()
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

exports.onCreateReport = functions.region('europe-west2').firestore.document('users/{userId}/reports/{reportId}').onCreate(async (snap, context) => {
  var userId = context.params.userId
  var userRef = db.collection('users').doc(userId)
  var userData = (await userRef.get()).data()
  var userEmail = userData['email']
  var userFollowers = userData['followers'].length
  var minReports
  if (userFollowers < 400) minReports = 100
  else minReports = userFollowers * 0.25
  var oneMonthAgo = new Date(Date.now())
  oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1)
  var reports = userRef.collection('reports').limit(50).where('dateTime', '>=', admin.firestore.Timestamp.fromDate(oneMonthAgo))
  if ((await reports.get()).size > minReports) {
    var uid = (await auth.getUserByEmail(userEmail)).uid
    auth.updateUser(uid, {
      disabled: true
    })
  }
})

exports.onChangePostPoints = functions.region('europe-west2').firestore.document('users/{userId}/posts/{postId}').onUpdate(async (change, context) => {

  var newPoints = change.after.data()['points']
  var oldPoints = change.before.data()['points']
  
  const userKey = differentPoints(oldPoints, newPoints)
  if (userKey != null) {
    var postId = context.params.postId
    var postRef = change.after.ref
    var userId = context.params.userId
    var userRef = db.doc(`users/${userId}`)

    var oldUserPoints = oldPoints[userKey] || 0;
    var newUserPoints = newPoints[userKey];
    console.log(oldUserPoints)
  console.log(newUserPoints)

    var postOldTotalPoints = change.before.data()['totalPoints']
    var postNewTotalPoints = postOldTotalPoints - oldUserPoints + newUserPoints
    console.log(postOldTotalPoints)
  console.log(postNewTotalPoints)
    // postRef.update({
    //   'totalPoints': postNewTotalPoints
    // })

    var userData = (await userRef.get()).data()
    var userPoints = userData['points']
    userPoints[postId] = postNewTotalPoints
    var userOldTotalPoints = userData['totalPoints']
    var userNewTotalPoints = userOldTotalPoints - postOldTotalPoints + postNewTotalPoints

    userRef.update({
      'points': userPoints,
      'totalPoints': userNewTotalPoints
    })

    var tags = change.before.data()['tags']
    tags.forEach(async tag => {
      var tagRef = db.doc(`tags/${tag}`)
      var tagData = (await tagRef.get()).data()
      var tagPoints = tagData['points']
      tagPoints[postId] = postNewTotalPoints
      var tagOldTotalPoints = userData['totalPoints']
      var tagNewTotalPoints = tagOldTotalPoints - postOldTotalPoints + postNewTotalPoints

      tagRef.update({
        'points': tagPoints,
        'totalPoints': tagNewTotalPoints
      })

    });
  }
})

function differentPoints(oldPoints, newPoints) {
  for (const key in newPoints) {
    if (!oldPoints.hasOwnProperty(key)) return key
    else {
      const oldElement = oldPoints[key]
      const newElement = newPoints[key]
      if (oldElement != newElement) return key
    }
  }
  return null
}
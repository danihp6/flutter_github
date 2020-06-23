import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import '../Models/Notification.dart';

final firestore = Firestore.instance;

//---------------USER----------------//

Stream<User> getUser(String userId) => firestore
    .document('users/$userId')
    .snapshots()
    .map((doc) => User.fromFirestore(doc));

Future editUser(String userId, String name, String description, String avatar,
        String avatarLocation) =>
    firestore.document('users/$userId').updateData({
      'name': name,
      'description': description,
      'avatar': avatar,
      'avatarLocation': avatarLocation
    });

Stream<List<String>> getFollowers(String userId) => firestore
    .document('users/$userId')
    .snapshots()
    .map((doc) => List<String>.from(doc.data['followers']));

Stream<List<String>> getFollowed(String userId) => firestore
    .document('users/$userId')
    .snapshots()
    .map((doc) => List<String>.from(doc.data['followed']));

Future<List<User>> userSearch(String search) async {
  var query = await firestore
      .collection('users')
      .where('keyWords', arrayContains: search)
      .getDocuments();
  return query.documents.map((doc) => User.fromFirestore(doc)).toList();
}

//---------------POST----------------//

Stream<Post> getPost(String postPath) => firestore
    .document(postPath)
    .snapshots()
    .map((doc) => Post.fromFirestore(doc));

Stream<List<Post>> getPosts(String userId) => firestore
    .collection('users/$userId/posts')
    .orderBy('dateTime', descending: true)
    .snapshots()
    .map(toPosts);

Stream<List<Post>> getLastlyPosts(String userId) => firestore
    .collection('users/$userId/posts')
    .where('dateTime',
        isGreaterThan: DateTime.now().subtract(Duration(days: 5)))
    .snapshots()
    .map(toPosts);

Future addPostPathInPostList(String userId, String postId, String postListId) =>
    firestore.document('users/$userId/postLists/$postListId').updateData({
      'posts': FieldValue.arrayUnion(['users/$userId/posts/$postId'])
    });

Future deletePostPathInPostList(
        String userId, String postListId, String postPath) =>
    firestore.document('users/$userId/postLists/$postListId').updateData({
      'posts': FieldValue.arrayRemove([postPath])
    });

Stream<List<String>> getPostsPathFromPostList(
        String userId, String postListId) =>
    firestore
        .document('users/$userId/postLists/$postListId')
        .snapshots()
        .map((doc) => List<String>.from(doc.data['posts']));
Stream<List<String>> getPostsPathFromFavourites(String userId) => firestore
    .document('users/$userId')
    .snapshots()
    .map((doc) => List<String>.from(doc.data['favourites']));

Future addPostPathInFavourites(String userId, String postPath) {
  firestore.document(postPath).updateData({
    'favourites': FieldValue.arrayUnion([userId])
  });
  firestore.document('users/$userId').updateData({
    'favourites': FieldValue.arrayUnion([postPath])
  });
}

Future deletePostPathInFavourites(String userId, String postPath) {
  firestore.document(postPath).updateData({
    'favourites': FieldValue.arrayRemove([userId])
  });
  firestore.document('users/$userId').updateData({
    'favourites': FieldValue.arrayRemove([postPath])
  });
}

Future newPost(String userId, Post post) =>
    firestore.collection('users/$userId/posts').add(post.toFirestore());

Future deletePost(String userId, String postId) =>
    firestore.document('users/$userId/posts/$postId').delete();

Stream<List<String>> getPostFavourites(String userId, String postId) =>
    firestore
        .document('users/$userId/posts/$postId')
        .snapshots()
        .map((doc) => List<String>.from(doc.data['favourites']));

Future<List<String>> postSearch(String search) async {
  List<String> keyWordsSearched = search.split(' ');
  QuerySnapshot userQuery = await firestore.collection('users').getDocuments();
  List<String> postsId = [];

  for (var userSnap in userQuery.documents) {
    var postQuery = await userSnap.reference
        .collection('posts')
        .where('keyWords', arrayContainsAny: keyWordsSearched)
        .getDocuments();
    for (var postSnap in postQuery.documents) {
      postsId.add('users/${userSnap.documentID}/posts/${postSnap.documentID}');
    }
  }
  //ORDENAR POR IMPORTANCIA
  return postsId;
}

//---------------POSTLIST----------------//

Stream<PostList> getPostList(String postListPath) => firestore
    .document(postListPath)
    .snapshots()
    .map((doc) => PostList.fromFirestore(doc));

Stream<List<PostList>> getPostLists(String userId) => firestore
    .collection('users/$userId/postLists')
    .orderBy('dateTime', descending: true)
    .snapshots()
    .map(toPostLists);

Future newPostList(String userId, PostList postList) =>
    firestore.collection('users/$userId/postLists').add(postList.toFirestore());

Future deletePostList(String userId, String postListId) =>
    firestore.document('users/$userId/postLists/$postListId').delete();

Future<List<String>> postListSearch(String search) async {
  List<String> keyWordsSearched = search.split(' ');
  QuerySnapshot userQuery = await firestore.collection('users').getDocuments();
  List<String> postListsId = [];

  for (var userSnap in userQuery.documents) {
    var postQuery = await userSnap.reference
        .collection('postLists')
        .where('keyWords', arrayContainsAny: keyWordsSearched)
        .getDocuments();
    for (var postSnap in postQuery.documents) {
      postListsId
          .add('users/${userSnap.documentID}/postLists/${postSnap.documentID}');
    }
  }
  //ORDENAR POR IMPORTANCIA
  return postListsId;
}

//---------------COMMENTS----------------//

Stream<List<Comment>> getComments(String userId, String postId) => firestore
    .collection('users/$userId/posts/$postId/comments')
    .snapshots()
    .map(toCommentList);

Stream<Comment> getBestComment(String userId, String postId) => firestore
    .collection('users/$userId/posts/$postId/comments')
    .orderBy('likes')
    .limit(1)
    .snapshots()
    .map((snap) => Comment.fromFirestore(snap.documents.first));

Future newComment(String userId, String postId, Comment comment) => firestore
    .collection('users/$userId/posts/$postId/comments')
    .add(comment.toFirestore());

//---------------NOTIFICATIONS----------------//

Stream<List<Notification>> getNotifications(String userId) => firestore
    .collection('users/$userId/notifications')
    .snapshots()
    .map((toNotificationList));

Future newNotification(String userId, Notification notification) => firestore
    .collection('users/$userId/notifications')
    .add(notification.toFirestore());
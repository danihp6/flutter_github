import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';
import '../Models/Notification.dart';

class DataBase {
  final _firestore = Firestore.instance;

  String _userId;

  get userId => this._userId;

  set userId(userId) => this._userId = userId;

//---------------USER----------------//

  Stream<User> getUser(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => User.fromFirestore(doc));

  Future<String> getUserByEmail(String email) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    return query.documents[0].documentID;
  }

  Future editUser(String userId, String name, String description, String avatar,
          String avatarLocation) =>
      _firestore.document('users/$userId').updateData({
        'name': name,
        'description': description,
        'avatar': avatar,
        'avatarLocation': avatarLocation
      });

  Stream<List<String>> getFollowers(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => List<String>.from(doc.data['followers']));

  Stream<List<String>> getFollowed(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => List<String>.from(doc.data['followed']));

  Future<List<User>> userSearch(String search) async {
    var query = await _firestore
        .collection('users')
        .where('keyWords', arrayContains: search)
        .getDocuments();
    return query.documents.map((doc) => User.fromFirestore(doc)).toList();
  }

  Future newUser(User user) =>
      _firestore.collection('users').add(user.toFirestore());

  Future<bool> userNameExists(String userName) async{
    QuerySnapshot query = await _firestore.collection('users').where('userName',isEqualTo: userName).getDocuments();
    return query.documents.length > 0;
  }

  Future follow(String userId,String followedId)=> _firestore.document('users/$userId').updateData({
    'followed': FieldValue.arrayUnion([followedId])
  });

  Future unfollow(String userId,String unfollowedId)=> _firestore.document('users/$userId').updateData({
    'followed': FieldValue.arrayRemove([unfollowedId])
  });

//---------------POST----------------//

  Stream<Post> getPost(String postPath) => _firestore
      .document(postPath)
      .snapshots()
      .map((doc) => Post.fromFirestore(doc));

  Stream<List<Post>> getPosts(String userId) => _firestore
      .collection('users/$userId/posts')
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map(toPosts);

  Stream<List<Post>> getLastlyPosts(String userId) => _firestore
      .collection('users/$userId/posts')
      .where('dateTime',
          isGreaterThan: DateTime.now().subtract(Duration(days: 5)))
      .snapshots()
      .map(toPosts);

  Future addPostPathInPostList(
          String userId, String postId, String postListId) =>
      _firestore.document('users/$userId/postLists/$postListId').updateData({
        'posts': FieldValue.arrayUnion(['users/$userId/posts/$postId'])
      });

  Future deletePostPathInPostList(
          String userId, String postListId, String postPath) =>
      _firestore.document('users/$userId/postLists/$postListId').updateData({
        'posts': FieldValue.arrayRemove([postPath])
      });

  Stream<List<String>> getPostsPathFromPostList(
          String userId, String postListId) =>
      _firestore
          .document('users/$userId/postLists/$postListId')
          .snapshots()
          .map((doc) => List<String>.from(doc.data['posts']));
  Stream<List<String>> getPostsPathFromFavourites(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => List<String>.from(doc.data['favourites']));

  Future addPostPathInFavourites(String userId, String postPath) {
    _firestore.document(postPath).updateData({
      'favourites': FieldValue.arrayUnion([userId])
    });
    _firestore.document('users/$userId').updateData({
      'favourites': FieldValue.arrayUnion([postPath])
    });
  }

  Future deletePostPathInFavourites(String userId, String postPath) {
    _firestore.document(postPath).updateData({
      'favourites': FieldValue.arrayRemove([userId])
    });
    _firestore.document('users/$userId').updateData({
      'favourites': FieldValue.arrayRemove([postPath])
    });
  }

  Future newPost(String userId, Post post) =>
      _firestore.collection('users/$userId/posts').add(post.toFirestore());

  Future deletePost(String userId, String postId) =>
      _firestore.document('users/$userId/posts/$postId').delete();

  Stream<List<String>> getPostFavourites(String userId, String postId) =>
      _firestore
          .document('users/$userId/posts/$postId')
          .snapshots()
          .map((doc) => List<String>.from(doc.data['favourites']));

  Future<List<String>> postSearch(String search) async {
    List<String> keyWordsSearched = search.split(' ');
    QuerySnapshot userQuery =
        await _firestore.collection('users').getDocuments();
    List<String> postsId = [];

    for (var userSnap in userQuery.documents) {
      var postQuery = await userSnap.reference
          .collection('posts')
          .where('keyWords', arrayContainsAny: keyWordsSearched)
          .getDocuments();
      for (var postSnap in postQuery.documents) {
        postsId
            .add('users/${userSnap.documentID}/posts/${postSnap.documentID}');
      }
    }
    //ORDENAR POR IMPORTANCIA
    return postsId;
  }

//---------------POSTLIST----------------//

  Stream<PostList> getPostList(String postListPath) => _firestore
      .document(postListPath)
      .snapshots()
      .map((doc) => PostList.fromFirestore(doc));

  Stream<List<PostList>> getPostLists(String userId) => _firestore
      .collection('users/$userId/postLists')
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map(toPostLists);

  Future newPostList(String userId, PostList postList) => _firestore
      .collection('users/$userId/postLists')
      .add(postList.toFirestore());

  Future deletePostList(String userId, String postListId) =>
      _firestore.document('users/$userId/postLists/$postListId').delete();

  Future<List<String>> postListSearch(String search) async {
    List<String> keyWordsSearched = search.split(' ');
    QuerySnapshot userQuery =
        await _firestore.collection('users').getDocuments();
    List<String> postListsId = [];

    for (var userSnap in userQuery.documents) {
      var postQuery = await userSnap.reference
          .collection('postLists')
          .where('keyWords', arrayContainsAny: keyWordsSearched)
          .getDocuments();
      for (var postSnap in postQuery.documents) {
        postListsId.add(
            'users/${userSnap.documentID}/postLists/${postSnap.documentID}');
      }
    }
    //ORDENAR POR IMPORTANCIA
    return postListsId;
  }

//---------------COMMENTS----------------//

  Stream<List<Comment>> getComments(String userId, String postId) => _firestore
      .collection('users/$userId/posts/$postId/comments')
      .snapshots()
      .map(toCommentList);

  Stream<Comment> getBestComment(String userId, String postId) => _firestore
      .collection('users/$userId/posts/$postId/comments')
      .orderBy('likes')
      .limit(1)
      .snapshots()
      .map((snap) => Comment.fromFirestore(snap.documents.first));

  Future newComment(String userId, String postId, Comment comment) => _firestore
      .collection('users/$userId/posts/$postId/comments')
      .add(comment.toFirestore());

//---------------NOTIFICATIONS----------------//

  Stream<List<Notification>> getNotifications(String userId) => _firestore
      .collection('users/$userId/notifications')
      .snapshots()
      .map((toNotificationList));

  Future newNotification(String userId, Notification notification) => _firestore
      .collection('users/$userId/notifications')
      .add(notification.toFirestore());

  Future deleteNotification(String userId, String notificationId) => _firestore
      .document('users/$userId/notifications/$notificationId')
      .delete();
}

DataBase db = new DataBase();

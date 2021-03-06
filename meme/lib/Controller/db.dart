import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/Tag.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Models/User.dart';
import '../Models/Notification.dart' as mynotification;
import 'media_storage.dart';
import '../Models/Report.dart';

class DataBase {
  final _firestore = Firestore.instance;

  String _userId;

  get userId => this._userId;

  set userId(userId) => this._userId = userId;

//---------------USER----------------//

  Stream<User> getUser(String userId) {
    return _firestore
        .document('users/$userId')
        .snapshots()
        .map((doc) => User.fromFirestore(doc));
  }

  Future<User> getUserFuture(String userId) async =>
      User.fromFirestore(await _firestore.document('users/$userId').get());

  Future<String> getUserByEmail(
      Function showDialogUserName, String email) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    if (query.documents.isEmpty) {
      String userName = await showDialogUserName();
      String token = await pushProvider.getToken();
      return await db.newUser(
        User(userName, '', <String>[], <String>[], <String>[], '',
            DateTime.now(), email, [token], <String>[]),
      );
    }
    return query.documents.first.documentID;
  }

  Future editUser(String userId, String name, String description, String avatar,
      ImageMedia imageMedia) async {
    if (imageMedia != null) {
      if (avatar != '') mediaStorage.deleteAvatar(userId);
      avatar = await mediaStorage.uploadAvatar(imageMedia, userId);
    }
    _firestore.document('users/$userId').updateData({
      'userName': name,
      'description': description,
      'avatar': avatar,
    });
  }

  Stream<List<String>> getFollowers(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => List<String>.from(doc.data['followers']));

  Stream<List<String>> getFollowed(String userId) => _firestore
      .document('users/$userId')
      .snapshots()
      .map((doc) => List<String>.from(doc.data['followed']));

  Future<List<String>> userSearch(String search) async {
    var query = await _firestore
        .collection('users')
        .where('keyWords', arrayContains: search)
        .orderBy('followers', descending: true)
        .getDocuments();
    return query.documents.map((doc) => doc.documentID).toList();
  }

  Future<String> newUser(User user) async =>
      (await _firestore.collection('users').add(user.toFirestore())).documentID;

  Future<bool> userNameExists(String userName) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('userName', isEqualTo: userName)
        .getDocuments();
    return query.documents.length > 0;
  }

  Future follow(String userId, String followedId) {
    _firestore.document('users/$userId').updateData({
      'followed': FieldValue.arrayUnion([followedId])
    });
    _firestore.document('users/$followedId').updateData({
      'followers': FieldValue.arrayUnion([userId])
    });
  }

  Future unfollow(String userId, String unfollowedId) {
    _firestore.document('users/$userId').updateData({
      'followed': FieldValue.arrayRemove([unfollowedId])
    });

    _firestore.document('users/$unfollowedId').updateData({
      'followers': FieldValue.arrayRemove([userId])
    });
  }

  Future block(String userId, String blockedUser) {
    _firestore.document('users/$userId').updateData({
      'blockedUsers': FieldValue.arrayUnion([blockedUser])
    });
  }

  Future unblock(String userId, String blockedUser) {
    _firestore.document('users/$userId').updateData({
      'blockedUsers': FieldValue.arrayRemove([blockedUser])
    });
  }

  Future<String> userIdByUserName(String userName) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('userName', isEqualTo: userName)
        .getDocuments();
    return query.documents.first.documentID;
  }

  Future deleteUser(String userId) {
    _firestore.document('users/$userId').delete();
  }

//---------------POST----------------//

  Stream<Post> getPost(String userId, String postId) => _firestore
      .document('users/$userId/posts/$postId')
      .snapshots()
      .map((doc) => Post.fromFirestore(doc));

  // Stream<Post> getPostByPath(String postPath) => _firestore
  //     .document(postPath)
  //     .snapshots()
  //     .map((doc) => Post.fromFirestore(doc));

  Stream<List<Post>> getTagGroupPost(String tagId) => _firestore
      .collectionGroup('posts')
      .where('tags', arrayContains: tagId)
      .snapshots()
      .map(toPosts);

  Stream<List<Post>> getPostListGroupPost(String postListId) => _firestore
      .collectionGroup('posts')
      .where('postLists', arrayContains: postListId)
      .snapshots()
      .map(toPosts);

    Stream<List<Post>> getFavouriteGroupPost(String userId) => _firestore
      .collectionGroup('posts')
      .where('favourites', arrayContains: userId)
      .snapshots()
      .map(toPosts);

  Stream<List<Post>> getPosts(String userId) => _firestore
      .collection('users/$userId/posts')
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map(toPosts);

  Stream<List<Post>> getLastlyPosts(String userId) => _firestore
      .collection('users/$userId/posts')
      .orderBy('dateTime', descending: true)
      .limit(100)
      .snapshots()
      .map(toPosts);

  Future addPostInPostList(
      String userId, String postId, String authorPostId, String postListId) {
    _firestore.document('users/$authorPostId/posts/$postId').updateData({
      'postLists': FieldValue.arrayUnion([postListId])
    });
    _firestore.document('users/$userId/postLists/$postListId').updateData({
      'posts': FieldValue.arrayUnion([postId])
    });
  }

  Future deletePostInPostList(
      String userId, String postListId, String authorPostId, String postId) {
    _firestore.document('users/$authorPostId/posts/$postId').updateData({
      'postLists': FieldValue.arrayRemove([postListId])
    });
    _firestore.document('users/$userId/postLists/$postListId').updateData({
      'posts': FieldValue.arrayRemove([postId])
    });
  }

  Future addPostInFavourites(
      String userId, String postAuthorId, String postId) {
    _firestore.document('users/$postAuthorId/posts/$postId').updateData({
      'favourites': FieldValue.arrayUnion([userId])
    });
    _firestore.document('users/$userId').updateData({
      'favourites': FieldValue.arrayUnion([postId])
    });
  }

  Future deletePostInFavourites(
      String userId, String postAuthorId, String postId) {
    _firestore.document('users/$postAuthorId/posts/$postId').updateData({
      'favourites': FieldValue.arrayRemove([userId])
    });
    _firestore.document('users/$userId').updateData({
      'favourites': FieldValue.arrayRemove([postId])
    });
  }

  Future<String> newPost(String userId, Post post, MyMedia media) async {
    DocumentReference ref = await _firestore
        .collection('users/$userId/posts')
        .add(post.toFirestore());
    String id = ref.documentID;

    String mediaUrl = await mediaStorage.uploadMedia(media, userId, id);
    ref.updateData({'media': mediaUrl});
    return id;
  }

  Future deletePost(String userId, String postId) =>
      _firestore.document('users/$userId/posts/$postId').delete();

  Stream<List<String>> getPostFavourites(String userId, String postId) {
    //print(userId + '                          ' + postId);
    return _firestore
        .document('users/$userId/posts/$postId')
        .snapshots()
        .map((doc) => List<String>.from(doc.data['favourites']));
  }

  Future<List<String>> postSearch(String search) async {
    List<String> keyWordsSearched = search.split(' '); //CAMBIARRRRRR
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

  Future changeHotPoints(
      String authorId, String postId, String userId, int pointsUser) async {
    DocumentReference ref =
        _firestore.document('users/$authorId/posts/$postId');
    final data = (await ref.get()).data;
    Map<String, dynamic> points = data['points'];
    int totalPoints = data['totalPoints'];
    int oldPoints = points[userId] ?? 0;
    points[userId] = pointsUser;
    ref.updateData({
      'points': points,
      'totalPoints': totalPoints - oldPoints + pointsUser
    });
  }

  Stream<List<Post>> getFollowedPosts(List<String> followed) {
    return _firestore
        .collectionGroup('posts')
        .where('author', whereIn: followed)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(toPosts);
  }

//---------------POSTLIST----------------//

  Stream<PostList> getPostList(String userId, String postListId) => _firestore
      .document('users/$userId/postLists/$postListId')
      .snapshots()
      .map((doc) => PostList.fromFirestore(doc));

  // Stream<PostList> getPostListByPath(String postListPath) => _firestore
  //     .document(postListPath)
  //     .snapshots()
  //     .map((doc) => PostList.fromFirestore(doc));

  Stream<List<PostList>> getPostLists(String userId) => _firestore
      .collection('users/$userId/postLists')
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map(toPostLists);

  Future newPostList(
      String userId, PostList postList, ImageMedia imageMedia) async {
    DocumentReference ref = await _firestore
        .collection('users/$userId/postLists')
        .add(postList.toFirestore());

    if (imageMedia != null) {
      String id = ref.documentID;
      String postListImageUrl =
          await mediaStorage.uploadMedia(imageMedia, userId, id);
      ref.updateData({'image': postListImageUrl});
    }
  }

  Future copyPostList(String userId, PostList postList) => _firestore
      .collection('users/$userId/postLists')
      .add(postList.toFirestore());

  Future deletePostList(String userId, String postListId) =>
      _firestore.document('users/$userId/postLists/$postListId').delete();

  Future<List<String>> postListSearch(String search) async {
    QuerySnapshot userQuery =
        await _firestore.collection('users').getDocuments();
    List<String> postListsId = [];

    for (var userSnap in userQuery.documents) {
      var postQuery = await userSnap.reference
          .collection('postLists')
          .where('keyWords', arrayContains: search)
          .getDocuments();
      for (var postSnap in postQuery.documents) {
        postListsId.add(
            'users/${userSnap.documentID}/postLists/${postSnap.documentID}');
      }
    }
    return postListsId;
  }

//---------------COMMENTS----------------//

  Stream<Comment> getComment(String userId, String postId, String commentId) =>
      _firestore
          .document('users/$userId/posts/$postId/comments/$commentId')
          .snapshots()
          .map((doc) => Comment.fromFirestore(doc));

  Stream<List<Comment>> getComments(String userId, String postId) => _firestore
      .collection('users/$userId/posts/$postId/comments')
      .snapshots()
      .map(toCommentList);

  Stream<List<Comment>> getOuterComments(String userId, String postId) =>
      _firestore
          .collection('users/$userId/posts/$postId/comments')
          .where('level', isEqualTo: 0)
          .orderBy('likes', descending: true)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map(toCommentList);

  Stream<Comment> getBestComment(String userId, String postId) => _firestore
      .collection('users/$userId/posts/$postId/comments')
      .orderBy('likes', descending: true)
      .limit(1)
      .snapshots()
      .map((snap) => Comment.fromFirestore(snap.documents.first));

  Future<String> newComment(
      String userPostId, String postId, Comment comment) async {
    DocumentReference ref = await _firestore
        .collection('users/$userPostId/posts/$postId/comments')
        .add(comment.toFirestore());
    return ref.documentID;
  }

  Future newOuterComment(String userPostId, String postId, Comment comment) =>
      newComment(userPostId, postId, comment);

  Future newInnerComment(String userPostId, String postId,
      String outerCommentId, Comment comment) async {
    String id = await newComment(userPostId, postId, comment);
    _firestore
        .document('users/$userPostId/posts/$postId/comments/$outerCommentId')
        .updateData({
      'comments': FieldValue.arrayUnion([id])
    });
  }

  Future deleteComment(String userPostId, String postId, String commentId) =>
      _firestore
          .document('users/$userPostId/posts/$postId/comments/$commentId')
          .delete();

  Future deleteOuterComment(
          String userPostId, String postId, String commentId) =>
      deleteComment(userPostId, postId, commentId);

  Future deleteInnerComment(String userPostId, String postId,
      String outerCommentId, String commentId) {
    _firestore
        .document('users/$userPostId/posts/$postId/comments/$outerCommentId')
        .updateData({
      'comments': FieldValue.arrayRemove([commentId])
    });
    deleteComment(userPostId, postId, commentId);
  }

  Future likeComment(
          String userPostId, String postId, String commentId, String userId) =>
      _firestore
          .document('users/$userPostId/posts/$postId/comments/$commentId')
          .updateData({
        'likes': FieldValue.arrayUnion([userId])
      });

  Future unlikeComment(
          String userPostId, String postId, String commentId, String userId) =>
      _firestore
          .document('users/$userPostId/posts/$postId/comments/$commentId')
          .updateData({
        'likes': FieldValue.arrayRemove([userId])
      });

//---------------NOTIFICATIONS----------------//

  Stream<List<mynotification.Notification>> getNotifications(String userId) =>
      _firestore
          .collection('users/$userId/notifications')
          .snapshots()
          .map((mynotification.toNotificationList));

  Future newNotification(
          String userId, mynotification.Notification notification) =>
      _firestore
          .collection('users/$userId/notifications')
          .add(notification.toFirestore());

  Future deleteNotification(String userId, String notificationId) => _firestore
      .document('users/$userId/notifications/$notificationId')
      .delete();

//---------------TAGS----------------//

  Stream<List<Tag>> getTendTags() => _firestore
      .collection('tags')
      .orderBy('totalPoints', descending: true)
      .limit(10)
      .snapshots()
      .map(toTagLists);

  Stream<Tag> getTag(String tagId) => _firestore
      .document('tags/$tagId')
      .snapshots()
      .map((doc) => Tag.fromFirestore(doc));

  Future<String> getTagId(String tagName) async {
    String id = '';
    QuerySnapshot query = await _firestore.collection('tags').getDocuments();
    query.documents.forEach((doc) {
      if (doc.data['name'] == tagName) id = doc.documentID;
    });
    return id;
  }

  Future<String> addTag(Tag tag) async {
    DocumentReference ref =
        await _firestore.collection('tags').add(tag.toFirestore());
    return ref.documentID;
  }

  Future<List<String>> createTags(List<Tag> tags) async {
    return Future.wait(tags.map((tag) async {
      String id = await getTagId(tag.name);
      if (id != '')
        return id;
      else
        return await addTag(tag);
    }));
  }

  Future addPostToTag(String tagId, String postAuthorId, String postId) {
    _firestore.document('tags/$tagId').updateData({
      'posts': FieldValue.arrayUnion([postId])
    });
  }

  Future<List<Tag>> tagSearch(String search) async {
    var query = await _firestore
        .collection('tags')
        .where('keyWords', arrayContains: search)
        .getDocuments();
    return query.documents.map((doc) => Tag.fromFirestore(doc)).toList();
  }

  //---------------REPORTS----------------//
  Future newReport(String reportedUserId, Report report) => _firestore
      .collection('users/$reportedUserId/reports')
      .add(report.toFirestore());

  Future<bool> reporter(String reportedUserId, String reporterId) async =>
      (await _firestore
              .collection('users/$reportedUserId/reports')
              .where('author', isEqualTo: reporterId)
              .getDocuments())
          .documents
          .length >
      0;

  //---------------TEMPLATES----------------//
  Stream<List<Template>> getTemplates() => _firestore
      .collection('templates')
      .orderBy('dateTime', descending: true)
      .snapshots()
      .map(toTemplates);

  Stream<Template> getTemplate(String id) => _firestore
      .document('templates/$id')
      .snapshots()
      .map((doc) => Template.fromFirestore(doc));
}

DataBase db = new DataBase();

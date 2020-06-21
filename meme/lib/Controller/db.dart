import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Post.dart';
import 'package:meme/Models/PostList.dart';
import 'package:meme/Models/User.dart';

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
      .where('userName', isGreaterThan: search)
      .getDocuments();
  return query.documents.map((doc) => User.fromFirestore(doc));
}

//---------------POST----------------//

Stream<Post> getPost(String postPath) => firestore
    .document(postPath)
    .snapshots()
    .map((doc) => Post.fromFirestore(doc));

Stream<List<Post>> getPosts(String userId) =>
    firestore.collection('users/$userId/posts').snapshots().map(toPosts);

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

//---------------POSTLIST----------------//

Stream<List<PostList>> getPostLists(String userId) => firestore
    .collection('users/$userId/postLists')
    .snapshots()
    .map(toPostLists);

Future newPostList(String userId, PostList postList) =>
    firestore.collection('users/$userId/postLists').add(postList.toFirestore());

Future deletePostList(String userId, String postListId) =>
    firestore.document('users/$userId/postLists/$postListId').delete();

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

// Stream<List<Publication>> getPublicationsFromFollowedAndUser(String userId) {
//   return firestore
//       .document('Users/$userId')
//       .snapshots()
//       .asyncMap((userSnap) async {
//     List<Publication> publications = <Publication>[];

//     String userFavouriteCategoryId = userSnap.data['publications'];
//     DocumentSnapshot userFavouriteCategorySnap = await firestore.document('FavouritesCategories/$userFavouriteCategoryId').get();
//     List<String> userPublicationsId = List<String>.from(userFavouriteCategorySnap.data['publications']);
//     for (var publicationId in userPublicationsId) {
//       publications.add(Publication.fromFirestore(
//           await firestore.document('Publications/$publicationId').get()));
//     }

//     List<String> followedId = List<String>.from(userSnap.data['followed']);
//     List<String> followedPublicationsId = <String>[];
//     for (var id in followedId) {
//       DocumentSnapshot followedSnap =
//           await firestore.document('Users/$id').get();
//       followedPublicationsId.add(followedSnap.data['publications']);
//     }
//     List<String> publicationsId = <String>[];
//     for (var id in followedPublicationsId) {
//       DocumentSnapshot followedPublicationsSnap =
//           await firestore.document('FavouritesCategories/$id').get();
//       publicationsId.addAll(
//           List<String>.from(followedPublicationsSnap.data['publications']));
//     }
//     for (var publicationId in publicationsId) {
//       publications.add(Publication.fromFirestore(
//           await firestore.document('Publications/$publicationId').get()));
//     }
//     return publications;
//   });
//   // return firestore.document('FavouritesCategories/$favouriteCategoryId').snapshots().asyncMap((snap) async {
//   //   List<String> publicationsId = List<String>.from(snap.data['publications']);
//   //   var publications = <Publication>[];
//   //   for (var publicationId in publicationsId) {
//   //     publications.add(Publication.fromFirestore(await firestore.document('Publications/$publicationId').get()));
//   //   }
//   //   return publications;
//   // });
// }

// // Stream<Comment> getComment(String publicationId, String commentId) {
// //   return firestore
// //       .document('Publications/$publicationId/comments/$commentId')
// //       .snapshots()
// //       .map((doc) => Comment.fromFirestore(doc));
// // }

// Future<void> newComment(String publicationId, Comment comment) {
//   return firestore
//       .collection('Publications/$publicationId/comments')
//       .add(comment.toFirestore());
// }

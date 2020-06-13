import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/Publication.dart';
import 'package:meme/Models/User.dart';

final firestore = Firestore.instance;

Stream<User> getUser(String userId) {
  return firestore
      .document('Users/$userId')
      .snapshots()
      .map((doc) => User.fromFirestore(doc));
}

// Stream<List<FavouriteCategory>> getFavouritesCategories(String userId) {
//   return firestore
//       .collection('Users/$userId/favouritesCategories')
//       .snapshots()
//       .map(toFavouriteCategoryList);
// }

Stream<FavouriteCategory> getFavouriteCategory(String favouriteCategoryId) {
  return firestore
      .document('FavouritesCategories/$favouriteCategoryId')
      .snapshots()
      .map((doc) => FavouriteCategory.fromFirestore(doc));
}

Future<void> newFavouriteCategory(FavouriteCategory favouriteCategory) async {
  firestore
      .collection('FavouritesCategories')
      .add(favouriteCategory.toFirestore())
      .then((doc) {
    firestore.document('Users/${favouriteCategory.getAuthorId()}').updateData({
      'favouritesCategories': FieldValue.arrayUnion([doc.documentID])
    });
  });
}

Future<void> addPublicationInFavouriteCategory(
    String userId, String favouriteCategoryId, Publication publication) async {
  firestore
      .document('Users/$userId/favouritesCategories/$favouriteCategoryId')
      .updateData({
    'publications': FieldValue.arrayUnion([publication])
  });
}

Future<void> deleteFavouriteCategory(FavouriteCategory favouriteCategory) async {
  DocumentReference doc = firestore.document('FavouritesCategories/${favouriteCategory.getId()}');
  firestore.document('Users/${favouriteCategory.getAuthorId()}').updateData({
    'favouritesCategories': FieldValue.arrayRemove([doc.documentID])
  });
  doc.delete();
}

Stream<List<Publication>> getPublications(String author) {
  return firestore
      .collection('Publications')
      .where('author', isEqualTo: 'author')
      .snapshots()
      .map(toPublicationList);
}

Stream<Publication> getPublication(String publicationId) {
  return firestore
      .document('Publications/$publicationId')
      .snapshots()
      .map((doc) => Publication.fromFirestore(doc));
}

Future<void> newPublication(String userId, Publication publication) async {
  firestore.collection('Publications').add(publication.toFirestore());
}

Stream<List<Comment>> getComments(String publicationId) {
  return firestore
      .collection('Publications/$publicationId/comments')
      .snapshots()
      .map(toCommentList);
}

Stream<Comment> getComment(String publicationId, String commentId) {
  return firestore
      .document('Publications/$publicationId/comments/$commentId')
      .snapshots()
      .map((doc) => Comment.fromFirestore(doc));
}

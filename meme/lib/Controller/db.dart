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

// Future<void> addPublicationInFavouriteCategory(
//     String userId, String favouriteCategoryId, Publication publication) async {
//   firestore
//       .document('Users/$userId/favouritesCategories/$favouriteCategoryId')
//       .updateData({
//     'publications': FieldValue.arrayUnion([publication])
//   });
// }

Future<void> deleteFavouriteCategory(
    FavouriteCategory favouriteCategory) async {
  DocumentReference doc =
      firestore.document('FavouritesCategories/${favouriteCategory.getId()}');
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
  firestore
      .collection('Publications')
      .add(publication.toFirestore())
      .then((publicationDoc) {
    firestore.document('Users/$userId').get().then((doc) {
      firestore
          .document('FavouritesCategories/${doc.data['publications']}')
          .updateData({
        'publications': FieldValue.arrayUnion([publicationDoc.documentID])
      });
      newComment(
          publicationDoc.documentID,
          new Comment(publication.getDescription(), <String>[], userId,
              DateTime.now(), publicationDoc.documentID, <String>[], 0));
    });
  });
}

Future<void> deletePublication(Publication publication) async {
  DocumentReference doc =
      firestore.document('Publications/${publication.getId()}');
  firestore
      .document('Users/${publication.getAuthorId()}')
      .get()
      .then((userDoc) {
        print(userDoc.data['publications']);
    firestore
        .document('FavouritesCategories/${userDoc.data['publications']}')
        .updateData({
      'favouritesCategories': FieldValue.arrayRemove([doc.documentID])
    }).then((_) => doc.delete());
    
  });
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

Future<void> newComment(String publicationId, Comment comment) {
  return firestore
      .collection('Publications/$publicationId/comments')
      .add(comment.toFirestore());
}

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
  DocumentReference favouriteCategoryDoc =
      firestore.document('FavouritesCategories/${favouriteCategory.getId()}');
  firestore
      .collection('Users')
      .getDocuments()
      .then((query) => query.documents.forEach((doc) {
            doc.reference.updateData({
              'favouritesCategories':
                  FieldValue.arrayRemove([favouriteCategoryDoc.documentID])
            }).then((_) => favouriteCategoryDoc.delete());
          }));
}

Stream<Publication> getPublication(String publicationId) {
  return firestore
      .document('Publications/$publicationId')
      .snapshots()
      .map((doc) => Publication.fromFirestore(doc));
}

Stream<List<Publication>> getUserPublications(String userId) {
  Stream<List<Publication>> stream;
  firestore.document('Users/$userId').get().then((userDoc) {
    List<String> publicationsId =
        List<String>.from(userDoc.data['publications']);
    List<DocumentReference> refs = publicationsId.map((publicationId) => firestore.document('Publications/$publicationId'));
    Stream<DocumentSnapshot> snapshots = Stream.fromFutures(refs.map((ref) => ref.get()));
    stream = snapshots.map(toPublicationList);
  });
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
  DocumentReference publicationDoc =
      firestore.document('Publications/${publication.getId()}');
  firestore
      .collection('FavouritesCategories')
      .getDocuments()
      .then((query) => query.documents.forEach((doc) {
            doc.reference.updateData({
              'publications':
                  FieldValue.arrayRemove([publicationDoc.documentID])
            });
          }))
      .then((_) => publicationDoc.delete());
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

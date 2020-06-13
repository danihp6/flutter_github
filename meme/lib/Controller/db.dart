import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/FavouriteCategory.dart';
import 'package:meme/Models/User.dart';

Stream<User> getUser(String userId) {
  return Firestore.instance.collection('Users').document(userId).snapshots().map(toUser);
}

Stream<List<FavouriteCategory>> getFavouritesCategories (String userId) {
  return Firestore.instance.collection('Users').document(userId).collection('favouritesCategories').snapshots().map(toFavouriteCategoryList);
}

Stream<FavouriteCategory> getFavouriteCategory (String favouriteCategoryId) {
  return Firestore.instance.collection('Users').document('favouriteCategories').collection('favouritesCategories').document(favouriteCategoryId).snapshots().map(toFavouriteCategory);
}
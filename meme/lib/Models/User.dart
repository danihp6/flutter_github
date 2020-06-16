import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/FavouriteCategory.dart';

class User {
  String _id;
  String _name;
  String _image;
  int _followers;
  int _followed;
  String _description;
  String _publications;
  List<String> _favouritesCategories;
  String _favouritesPublications;

  User(id, name, image, followers, followed, description,favouritesPublications) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._followers = followers;
    this._followed = followed;
    this._description = description;
    this._favouritesPublications = favouritesPublications;
  }

  User.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _followers = doc.data['followers'].length,
        _followed = doc.data['followed'].length,
        _description = doc.data['description'],
        _publications = doc.data['publications'],
        _favouritesCategories =
            List<String>.from(doc.data['favouritesCategories']),
            _favouritesPublications = doc.data['favouritesPublications'];

  getId() {
    return this._id;
  }

  setId(id) {
    this._id = id;
  }

  getName() {
    return this._name;
  }

  setName(name) {
    this._name = name;
  }

  getImage() {
    return this._image;
  }

  setImage(image) {
    this._image = image;
  }

  getFollowers() {
    return this._followers;
  }

  setFollowers(followers) {
    this._followers = followers;
  }

  getFollowed() {
    return this._followed;
  }

  setFollowed(followed) {
    this._followed = followed;
  }

  getDescription() {
    return this._description;
  }

  setDescription(description) {
    this._description = description;
  }

  getPublications() {
    return this._publications;
  }

  setPublications(publications) {
    this._publications = publications;
  }

  getFavouritesCategories() {
    return this._favouritesCategories;
  }

  setFavouritesCategories(favouritesCategories) {
    this._favouritesCategories = favouritesCategories;
  }

  getFavouritesPublications() {
    return this._favouritesPublications;
  }

  setFavouritesPublications(favouritesPublications) {
    this._favouritesPublications = favouritesPublications;
  }
}

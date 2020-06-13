import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Publication.dart';

class FavouriteCategory {
  String _id;
  String _name;
  String _image;
  String _authorId;
  List<String> _publications;

  FavouriteCategory(name, image, publications,authorId) {
    this._name = name;
    this._image = image;
    this._publications = publications;
    this._authorId = authorId;
  }

  FavouriteCategory.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _authorId = doc.data['authorId'],
        _publications = List<String>.from(doc.data['publications']);

  Map<String, dynamic> toFirestore() => {'name': _name, 'image': _image,'publications':_publications,'authorId':_authorId};

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

  getAuthorId() {
    return this._authorId;
  }

  setAuthorId(authorId) {
    this._authorId = authorId;
  }

  getPublications() {
    return this._publications;
  }

  setPublications(publications) {
    this._publications = publications;
  }


}

List<FavouriteCategory> toFavouriteCategoryList(QuerySnapshot query) {
  return query.documents
      .map((doc) => FavouriteCategory.fromFirestore(doc))
      .toList();
}

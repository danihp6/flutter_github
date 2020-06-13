import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme/Models/Publication.dart';

class FavouriteCategory {
  String _id;
  String _name;
  String _image;

  FavouriteCategory(id, name, image) {
    this._id = id;
    this._name = name;
    this._image = image;
  }

  FavouriteCategory.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'];

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
}

List<FavouriteCategory> toFavouriteCategoryList(QuerySnapshot query) {
  return query.documents
      .map((doc) => FavouriteCategory.fromFirestore(doc))
      .toList();
}

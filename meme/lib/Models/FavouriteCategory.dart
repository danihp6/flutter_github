import 'package:flutter/material.dart';
import 'package:meme/Models/Publication.dart';

class FavouriteCategory {
  String _name;
  String _image;
  List <Publication> _publications;
  FavouriteCategory(name,image,publications){
    this._name = name;
    this._image = image;
    this._publications = publications;
  }

  getPublications(){ return this._publications; }

  setPublications(publications){ this._publications = publications; }

  getName(){ return this._name; }

  setName(name){ this._name = name; }

  getImage(){ return this._image; }

  setImage(image){ this._image = image; }
}

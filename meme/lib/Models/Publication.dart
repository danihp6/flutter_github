import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class Publication {
  String _image;
  User _author;
  String _description;
  int _favourites;
  List<Comment> _comments;
  DateTime _dateTime;
  Publication(image,author,description,favourites,comments,dateTime){
    this._image = image;
    this._author = author;
    this._description = description;
    this._favourites = favourites;
    this._comments = comments;
    this._dateTime = dateTime;
  }

  getImage(){ return this._image; }

  setImage(image){ this._image = image; }

  getAuthor(){ return this._author; }

  setAuthor(author){ this._author = author; }

  getDescription(){ return this._description; }

  setDescription(description){ this._description = description; }

  getFavourites(){ return this._favourites; }

  setFavourites(favourites){ this._favourites = favourites; }

  getComments(){ return this._comments; }

  setComments(comments){ this._comments = comments; }

  String getPastTime() {
    DateTime dateTime = this._dateTime;
    DateTime now = DateTime.now();
    String pastTime;
    if(dateTime.year < now.year) pastTime = (now.year - dateTime.year).toString() + ' años';
    else if(dateTime.month < now.month) pastTime = (now.month - dateTime.month).toString() + ' meses';
    else if(dateTime.day < now.day) pastTime = (now.day - dateTime.day).toString() + ' d';
    else if(dateTime.minute < now.minute) pastTime = (now.minute - dateTime.minute).toString() + ' m';
    else if(dateTime.second < now.second) pastTime = (now.second - dateTime.second).toString() + ' s';
    else pastTime = 0.toString() + ' s';
    return pastTime;
  }
}

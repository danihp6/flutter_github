import 'package:meme/Models/User.dart';

class Comment {
  String _comment;
  int _likes;
  User _author;
  DateTime _dateTime;
  Comment(comment,likes,author,dateTime){
    this._comment = comment;
    this._likes = likes;
    this._author = author;
    this._dateTime = dateTime;
  }

  getComment(){ return this._comment; }

  setComment(comment){ this._comment = comment; }

  getLikes(){ return this._likes; }

  setLikes(likes){ this._likes = likes; }

  getAuthor(){ return this._author; }

  setAuthor(author){ this._author = author; }

  getDateTime(){ return this._dateTime; }

  setDateTime(dateTime){ this._dateTime = dateTime; }

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
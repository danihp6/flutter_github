import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/User.dart';

class Comment {
  String _id;
  String _text;
  List<String> _likes;
  String _authorId;
  DateTime _dateTime;
  List<String> _comments;
  int _level;

  Comment(
      text, likes, authorId, dateTime, comments, level) {
    this._text = text;
    this._likes = likes;
    this._authorId = authorId;
    this._dateTime = dateTime;
    this._comments = comments;
    this._level = level;
  }

  Comment.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _text = doc.data['text'],
        _likes = List<String>.from(doc.data['likes']),
        _authorId = doc.data['authorId'],
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _comments = List<String>.from(doc.data['comments']),
        _level = doc.data['level'];

  Map<String, dynamic> toFirestore() => {
        'text': _text,
        'likes': _likes,
        'authorId': _authorId,
        'dateTime': _dateTime,
        'level':_level,
        'comments':_comments
      };

  String getId() {
    return this._id;
  }

  void setId(id) {
    this._id = id;
  }

  String getText() {
    return this._text;
  }

  void setText(text) {
    this._text = text;
  }

  List<String> getLikes() {
    return this._likes;
  }

  void setLikes(likes) {
    this._likes = likes;
  }

  String getAuthorId() {
    return this._authorId;
  }

  void setAuthorId(authorId) {
    this._authorId = authorId;
  }

  DateTime getDateTime() {
    return this._dateTime;
  }

  void setDateTime(dateTime) {
    this._dateTime = dateTime;
  }

  List<String> getComments() {
    return this._comments;
  }

  void setComments(comments) {
    this._comments = comments;
  }

  int getLevel() {
    return this._level;
  }

  void setLevel(level) {
    this._level = level;
  }

  String getPastTime() {
    DateTime dateTime = this._dateTime;
    DateTime now = DateTime.now();
    String pastTime;
    if (dateTime.year < now.year)
      pastTime = (now.year - dateTime.year).toString() + ' años';
    else if (dateTime.month < now.month)
      pastTime = (now.month - dateTime.month).toString() + ' meses';
    else if (dateTime.day < now.day)
      pastTime = (now.day - dateTime.day).toString() + ' d';
    else if(dateTime.hour < now.hour)
      pastTime = (now.hour - dateTime.hour).toString() + ' h';
    else if (dateTime.minute < now.minute)
      pastTime = (now.minute - dateTime.minute).toString() + ' m';
    else if (dateTime.second < now.second)
      pastTime = (now.second - dateTime.second).toString() + ' s';
    else
      pastTime = 0.toString() + ' s';
    return pastTime;
  }
}

List<Comment> toCommentList(QuerySnapshot query) {
  return query.documents.map((doc) => Comment.fromFirestore(doc)).toList();
}

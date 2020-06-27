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

  get id => this._id;

  set id(id) => this._id = id;

  get text => this._text;

  set text(text) => this._text = text;

  get likes => this._likes;

  set likes(likes) => this._likes = likes;

  get authorId => this._authorId;

  set authorId(authorId) => this._authorId = authorId;

  get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;

  get comments => this._comments;

  set comments(comments) => this._comments = comments;

  get level => this._level;

  set level(level) => this._level = level;
}

List<Comment> toCommentList(QuerySnapshot query) {
  return query.documents.map((doc) => Comment.fromFirestore(doc)).toList();
}

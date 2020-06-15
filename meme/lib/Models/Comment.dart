import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/User.dart';

class Comment {
  String _id;
  String _comment;
  List<String> _likes;
  String _authorId;
  DateTime _dateTime;
  String _publicationId;
  List<String> _comments;
  int _level;

  Comment(
      comment, likes, authorId, dateTime, publicationId, comments, level) {
    this._comment = comment;
    this._likes = likes;
    this._authorId = authorId;
    this._dateTime = dateTime;
    this._publicationId = publicationId;
    this._comments = comments;
    this._level = level;
  }

  Comment.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _comment = doc.data['comment'],
        _likes = List<String>.from(doc.data['likes']),
        _authorId = doc.data['authorId'],
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _comments = List<String>.from(doc.data['comments']),
        _publicationId = doc.reference.parent().parent().documentID,
        _level = doc.data['level'];

  Map<String, dynamic> toFirestore() => {
        'comment': _comment,
        'likes': _likes,
        'authorId': _authorId,
        'dateTime': _dateTime,
        'level':_level,
        'comments':_comments
      };

  getId() {
    return this._id;
  }

  setId(id) {
    this._id = id;
  }

  getComment() {
    return this._comment;
  }

  setComment(comment) {
    this._comment = comment;
  }

  getLikes() {
    return this._likes;
  }

  setLikes(likes) {
    this._likes = likes;
  }

  getAuthorId() {
    return this._authorId;
  }

  setAuthorId(authorId) {
    this._authorId = authorId;
  }

  getDateTime() {
    return this._dateTime;
  }

  setDateTime(dateTime) {
    this._dateTime = dateTime;
  }

  getComments() {
    return this._comments;
  }

  setComments(comments) {
    this._comments = comments;
  }

  getPublicationId() {
    return this._publicationId;
  }

  setPublicationId(publicationId) {
    this._publicationId = publicationId;
  }

  getLevel() {
    return this._level;
  }

  setLevel(level) {
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

Comment getBestComment(List<Comment> comments) {
  Comment comment = comments[0];
  for (var i = 1; i < comments.length; i++) {
    if (comment.getLikes().length < comments[i].getLikes().length) comment = comments[i];
  }
  return comment;
}

List<Comment> getParentComments(List<Comment> comments) {
  List<Comment> parentComments = [];
  for (var comment in comments) {
    if (comment.getLevel() == 0) parentComments.add(comment);
  }
  return parentComments;
}

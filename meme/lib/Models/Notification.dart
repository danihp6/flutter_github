import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String _id;
  String _title;
  String _body;
  String _sender;
  String _post;
  DateTime _dateTime;

  Notification(id, title, body, sender, post,dateTime) {
    this._id = id;
    this._title = title;
    this._body = body;
    this._sender = sender;
    this._post = post;
    this._dateTime  = dateTime;
  }

  Notification.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _title = doc.data['title'],
        _body = doc.data['body'],
        _sender = doc.data['sender'],
        _post = doc.data['post'] ?? null,
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate();

  Map<String, dynamic> toFirestore() => {
        'title': _title,
        'body': _body,
        'sender': _sender,
        'post': _post,
        'dateTime':_dateTime
      };

  String get id => this._id;

  set id(id) => this._id = id;

  String get title => this._title;

  set title(title) => this._title = title;

  String get body => this._body;

  set body(body) => this._body = body;

  String get sender => this._sender;

  set sender(sender) => this._sender = sender;

  String get post => this._post;

  set post(post) => this._post = post;

  get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;
}

List<Notification> toNotificationList(QuerySnapshot query) {
  return query.documents.map((doc) => Notification.fromFirestore(doc)).toList();
}

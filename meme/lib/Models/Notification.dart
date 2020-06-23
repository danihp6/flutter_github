import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String _title;
  String _body;
  String _sender;
  // String _receiver;
  String _post;

  Notification(title, body, sender, post) {
    this._title = title;
    this._body = body;
    this._sender = sender;
    // this._receiver = receiver;
    this._post = post;
  }

  Notification.fromFirestore(DocumentSnapshot doc)
      : _title = doc.data['notification']['title'],
        _body = doc.data['notification']['body'],
        _sender = doc.data['data']['sender'],
        // _receiver = doc.data['receiver'],
        _post = doc.data['data']['post'];

  Map<String, dynamic> toFirestore() => {
        'title': _title,
        'body': _body,
        'sender': _sender,
        // 'receiver': _receiver,
        'post': _post
      };

  String get title => this._title;

  set title(title) => this._title = title;

  String get body => this._body;

  set body(body) => this._body = body;

  String get sender => this._sender;

  set sender(sender) => this._sender = sender;

  // String get receiver => this._receiver;

  // set receiver(receiver) => this._receiver = receiver;

  String get post => this._post;

  set post(post) => this._post = post;
}

List<Notification> toNotificationList(QuerySnapshot query) {
  return query.documents.map((doc) => Notification.fromFirestore(doc)).toList();
}
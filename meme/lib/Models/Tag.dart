import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Controller/string_functions.dart';

class Tag {
  String _id;
  String _name;
  List<String> _posts;
  Map<String, dynamic> _points;
  int _totalPoints;

  Tag(name) {
    this._name = name;
    this._posts = [];
  }

  Tag.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _posts = List<String>.from(doc.data['posts']),
        _points = doc.data['points'],
        _totalPoints = doc.data['totalPoints'];

  Map<String, dynamic> toFirestore() => {
        'name': _name,
        'posts': _posts,
        'keyWords': generateKeyWords(_name),
        'points': Map(),
        'totalPoints': 0
      };

  get id => this._id;

  set id(id) => this._id = id;

  get name => this._name;

  set name(name) => this._name = name;

  get posts => this._posts;

  set posts(posts) => this._posts = posts;

  get points => this._points;

  set points(points) => this._points = points;

  get totalPoints => this._totalPoints;

  set totalPoints(totalPoints) => this._totalPoints = totalPoints;
}

List<Tag> toTagLists(QuerySnapshot query) {
  return query.documents.map((doc) => Tag.fromFirestore(doc)).toList();
}

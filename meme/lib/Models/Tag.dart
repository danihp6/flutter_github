import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Controller/string_functions.dart';

class Tag {
  String _id;
  String _name;
  List<DocumentReference> _posts;

  Tag(name, posts) {
    this._name = name;
    this._posts = posts;
  }

  Tag.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _posts = List<DocumentReference>.from(doc.data['posts']);

  Map<String, dynamic> toFirestore() => {'name': _name, 'posts': _posts,'keyWords':generateKeyWords(_name)};

  get id => this._id;

  set id(id) => this._id = id;

  get name => this._name;

  set name(name) => this._name = name;

  get posts => this._posts;

  set posts(posts) => this._posts = posts;
}

List<Tag> toTagLists(QuerySnapshot query) {
  return query.documents.map((doc) => Tag.fromFirestore(doc)).toList();
}
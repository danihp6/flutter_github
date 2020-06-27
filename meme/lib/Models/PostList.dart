import 'package:cloud_firestore/cloud_firestore.dart';

class PostList {
  String _id;
  String _name;
  String _image;
  String _imageLocation;
  String _authorId;
  List<String> _posts;
  List<String> _keyWords;
  DateTime _dateTime;

  PostList(name, image, imageLocation, posts, authorId, keyWords,dateTime) {
    this._name = name;
    this._image = image;
    this._imageLocation = imageLocation;
    this._posts = posts;
    this._authorId = authorId;
    this._keyWords = keyWords;
    this._dateTime = dateTime;
  }

  PostList.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _imageLocation = doc.data['imageLocation'],
        _authorId = doc.data['authorId'],
        _posts = List<String>.from(doc.data['posts']),
        _keyWords = List<String>.from(doc.data['keyWords']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate();

  Map<String, dynamic> toFirestore() => {
        'name': _name,
        'image': _image,
        'imageLocation': _imageLocation,
        'posts': _posts,
        'authorId': _authorId,
        'keyWords': _keyWords,
        'dateTime': _dateTime,
      };

  get id => this._id;

  set id(id) => this._id = id;

  get name => this._name;

  set name(name) => this._name = name;

  get image => this._image;

  set image(image) => this._image = image;

  get imageLocation => this._imageLocation;

  set imageLocation(imageLocation) => this._imageLocation = imageLocation;

  get posts => this._posts;

  set posts(posts) => this._posts = posts;

  get authorId => this._authorId;

  set authorId(authorId) => this._authorId = authorId;

  get keyWords => this._keyWords;

  set keyWords(keyWords) => this._keyWords = keyWords;

  get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;
}

List<PostList> toPostLists(QuerySnapshot query) {
  return query.documents.map((doc) => PostList.fromFirestore(doc)).toList();
}

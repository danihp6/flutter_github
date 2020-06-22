import 'package:cloud_firestore/cloud_firestore.dart';

class PostList {
  String _id;
  String _name;
  String _image;
  String _imageLocation;
  String _authorId;
  List<String> _posts;
  List<String> _keyWords;

  PostList(name, image, imageLocation, posts, authorId, keyWords) {
    this._name = name;
    this._image = image;
    this._imageLocation = imageLocation;
    this._posts = posts;
    this._authorId = authorId;
    this._keyWords = keyWords;
  }

  PostList.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _imageLocation = doc.data['imageLocation'],
        _authorId = doc.data['authorId'],
        _posts = List<String>.from(doc.data['posts']),
        _keyWords = List<String>.from(doc.data['keyWords']);

  Map<String, dynamic> toFirestore() => {
        'name': _name,
        'image': _image,
        'imageLocation': _imageLocation,
        'posts': _posts,
        'authorId': _authorId,
        'keyWords': _keyWords
      };

  String getId() {
    return this._id;
  }

  void setId(id) {
    this._id = id;
  }

  String getName() {
    return this._name;
  }

  void setName(name) {
    this._name = name;
  }

  String getImage() {
    return this._image;
  }

  void setImage(image) {
    this._image = image;
  }

  String getImageLocation() {
    return this._imageLocation;
  }

  void setImageLocation(imageLocation) {
    this._imageLocation = imageLocation;
  }

  String getAuthorId() {
    return this._authorId;
  }

  void setAuthorId(authorId) {
    this._authorId = authorId;
  }

  List<String> getPosts() {
    return this._posts;
  }

  setPosts(posts) {
    this._posts = posts;
  }

  List<String> getKeyWords() {
    return this._keyWords;
  }

  void setKeyWords(keyWords) {
    this._keyWords = keyWords;
  }
}

List<PostList> toPostLists(QuerySnapshot query) {
  return query.documents.map((doc) => PostList.fromFirestore(doc)).toList();
}

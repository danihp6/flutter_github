import 'package:cloud_firestore/cloud_firestore.dart';

class PostList {
  String _id;
  String _name;
  String _image;
  String _authorId;
  List<String> _posts;

  PostList(name, image, posts, authorId) {
    this._name = name;
    this._image = image;
    this._posts = posts;
    this._authorId = authorId;
  }

  PostList.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _authorId = doc.data['authorId'],
        _posts = List<String>.from(doc.data['posts']);

  Map<String, dynamic> toFirestore() => {
        'name': _name,
        'image': _image,
        'posts': _posts,
        'authorId': _authorId
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
}

List<PostList> toPostLists(QuerySnapshot query) {
  return query.documents
      .map((doc) => PostList.fromFirestore(doc))
      .toList();
}

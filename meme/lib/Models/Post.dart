import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class Post {
  String _id;
  String _media;
  String _mediaType;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _mediaLocation;
  String _authorId;
  List<String> _keyWords;

  Post(media, description,mediaType, favourites, dateTime, mediaLocation, authorId,
      keyWords) {
    this._media = media;
    this._mediaType = mediaType;
    this._description = description;
    this._favourites = favourites;
    this._dateTime = dateTime;
    this._mediaLocation = mediaLocation;
    this._authorId = authorId;
    this._keyWords = keyWords;
  }

  Post.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _media = doc.data['media'],
        _mediaType = doc.data['mediaType'],
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _mediaLocation = doc.data['mediaLocation'],
        _authorId = doc.reference.parent().parent().documentID,
        _keyWords = List<String>.from(doc.data['keyWords']);

  Map<String, dynamic> toFirestore() => {
        'media': _media,
        'mediaType':_mediaType,
        'description': _description,
        'favourites': _favourites,
        'dateTime': _dateTime,
        'mediaLocation': _mediaLocation,
        'keyWords': _keyWords
      };

  String getId() {
    return this._id;
  }

  void setId(id) {
    this._id = id;
  }

  String getMedia() {
    return this._media;
  }

  void setMedia(media) {
    this._media = media;
  }

  String getMediaType() {
    return this._mediaType;
  }

  void setMediaType(mediaType) {
    this._mediaType = mediaType;
  }

  String getDescription() {
    return this._description;
  }

  void setDescription(description) {
    this._description = description;
  }

  List<String> getFavourites() {
    return this._favourites;
  }

  void setFavourites(favourites) {
    this._favourites = favourites;
  }

  String getMediaLocation() {
    return this._mediaLocation;
  }

  void setMediaLocation(mediaLocation) {
    this._mediaLocation = mediaLocation;
  }

  String getAuthorId() {
    return this._authorId;
  }

  void setAuthorId(authorId) {
    this._authorId = authorId;
  }

  List<String> getKeyWords() {
    return this._keyWords;
  }

  void setKeyWords(keyWords) {
    this._keyWords = keyWords;
  }

  DateTime getDateTime() {
    return this._dateTime;
  }

  void setDateTime(dateTime) {
    this._dateTime = dateTime;
  }
}

List<Post> toPosts(QuerySnapshot query) {
  return query.documents.map((doc) => Post.fromFirestore(doc)).toList();
}

void orderListPostByDateTime(List<Post> posts) {
  return posts.sort((a, b) => b._dateTime.compareTo(a._dateTime));
}

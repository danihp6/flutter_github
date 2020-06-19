import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class Post {
  String _id;
  String _media;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _mediaLocation;
  String _authorId;

  Post(media, description, favourites, dateTime, mediaLocation, authorId) {
    this._media = media;
    this._description = description;
    this._favourites = favourites;
    this._dateTime = dateTime;
    this._mediaLocation = mediaLocation;
    this._authorId = authorId;
  }

  Post.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _media = doc.data['media'],
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _mediaLocation = doc.data['mediaLocation'],
        _authorId = doc.reference.parent().id;

  Map<String, dynamic> toFirestore() => {
        'media': _media,
        'description': _description,
        'favourites': _favourites,
        'dateTime': _dateTime,
        'mediaLocation': _mediaLocation
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
    else if (dateTime.hour < now.hour)
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

List<Post> toPosts(QuerySnapshot query) {
  return query.documents.map((doc) => Post.fromFirestore(doc)).toList();
}

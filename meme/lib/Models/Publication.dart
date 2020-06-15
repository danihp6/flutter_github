import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class Publication {
  String _id;
  String _image;
  String _authorId;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _url;

  Publication( image, authorId, description, favourites, dateTime,url) {
    this._image = image;
    this._authorId = authorId;
    this._description = description;
    this._favourites = favourites;
    this._dateTime = dateTime;
    this._url = url;
  }

  Publication.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _image = doc.data['image'],
        _authorId = doc.data['authorId'],
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _url = doc.data['url'];

        Map<String, dynamic> toFirestore() => {'image': _image, 'authorId': _authorId,'description':_description,'favourites':_favourites,'dateTime':_dateTime,'url':_url};

  getId() {
    return this._id;
  }

  setId(id) {
    this._id = id;
  }

  getImage() {
    return this._image;
  }

  setImage(image) {
    this._image = image;
  }

  getAuthorId() {
    return this._authorId;
  }

  setAuthorId(authorId) {
    this._authorId = authorId;
  }

  getDescription() {
    return this._description;
  }

  setDescription(description) {
    this._description = description;
  }

  getFavourites() {
    return this._favourites;
  }

  setFavourites(favourites) {
    this._favourites = favourites;
  }

  getUrl() {
    return this._url;
  }

  setUrl(url) {
    this._url = url;
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

List<Publication> toPublicationList(List<DocumentSnapshot> docs) {
  return docs.map((doc) => Publication.fromFirestore(doc)).toList();
}

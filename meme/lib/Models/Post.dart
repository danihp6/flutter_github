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

  get id => this._id;

  set id(id)=>this._id = id;

   get media => this._media;

  set media(media)=>this._media = media;

 get mediaType => this._mediaType;

  set mediaType(mediaType)=>this._mediaType = mediaType;

 get description => this._description;

  set description(description)=>this._description = description;

 get favourites => this._favourites;

  set favourites(favourites)=>this._favourites = favourites;

 get dateTime => this._dateTime;

  set dateTime(dateTime)=>this._dateTime = dateTime;

 get mediaLocation => this._mediaLocation;

  set mediaLocation(mediaLocation)=>this._mediaLocation = mediaLocation;

 get authorId => this._authorId;

  set authorId(authorId)=>this._authorId = authorId;

 List<String> get keyWords => this._keyWords;

  set keyWords(keyWords)=>this._keyWords = keyWords;


}

List<Post> toPosts(QuerySnapshot query) {
  return query.documents.map((doc) => Post.fromFirestore(doc)).toList();
}

void orderListPostByDateTime(List<Post> posts) {
  return posts.sort((a, b) => b._dateTime.compareTo(a._dateTime));
}

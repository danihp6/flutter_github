import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class Post {
  String _id;
  String _media;
  MediaType _mediaType;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _mediaLocation;
  String _author;
  List<String> _tags;
  Map<String, dynamic> _hotPoints;

  Post(media, description, mediaType, favourites, dateTime, mediaLocation,
      authorId, tags,hotPoints) {
    this._media = media;
    this._mediaType = mediaType;
    this._description = description;
    this._favourites = favourites;
    this._dateTime = dateTime;
    this._mediaLocation = mediaLocation;
    this._author = authorId;
    this._tags = tags;
    this._hotPoints = hotPoints;
  }

  Post.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _media = doc.data['media'],
        _mediaType = toMediaType(doc.data['mediaType']),
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _mediaLocation = doc.data['mediaLocation'],
        _author = doc.reference.parent().parent().documentID,
        _tags = List<String>.from(doc.data['tags']),
        _hotPoints = doc.data['hotPoints'];

  Map<String, dynamic> toFirestore() => {
        'media': _media,
        'mediaType': _mediaType.toString(),
        'description': _description,
        'favourites': _favourites,
        'dateTime': _dateTime,
        'mediaLocation': _mediaLocation,
        'tags': _tags,
        'hotPoints': _hotPoints
      };

  get id => this._id;

  set id(id) => this._id = id;

  get media => this._media;

  set media(media) => this._media = media;

  get mediaType => this._mediaType;

  set mediaType(mediaType) => this._mediaType = mediaType;

  get description => this._description;

  set description(description) => this._description = description;

  get favourites => this._favourites;

  set favourites(favourites) => this._favourites = favourites;

  get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;

  get mediaLocation => this._mediaLocation;

  set mediaLocation(mediaLocation) => this._mediaLocation = mediaLocation;

  get author => this._author;

  set author(author) => this._author = author;

  List<String> get tags => this._tags;

  set tags(tags) => this._tags = tags;

  get hotPoints => this._hotPoints;

  set hotPoints(hotPoints) => this._hotPoints = hotPoints;

  int getTotalHotPoints() {
    int res = 0;
    hotPoints.forEach((id,hotPoints) {
      res += hotPoints;
    });
    return res;
  }
}

List<Post> toPosts(QuerySnapshot query) {
  return query.documents.map((doc) => Post.fromFirestore(doc)).toList();
}

void orderListPostByDateTime(List<Post> posts) {
  return posts.sort((a, b) => b._dateTime.compareTo(a._dateTime));
}

MediaType toMediaType(String string){
  if(MediaType.image.toString() == string) return MediaType.image;
  if(MediaType.video.toString() == string) return MediaType.video;
  else throw Exception('Incorrect type');
}
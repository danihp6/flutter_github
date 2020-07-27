import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Models/User.dart';

class Post {
  String _id;
  String _media;
  MediaType _mediaType;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _author;
  List<String> _tags;
  Map<String, dynamic> _points;
  int _totalPoints;
  double _aspectRatio;
  String _template;

  Post(media, description, mediaType, favourites,
      authorId, tags, points, aspectRatio, template) {
    this._media = media;
    this._mediaType = mediaType;
    this._description = description;
    this._favourites = favourites;
    this._dateTime = DateTime.now();
    this._author = authorId;
    this._tags = tags;
    this._points = points;
    this._totalPoints = 0;
    this._aspectRatio = aspectRatio;
    this._template = template;
  }

  Post.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _media = doc.data['media'],
        _mediaType = toMediaType(doc.data['mediaType']),
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _author = doc.reference.parent().parent().documentID,
        _tags = List<String>.from(doc.data['tags']),
        _points = doc.data['points'],
        _totalPoints = doc.data['totalPoints'],
        _aspectRatio = doc.data['aspectRatio'].toDouble(),
        _template = doc.data['template'];

  Map<String, dynamic> toFirestore() => {
        'media': _media,
        'mediaType': _mediaType.toString(),
        'description': _description,
        'favourites': _favourites,
        'dateTime': _dateTime,
        'tags': _tags,
        'points': _points,
        'totalPoints':_totalPoints,
        'aspectRatio': _aspectRatio,
        'author': _author,
        'template': _template
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

  DateTime get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;

  get author => this._author;

  set author(author) => this._author = author;

  List<String> get tags => this._tags;

  set tags(tags) => this._tags = tags;

  get points => this._points;

  get totalPoints => this._totalPoints;

  get aspectRatio => this._aspectRatio;

  set aspectRatio(aspectRatio) => this._aspectRatio = aspectRatio;

  get template => this._template;


}

List<Post> toPosts(QuerySnapshot query) {
  return query.documents.map((doc) => Post.fromFirestore(doc)).toList();
}

void orderListPostByDateTime(List<Post> posts) =>
    posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

MediaType toMediaType(String string) {
  if (MediaType.image.toString() == string) return MediaType.image;
  if (MediaType.video.toString() == string) return MediaType.video;
  return null;
}

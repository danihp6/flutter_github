import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Controller/string_functions.dart';

class User {
  String _id;
  String _userName;
  String _avatar;
  String _avatarLocation;
  List<String> _followers;
  List<String> _followed;
  String _description;
  List<String> _favourites;
  DateTime _dateTime;
  String _email;
  List<String> _tokens;
  List<String> _blockedUsers;
  Map<String, dynamic> _points;

  User(userName, avatar, avatarLocation, followers, followed,favourites, description,
      dateTime, email,tokens) {
    this._userName = userName;
    this._avatar = avatar;
    this._avatarLocation = avatarLocation;
    this._followers = followers;
    this._followed = followed;
    this._favourites = favourites;
    this._description = description;
    this._dateTime = dateTime;
    this._email = email;
    this._tokens = tokens;
  }

  User.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _userName = doc.data['userName'],
        _avatar = doc.data['avatar'],
        _avatarLocation = doc.data['avatarLocation'],
        _followers = List<String>.from(doc.data['followers']),
        _followed = List<String>.from(doc.data['followed']),
        _description = doc.data['description'],
        _favourites = List<String>.from(doc.data['favourites']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate(),
        _email = doc.data['email'],
        _tokens = List<String>.from(doc.data['tokens']),
        _blockedUsers = List<String>.from(doc.data['blockedUsers']),
        _points = doc.data['points'];

  Map<String, dynamic> toFirestore() => {
        'userName': _userName,
        'avatar': _avatar,
        'avatarLocation': _avatarLocation,
        'followers': _followers,
        'followed': _followed,
        'description': _description,
        'favourites': _favourites,
        'dateTime': _dateTime,
        'keyWords': generateKeyWords(_userName),
        'email': _email,
        'tokens':_tokens,
        'blokedUsers':[],
        'points': Map()
      };

  get id => this._id;

  set id(id) => this._id = id;

  get userName => this._userName;

  set userName(userName) => this._userName = userName;

  get avatar => this._avatar;

  set avatar(avatar) => this._avatar = avatar;

  get avatarLocation => this._avatarLocation;

  set avatarLocation(avatarLocation) => this._avatarLocation = avatarLocation;

  get followers => this._followers;

  set followers(followers) => this._followers = followers;

  get followed => this._followed;

  set followed(followed) => this._followed = followed;

  get description => this._description;

  set description(description) => this._description = description;

  get favourites => this._favourites;

  set favourites(favourites) => this._favourites = favourites;

  get dateTime => this._dateTime;

  set dateTime(dateTime) => this._dateTime = dateTime;

  get email => this._email;

  set email(email) => this._email = email;

  get tokens => this._tokens;

  set tokens(tokens) => this._tokens = tokens;

  get blockedUsers => this._blockedUsers;

  set blockedUsers(blockedUsers) => this._blockedUsers = blockedUsers;

  get points => this._points;

  set points(points) => this._points = points;

  int getTotalHotPoints() {
    int res = 0;
    points.forEach((id,points) {
      res += points;
    });
    return res;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

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

  User(id, userName, avatar,avatarLocation, followers, followed, description,dateTime) {
    this._id = id;
    this._userName = userName;
    this._avatar = avatar;
    this._avatarLocation = avatarLocation;
    this._followers = followers;
    this._followed = followed;
    this._description = description;
    this._dateTime = dateTime;
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
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate();

  String getId() {
    return this._id;
  }

  void setId(id) {
    this._id = id;
  }

  String getUserName() {
    return this._userName;
  }

  void setUserName(userName) {
    this._userName = userName;
  }

  String getAvatar() {
    return this._avatar;
  }

  void setAvatar(avatar) {
    this._avatar = avatar;
  }

  String getAvatarLocation() {
    return this._avatarLocation;
  }

  void setAvatarLocation(avatarLocation) {
    this._avatarLocation = avatarLocation;
  }

  List<String> getFollowers() {
    return this._followers;
  }

  void setFollowers(followers) {
    this._followers = followers;
  }

  List<String> getFollowed() {
    return this._followed;
  }

  void setFollowed(followed) {
    this._followed = followed;
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

  DateTime getDateTime() {
    return this._dateTime;
  }

  DateTime setDateTime(dateTime) {
    this._dateTime = dateTime;
  }
}

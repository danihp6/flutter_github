import 'package:meme/Models/FavouriteCategory.dart';

class User {
  String _name;
  String _image;
  int _followers;
  int _followed;
  String _description;
  List<FavouriteCategory> _favouritesCategories;
  User(name,image,followers,followed,description,favoritesCategories){
    this._name=name;
    this._image = image;
    this._followers = followers;
    this._followed = followed;
    this._description = description;
    this._favouritesCategories = favoritesCategories;
  }

  getName(){ return this._name; }

  setName(name){ this._name = name; }

  getImage(){ return this._image; }

  setImage(image){ this._image = image; }

  getFollowers(){ return this._followers; }

  setFollowers(followers){ this._followers = followers; }

  getFollowed(){ return this._followed; }

  setFollowed(followed){ this._followed = followed; }

  getDescription(){ return this._description; }

  setDescription(description){ this._description = description; }

  getFavouritesCategories(){ return this._favouritesCategories; }

  setFavouritesCategories(favouritesCategories){ this._favouritesCategories = favouritesCategories; }
}

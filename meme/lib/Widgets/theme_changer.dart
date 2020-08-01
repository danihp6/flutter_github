import 'package:flutter/material.dart';
import 'package:meme/Controller/local_storage.dart';

class ThemeChanger with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeChanger(this._themeMode);

  get themeMode => this._themeMode;

  set themeMode(ThemeMode themeMode) {
    this._themeMode = themeMode;
    storage.themeMode = themeMode;
    notifyListeners();
  } 
}

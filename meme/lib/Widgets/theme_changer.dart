import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeChanger(this._themeMode);

  get themeMode => this._themeMode;

  set themeMode(ThemeMode themeMode) {
    this._themeMode = themeMode;
    notifyListeners();
  } 
}

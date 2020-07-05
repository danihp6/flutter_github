import 'package:flutter/material.dart';

class Configuration {
  bool _isShowedComments = true;
  bool _isShowedTools = true;
  double _volume = 0;
  GlobalKey<NavigatorState> _navigatorKey;
  GlobalKey<ScaffoldState> _scaffoldState;

  GlobalKey<NavigatorState> get navigatorKey => this._navigatorKey;

  set navigatorKey(navigatorKey) => this._navigatorKey = navigatorKey;

  GlobalKey<ScaffoldState> get scaffoldState => this._scaffoldState;

  set scaffoldState(scaffoldState) => this._scaffoldState = scaffoldState;

  getIsShowedComments() {
    return this._isShowedComments;
  }

  setIsShowedComments(isShowedComments) {
    this._isShowedComments = isShowedComments;
  }

  getIsShowedTools() {
    return this._isShowedTools;
  }

  setIsShowedTools(isShowedTools) {
    this._isShowedTools = isShowedTools;
  }

  get volume => this._volume;

  set volume(double volume) => this._volume = volume;
}

Configuration configuration = Configuration();

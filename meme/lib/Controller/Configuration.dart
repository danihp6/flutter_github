import 'package:flutter/material.dart';

class Configuration {
  bool _isShowedComments = true;
  bool _isShowedTools = true;
  double _volume = 0;
  GlobalKey<NavigatorState> _mainNavigatorKey;
  GlobalKey<ScaffoldState> _mainScaffoldState;
  

  GlobalKey<NavigatorState> get mainNavigatorKey => this._mainNavigatorKey;

  set mainNavigatorKey(mainNavigatorKey) => this._mainNavigatorKey = mainNavigatorKey;

  GlobalKey<ScaffoldState> get mainScaffoldState => this._mainScaffoldState;

  set mainScaffoldState(mainScaffoldState) => this._mainScaffoldState = mainScaffoldState;

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

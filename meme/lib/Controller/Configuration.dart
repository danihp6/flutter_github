import 'dart:async';

class Configuration {
  static final Configuration _configuration = Configuration._internal();
  bool _isShowedComments;
  bool _isShowedTools;
  String _userId;

  factory Configuration() {
    return _configuration;
  }

  Configuration._internal() {
    this._isShowedComments = true;
    this._isShowedTools = true;
    this._userId = '9bvBOvfIzvMZBmnRzaQL';
  }

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

  getUserId() {
    return this._userId;
  }

  setUserId(userId) {
    this._userId = userId;
  }
}

Configuration configuration = Configuration();

import 'dart:async';

class Configuration {
  static final Configuration _configuration = Configuration._internal();
  bool _isShowedComments;
  bool _isShowedTools;

  factory Configuration(){ return _configuration;}

  Configuration._internal(){
    this._isShowedComments = true;
    this._isShowedTools = false;
  }

  getIsShowedComments(){ return this._isShowedComments; }

  setIsShowedComments(isShowedComments){ 
    this._isShowedComments = isShowedComments;
    }

    getIsShowedTools(){ return this._isShowedTools; }

  setIsShowedTools(isShowedTools){ 
    this._isShowedTools = isShowedTools;
    }

}

Configuration configuration = Configuration();
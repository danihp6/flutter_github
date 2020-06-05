import 'dart:async';

class Configuration {
  static final Configuration _configuration = Configuration._internal();
  bool _isShowedComments;

  factory Configuration(){ return _configuration;}

  Configuration._internal(){
    this._isShowedComments = true;
  }

  getIsShowedComments(){ return this._isShowedComments; }

  setIsShowedComments(isShowedComments){ 
    this._isShowedComments = isShowedComments;
    }

}

Configuration configuration = Configuration();
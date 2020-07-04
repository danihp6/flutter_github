class Configuration {
  bool _isShowedComments = true;
  bool _isShowedTools = true;
  double _volume = 0;

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

  set volume(double volume)=> this._volume = volume;
}

Configuration configuration = Configuration();

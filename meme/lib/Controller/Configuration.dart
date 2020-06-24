

class Configuration {
  bool _isShowedComments = true;
  bool _isShowedTools = true;

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
}

Configuration configuration = Configuration();

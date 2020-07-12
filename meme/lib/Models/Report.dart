class Report {
  String _mainReason;
  List<String> _reasons;
  String _author;

  Report(reason, reasons, author) {
    this._mainReason = reason;
    this._reasons = reasons;
    this._author = author;
  }

  Map<String, dynamic> toFirestore() => {
    'reason':_mainReason,
        'author': _author,
        'reasons': _reasons,
      };
}

List<String> mainReasons = ['Spam','Inappropriate'];

List<String> inappropiateReasons = ['Identity fraud','Abusive content'];


enum MainReason { Spam, Innapropiate }

enum InappropiateReasonAccount { IdentityFraud, AbusiveContent }

enum InappropiateReasonPost {
  AbusivePost,
  SexContent,
  ViolentContent,
  BullingContent,
  IntellectualPropertyInfringement
}

enum ReportType {
  User,Post
}

class Report {
  var _reason;
  String _author;

  Report(reason, author) {
    this._reason = reason;
    this._author = author;
  }

  Map<String, dynamic> toFirestore() => {
        'reason': _reason.toString(),
        'author': _author,
        'dateTime': DateTime.now()
      };
}

String reasonToString(reason) {
  if (reason is MainReason) return _mainReasonToString(reason);
  if (reason is InappropiateReasonAccount)
    return _inappropiateReasonUserToString(reason);
  if (reason is InappropiateReasonPost)
    return _inappropiateReasonPostToString(reason);
}

String _mainReasonToString(MainReason mainReason) =>
    mainReason.toString().substring(11);

String _inappropiateReasonUserToString(
        InappropiateReasonAccount inappropiateReason) =>
    inappropiateReason.toString().substring(26);

String _inappropiateReasonPostToString(
        InappropiateReasonPost inappropiateReason) =>
    inappropiateReason.toString().substring(19);

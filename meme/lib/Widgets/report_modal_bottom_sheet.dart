import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Report.dart';

class ReportModalBottomSheet extends StatefulWidget {
  String reportedUserId;
  GlobalKey<ScaffoldState> scaffoldState;
  ReportType reportType;
  ReportModalBottomSheet(
      {@required this.reportedUserId,@required this.reportType, @required this.scaffoldState});

  @override
  _ReportModalBottomSheetState createState() => _ReportModalBottomSheetState();
}

class _ReportModalBottomSheetState extends State<ReportModalBottomSheet> {
  final mainReasons = MainReason.values;
  final inappropiateReasonAccount = InappropiateReasonAccount.values;
  final inappropiateReasonPost = InappropiateReasonPost.values;

  List reasons;
  String reasonTitle = 'Motivo';

  @override
  void initState() {
    super.initState();
    reasons = mainReasons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              reasonTitle,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: reasons.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) => SizedBox(
                  height: 40,
                  child: FlatButton(
                      onPressed: () {
                        if (reasons[index] == MainReason.Innapropiate && widget.reportType == ReportType.User) {
                          setState(() {
                            reasons = inappropiateReasonAccount;
                            reasonTitle = 'Porque es inapropiada?';
                          });
                        } if (reasons[index] == MainReason.Innapropiate && widget.reportType == ReportType.Post){
                          setState(() {
                            reasons = inappropiateReasonPost;
                            reasonTitle = 'Porque es inapropiado?';
                          });
                        } else
                          newReport(Report(reasons[index], db.userId), context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(reasonToString(reasons[index]),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void newReport(Report report, BuildContext context) {
    db.newReport(widget.reportedUserId, report);
    Navigator.pop(context);
    widget.scaffoldState.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: new Text("Gracias por ayudar a nuestra comunidad")));
  }
}
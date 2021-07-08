import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  final Map activityMap;
  PDFViewerPage({Key key, this.file, this.activityMap}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  UserController _userController = UserController();
  bool allActivityCompleted;
  Timer _timer;
  int _timerCounter = 5;

  @override
  void initState() {
    allActivityCompleted = false;

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_timerCounter > 0) {
        setState(() {
          _timerCounter--;
        });
      } else {
        setState(() {
          timer.cancel();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        customPop(context, widget.activityMap);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: PDFView(
          filePath: widget.file.path,
        ),
      ),
    );
  }

  customPop(BuildContext context, Map activityMap) async {
    if (_timerCounter == 0) {
      await _userController
          .completeActivity(
              activityId: activityMap['activityId'],
              activityListLength: activityMap['activityListLength'],
              moduleId: activityMap['moduleId'],
              level: activityMap['level'],
              activityPoints: int.parse(activityMap["activityPoints"].toString()))
          .then((value) {
        if (value) {
          setState(() {
            allActivityCompleted = value;
          });
        }
      }).whenComplete(() {
        Navigator.restorablePopAndPushNamed(context, '/activity-view',
            arguments: activityMap["moduleId"]);
        if (allActivityCompleted) {
          return CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              title: 'Congratulations!',
              text: 'You have successfully completed ' +
                  activityMap['activityTitle'] +
                  '!');
        }
      });
      return false;
    } else {
      return CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: 'Oh No...',
        text:
            'Please read the ${activityMap['activityType']} for at least 5 seconds',
      );
    }
  }
}

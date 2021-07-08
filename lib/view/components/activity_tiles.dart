import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/view/activity-screens/pdf_viewer.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class ActivityListTile extends StatefulWidget {
  Map content = {};

  String titleText;
  Color tileColor = Colors.transparent, itemsColor = Colors.transparent;
  ActivityListTile({
    Key key,
    this.content,
    this.titleText,
  }) : super(key: key);

  @override
  _ActivityListTileState createState() => _ActivityListTileState();
}

class _ActivityListTileState extends State<ActivityListTile> {
  StorageController _storageController = StorageController();

  @override
  Widget build(BuildContext context) {
    selectTileThemeColor();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () => onTapFunction(),
        child: Container(
          width: DeviceSizeConfig.deviceWidth * 0.9,
          height: DeviceSizeConfig.deviceHeight * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: widget.tileColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(2.0, 1.0),
                  blurRadius: 5.0)
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  selectIcon(widget.content["activityType"]),
                  color: widget.itemsColor,
                  size: DeviceSizeConfig.deviceWidth * 0.1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: DeviceSizeConfig.deviceWidth * 0.6,
                      child: Text(
                        widget.content["activityTitle"],
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceSizeConfig.deviceWidth * 0.045,
                          color: widget.itemsColor,
                        ),
                      ),
                    ),
                    Text(
                      "+ " +
                          widget.content["activityPoints"].toString() +
                          " XP",
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.normal,
                        fontSize: DeviceSizeConfig.deviceWidth * 0.04,
                        color: widget.itemsColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  IconData selectIcon(String activityType) {
    if (activityType == "video") {
      return Icons.play_circle_fill;
    } else if (activityType == "game") {
      return Icons.sports_esports;
    } else if (activityType == "slides") {
      return Icons.slideshow;
    } else if (activityType == "poster") {
      return Icons.info;
    }
  }

  void selectTileThemeColor() {
    if (widget.content["activityStatus"] == "unlocked") {
      setState(() {
        widget.tileColor = kWhite;
        widget.itemsColor = Color(0xFF343F4B);
      });
    } else if (widget.content["activityStatus"] == "locked") {
      setState(() {
        widget.tileColor = kGrey3;
        widget.itemsColor = Color(0xFF343F4B);
      });
    } else if (widget.content["activityStatus"] == "completed") {
      setState(() {
        widget.tileColor = kGreenTileColor;
        widget.itemsColor = kWhite;
      });
    }
  }

  onTapFunction() async {
    if (widget.content["activityStatus"] == "locked") {
      return CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          title: "Oh No...",
          text: "Please complete the unlocked activity first");
    } else if (widget.content["activityStatus"] == "unlocked") {
      CoolAlert.show(context: context, type: CoolAlertType.loading, barrierDismissible: false);
      switch (widget.content["activityType"]) {
        case "video":
          {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/video-activity',
                arguments: widget.content);
          }

          break;
        case "slides":
          {
            final url = "${widget.content['slidesName']}.pdf";
            print(url);
            final file = await _storageController.loadFirebase(
                widget.content['moduleId'], widget.content['level'], url);

            if (file == null) {
              return;
            } else {
              Navigator.canPop(context);
              openPDF(context, file);
            }
          }
          break;
        case "game":
          {
            if (widget.content['gameType'] == "draggable") {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/game-activity',
                arguments: widget.content,
              );
            } else if (widget.content['gameType'] == "guess") {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/guess-game-activity',
                arguments: widget.content,
              );
            }
          }
          break;
        case "poster":
          {
            final url = "${widget.content['posterName']}.pdf";
            print(url);
            final file = await _storageController.loadFirebase(
                widget.content['moduleId'], widget.content['level'], url);

            if (file == null) {
              return;
            } else {
              Navigator.pop(context);
              openPDF(context, file);
            }
          }
          break;
      }
    }
  }

  void openPDF(BuildContext context, File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(
          file: file,
          activityMap: widget.content,
        ),
      ),
    );
  }
}

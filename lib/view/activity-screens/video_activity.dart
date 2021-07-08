import 'dart:convert' show json;

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
// import 'package:fyp_app_design/constants.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoActivity extends StatefulWidget {
  @override
  _VideoActivityState createState() => _VideoActivityState();
}

class _VideoActivityState extends State<VideoActivity> {
  Map activityContent;
  YoutubePlayerController _youtubePlayerController;
  UserController _userController = UserController();
  double _btnOpacity = 0.0;
  String _videoTitle = "";
  bool allActivityCompleted;
  Future runYoutubeVideo(String videoUrl) async {
    var videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _youtubePlayerController = YoutubePlayerController(initialVideoId: videoId);

    var jsonData = await getDetail(videoUrl);

    return jsonData;
  }

  Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$userUrl&format=json";

    //store http request response to res variable
    var res = await http.get(Uri.parse(embedUrl));
    print("get youtube detail status code: " + res.statusCode.toString());

    try {
      if (res.statusCode == 200) {
        //return the json from the response
        return json.decode(res.body);
      } else {
        //return null if status code other than 200
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      //return null if error
      return null;
    }
  }

  Future<void> downloadVideo(String videoUrl) async {
    final result = await FlutterYoutubeDownloader.downloadVideo(
        videoUrl, _videoTitle + ".", 18);
    print(result);
  }

  @override
  void initState() {
    allActivityCompleted = false;
    super.initState();
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (activityContent == null) {
      activityContent = ModalRoute.of(context).settings.arguments;

      runYoutubeVideo(activityContent["videoUrl"]).then((value) {
        setState(() {
          print(value);
          _videoTitle = value["title"];
        });
      });
    }

    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubePlayerController,
          onEnded: (metaData) {
            _youtubePlayerController.seekTo(Duration.zero);
            _youtubePlayerController.pause();
            setState(() {
              _btnOpacity = 1.0;
            });
          },
        ),
        builder: (context, player) {
          return SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Scaffold(
              backgroundColor: kBackgroundColorBright,
              body: Column(
                children: [
                  player,
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _videoTitle,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    fontSize:
                                        DeviceSizeConfig.deviceWidth * 0.07,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: DeviceSizeConfig.deviceWidth * 0.07,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.6,
                                    height:
                                        DeviceSizeConfig.deviceHeight * 0.06,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(2.0, 1.0),
                                          blurRadius: 5.0,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Chip(
                                          label: Text("+ " +
                                              activityContent["activityPoints"]
                                                  .toString() +
                                              " XP"),
                                          labelStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          backgroundColor: Colors.yellow,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.file_download),
                                          onPressed: () {
                                            downloadVideo(
                                                activityContent["videoUrl"]);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            Share.share(
                                                "Get the CyberEd App to learn Cybersecurity! \n\n" +
                                                    activityContent[
                                                        "activityTitle"] +
                                                    "\n" +
                                                    activityContent[
                                                        "videoUrl"]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              AnimatedOpacity(
                                opacity: _btnOpacity,
                                duration: Duration(milliseconds: 1000),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_btnOpacity == 1.0) {
                                      await _userController
                                          .completeActivity(
                                              activityId:
                                                  activityContent["activityId"],
                                              activityListLength:
                                                  activityContent[
                                                      "activityListLength"],
                                              moduleId:
                                                  activityContent["moduleId"],
                                              level: activityContent["level"],
                                              activityPoints: int.parse(activityContent["activityPoints"].toString()))
                                          .then((value) {
                                        if (value) {
                                          setState(() {
                                            allActivityCompleted = value;
                                          });
                                        }
                                      }).whenComplete(() {
                                        Navigator.restorablePopAndPushNamed(
                                            context, '/activity-view',
                                            arguments:
                                                activityContent["moduleId"]);
                                        if (allActivityCompleted) {
                                          return CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              title: 'Congratulations!',
                                              text:
                                                  'You have successfully completed ' +
                                                      activityContent[
                                                          'activityTitle'] +
                                                      '!');
                                        }
                                      }).catchError((onError) {
                                        return CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: onError);
                                      });
                                    } else {
                                      return null;
                                    }
                                  },
                                  icon: Icon(Icons.done),
                                  label: Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          DeviceSizeConfig.deviceWidth * 0.05,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: kGreenColor,
                                    onPrimary: kWhite,
                                    minimumSize: Size(
                                        DeviceSizeConfig.deviceWidth,
                                        DeviceSizeConfig.deviceHeight * 0.07),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

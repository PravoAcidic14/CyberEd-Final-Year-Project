import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/activity_controller.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/controller/pallete_generator.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/view/selected_adaptive_quiz.dart';
import 'package:palette_generator/palette_generator.dart';

import 'components/activity_tiles.dart';

class ActivityView extends StatefulWidget {
  ActivityView({Key key}) : super(key: key);

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  ActivityController _activityController = ActivityController();
  ModuleController _moduleController = ModuleController();
  UserController _userController = UserController();
  Map oldAdaptiveScore = {}, userCompletionStatus = {}, moduleContent = {};
  List activityDetails = [];
  String moduleId;
  bool setStateFinished = false,
      checkedBadgeOnce = false,
      newAdaptiveAnswer,
      oldAdaptiveAnswer,
      alreadyNavigated = false;
  ColorPalleteGenerator _colorPalleteGenerator;
  PaletteColor dominantBackground, textColor;
  int count = 0;

  @override
  void initState() {
    _activityController.matchOldAdaptiveScoreToModule().then((value) {
      if (mounted) {
        setState(() {
          oldAdaptiveScore = value;
        });
      }
    });

    if (oldAdaptiveScore.containsKey(moduleId)) {
      setState(() {
        oldAdaptiveAnswer = false;
      });
    } else {
      setState(() {
        oldAdaptiveAnswer = true;
      });
    }

    _activityController.checkCompletionStatus().then((value) {
      setState(() {
        userCompletionStatus = value;
      });
    });

    _colorPalleteGenerator = ColorPalleteGenerator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    moduleId = ModalRoute.of(context).settings.arguments;
    _moduleController.getModuleContent(moduleId).then((value) {
      moduleContent = value;
    });

    return FutureBuilder<PaletteGenerator>(
      future: _colorPalleteGenerator.getPallete(moduleContent["thumbnailUrl"]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dominantBackground = snapshot.data.dominantColor;
          return WillPopScope(
            onWillPop: () async {
              return customPop(context);
            },
            child: Scaffold(
              backgroundColor: dominantBackground.color,
              appBar: AppBar(
                backgroundColor: dominantBackground.color,
                elevation: 0.0,
              ),
              body: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: DeviceSizeConfig.deviceWidth * 0.6,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    moduleContent["moduleTitle"],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          DeviceSizeConfig.deviceWidth * 0.09,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: Size(20, 20),
                                ),
                                Text(
                                  moduleContent["moduleDescription"],
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.normal,
                                    fontSize:
                                        DeviceSizeConfig.deviceWidth * 0.04,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: DeviceSizeConfig.deviceWidth * 0.4,
                          height: DeviceSizeConfig.deviceWidth * 0.4,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/loading_indicator.gif',
                              image: moduleContent["thumbnailUrl"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox.fromSize(
                    size: Size(
                      DeviceSizeConfig.deviceWidth,
                      DeviceSizeConfig.deviceHeight * 0.08,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(3.0, -2.0),
                            blurRadius: 10.0,
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        color: kBackgroundColorBright,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Activity",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    fontSize:
                                        DeviceSizeConfig.deviceWidth * 0.07,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Container(
                                  width: DeviceSizeConfig.deviceWidth * 0.9,
                                  height: DeviceSizeConfig.deviceHeight * 0.5,
                                  child: FutureBuilder(
                                    future:
                                        _activityController.getActivityLevel(
                                            moduleId,
                                            oldAdaptiveScore,
                                            context),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data.isNotEmpty) {
                                        if (!setStateFinished) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (timeStamp) {
                                            setState(() {
                                              activityDetails = snapshot.data;
                                              setStateFinished = true;
                                            });
                                          });
                                        }

                                        try {
                                          _checkIfAllActivitiesCompleted(
                                              userCompletionStatus,
                                              oldAdaptiveScore,
                                              moduleId);
                                        } catch (e) {
                                          setStateFinished = false;
                                          _activityController
                                              .checkCompletionStatus()
                                              .then((value) {
                                            if (!setStateFinished) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                setState(() {
                                                  userCompletionStatus = value;
                                                  setStateFinished = true;
                                                });
                                              });
                                            }
                                          });
                                        }

                                        var keys = snapshot.data.length;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: keys,
                                            itemBuilder: (context, index) {
                                              return ActivityListTile(
                                                content: snapshot.data[index],
                                              );
                                            });
                                      } else if (snapshot.hasData &&
                                          snapshot.data.isEmpty) {
                                        print('its empty');
                                        if (!alreadyNavigated) {
                                          checkFirstScoreAnswer(false);
                                        }

                                        return Center();
                                      } else {
                                        return Center(
                                          child: Container(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: kGrey3,
            body: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  void _checkIfAllActivitiesCompleted(
      Map userCompletionStatus, Map oldAdaptiveScore, String moduleId) {
    int levelInt = oldAdaptiveScore[moduleId] + 1, everyCompleted = 0;
    String level = 'level' + levelInt.toString();
    List completionStatuses = userCompletionStatus[moduleId][level];

    completionStatuses.every((element) {
      if (element == 'completed') {
        everyCompleted = everyCompleted + 1;
        return true;
      } else {
        return false;
      }
    });

    if (everyCompleted == completionStatuses.length) {
      _activityController
          .badgeToUnlock(moduleId, context)
          .whenComplete(() async {
        if (!checkedBadgeOnce) {
          newAdaptiveAnswer =
              await _userController.checkLastScorePresence(moduleId);
          ++count;
          if (!newAdaptiveAnswer && count == 1) {
            print('checked badge to unlock');
            CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              text:
                  'Before you complete ${moduleContent['moduleTitle']} module, please answer the following questions. Thank you.',
              barrierDismissible: false,
              confirmBtnText: 'Okay',
              onConfirmBtnTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SelectiveAdaptiveQuiz(
                        moduleId: moduleId,
                        isLastScore: true,
                      );
                    },
                  ),
                ).whenComplete(() => newAdaptiveAnswer = true);
              },
            );
          }
          checkedBadgeOnce = true;
        }
        //return CoolAlert.show(context: context, type: CoolAlertType.loading);
      });
    }
  }

  checkFirstScoreAnswer(bool oldScore) {
    if (!oldScore) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          alreadyNavigated = true;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SelectiveAdaptiveQuiz(moduleId: moduleId, isLastScore: false);
        }));
      });
    }
  }
}

customPop(BuildContext context) {
  Navigator.popUntil(context, ModalRoute.withName('/student-home'));
  return false;
}

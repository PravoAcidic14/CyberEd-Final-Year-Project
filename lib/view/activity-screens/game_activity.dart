import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/draggable_game_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';

class GameActivity extends StatefulWidget {
  GameActivity({Key key}) : super(key: key);

  @override
  _GameActivityState createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {
  Map gameMainData;
  DraggableGameController _draggableGameController = DraggableGameController();
  String defaultQuestion = 'Question --',
      answerString = '',
      onDragCompleteString = '';
  List<String> mainQuestionText = [];
  int _defaultIndex = 1, setCount, totalAnsweredCorrectly = 0;
  bool setStateFinished = false, accepted = false, allActivityCompleted;
  UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    if (gameMainData == null || gameMainData.isEmpty) {
      gameMainData = ModalRoute.of(context).settings.arguments;
    }
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
          color: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                defaultQuestion,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                  fontSize: DeviceSizeConfig.deviceWidth * 0.07,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Container(
                height: DeviceSizeConfig.deviceHeight * 0.01,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: setCount != null
                        ? (_defaultIndex / setCount).toDouble()
                        : 1.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kAdaptiveProgressColor),
                    backgroundColor: Color(0xFFFFDAB8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: DeviceSizeConfig.deviceHeight * 0.07,
            ),
            Expanded(
              child: Container(
                width: DeviceSizeConfig.deviceWidth * 0.9,
                height: DeviceSizeConfig.deviceHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  color: kBackgroundColorBright,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(3.0, -2.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: mainQuestionText != null
                            ? buildQuestionWidget(
                                mainQuestionText, answerString)
                            : null,
                      ),
                      FutureBuilder(
                        future: _draggableGameController
                            .parseGameContentFromId(gameMainData['gameId']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            setCount = snapshot.data['setAmount'];
                            List optionList = _draggableGameController
                                .getOptionsListBySetNumber(
                                    _defaultIndex, snapshot.data);
                            if (!setStateFinished) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                setState(() {
                                  setStateFinished = true;
                                  defaultQuestion =
                                      "Question $_defaultIndex/$setCount";
                                  mainQuestionText = _draggableGameController
                                      .getQuestionBySetNumber(
                                          _defaultIndex, snapshot.data);
                                  answerString = _draggableGameController
                                      .getAnswerBySetNumber(
                                          _defaultIndex, snapshot.data);
                                  if (_defaultIndex != setCount) {
                                    onDragCompleteString = 'Next';
                                  } else {
                                    onDragCompleteString = 'Finish';
                                  }
                                });
                              });
                            }
                            return GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              padding: EdgeInsets.all(12.0),
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 3.0,
                              children: optionList.map((item) {
                                return Draggable(
                                  data: item,
                                  childWhenDragging: Container(
                                    decoration: BoxDecoration(
                                      color: kGrey3,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                  ),
                                  feedback: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.4,
                                    height:
                                        DeviceSizeConfig.deviceHeight * 0.055,
                                    decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(1.0, 3.0),
                                            color: Colors.black38,
                                            blurRadius: 5.0,
                                          )
                                        ]),
                                    child: Center(
                                      child: Container(
                                        child: Text(item,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  DeviceSizeConfig.deviceWidth *
                                                      0.05,
                                            )),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(1.0, 3.0),
                                            color: Colors.black38,
                                            blurRadius: 5.0,
                                          )
                                        ]),
                                    child: Center(
                                      child: Text(item,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                DeviceSizeConfig.deviceWidth *
                                                    0.05,
                                          )),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Center(
                                child: Container(
                              child: CircularProgressIndicator(),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildQuestionWidget(List<String> mainQuestionText, String answerString) {
    if (mainQuestionText.length == 2) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              mainQuestionText[0],
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: DeviceSizeConfig.deviceWidth * 0.06,
              ),
            ),
          ),
          DragTarget<String>(
            builder:
                (BuildContext context, List<String> incoming, List rejected) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: DeviceSizeConfig.deviceHeight * 0.065,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 5.0,
                      ),
                    )),
                  ));
            },
            onWillAccept: (data) {
              accepted = true;
              return true;
            },
            onAccept: (data) {
              if (data == answerString) {
                totalAnsweredCorrectly = totalAnsweredCorrectly + 1;
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.success,
                  title: 'Correct!',
                  confirmBtnText: onDragCompleteString,
                  onConfirmBtnTap: () async {
                    if (_defaultIndex < setCount) {
                      setState(() {
                        setStateFinished = false;
                        _defaultIndex = _defaultIndex + 1;
                      });
                      Navigator.pop(context);
                    } else if (_defaultIndex == setCount) {
                      if (totalAnsweredCorrectly == setCount) {
                        await _userController
                            .completeActivity(
                                activityId: gameMainData["activityId"],
                                activityListLength:
                                    gameMainData["activityListLength"],
                                moduleId: gameMainData["moduleId"],
                                level: gameMainData["level"],
                                activityPoints:
                                    int.parse(gameMainData["activityPoints"].toString()))
                            .then((value) {
                          if (value) {
                            setState(() {
                              allActivityCompleted = value;
                            });
                          }
                        }).whenComplete(() {
                          Navigator.restorablePopAndPushNamed(
                              context, '/activity-view',
                              arguments: gameMainData["moduleId"]);
                          if (allActivityCompleted) {
                            return CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Congratulations!',
                                text: 'You have successfully completed ' +
                                    gameMainData['activityTitle'] +
                                    '!');
                          }
                        }).catchError((onError) {
                          return CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: onError);
                        });
                      } else {
                        Navigator.restorablePopAndPushNamed(
                            context, '/activity-view',
                            arguments: gameMainData["moduleId"]);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title: 'Oh No...',
                            text:
                                'You\'ve not answered all questions correctly. Please try again.');
                      }
                    }
                  },
                );
              } else {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  title: 'Wrong!',
                  confirmBtnText: onDragCompleteString,
                  onConfirmBtnTap: () async {
                    if (_defaultIndex < setCount) {
                      setState(() {
                        setStateFinished = false;
                        _defaultIndex = _defaultIndex + 1;
                      });
                      Navigator.pop(context);
                    } else if (_defaultIndex == setCount) {
                      if (totalAnsweredCorrectly == setCount) {
                        await _userController
                            .completeActivity(
                                activityId: gameMainData["activityId"],
                                activityListLength:
                                    gameMainData["activityListLength"],
                                moduleId: gameMainData["moduleId"],
                                level: gameMainData["level"],
                                activityPoints: gameMainData["activityPoints"])
                            .then((value) {
                          if (value) {
                            setState(() {
                              allActivityCompleted = value;
                            });
                          }
                        }).whenComplete(() {
                          Navigator.restorablePopAndPushNamed(
                              context, '/activity-view',
                              arguments: gameMainData["moduleId"]);
                          if (allActivityCompleted) {
                            return CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Congratulations!',
                                text: 'You have successfully completed ' +
                                    gameMainData['activityTitle'] +
                                    '!');
                          }
                        }).catchError((onError) {
                          return CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: onError);
                        });
                      } else {
                        Navigator.restorablePopAndPushNamed(
                            context, '/activity-view',
                            arguments: gameMainData["moduleId"]);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title: 'Oh No...',
                            text:
                                'You\'ve not answered all questions correctly. Please try again.');
                      }
                    }
                  },
                );
              }
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              mainQuestionText[1],
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: DeviceSizeConfig.deviceWidth * 0.06,
              ),
            ),
          ),
        ],
      );
    } else if (mainQuestionText.length == 1) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              mainQuestionText[0],
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: DeviceSizeConfig.deviceWidth * 0.06,
              ),
            ),
          ),
          DragTarget<String>(builder:
              (BuildContext context, List<String> incoming, List rejected) {
            return Container(
              height: DeviceSizeConfig.deviceHeight * 0.055,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 5.0,
                ),
              )),
            );
          })
        ],
      );
    }
  }
}

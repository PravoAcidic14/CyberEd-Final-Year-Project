import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/adaptive_learning_controller.dart';
import 'package:fyp_app_design/view/components/buttons.dart';

import 'components/segmented_circular_progress.dart';

class AdaptiveQuizView extends StatefulWidget {
  AdaptiveQuizView({Key key}) : super(key: key);

  @override
  _AdaptiveQuizViewState createState() => _AdaptiveQuizViewState();
}

class _AdaptiveQuizViewState extends State<AdaptiveQuizView> {
  int adaptiveSetCount,
      selectedOptionIndex,
      answerIndex,
      totalQuestions,
      totalCorrectAnswers = 0;
  List modules = [];
  bool isAnswered;
  AdaptiveLearningController _adaptiveLearningController =
      AdaptiveLearningController();

  @override
  void initState() {
    adaptiveSetCount = 0;
    isAnswered = false;
    getModule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List adaptiveSet = [], answerOptions = [];
    DeviceSizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgroundColorBright,
      body: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                  future: _adaptiveLearningController.populateList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      adaptiveSet = snapshot.data;
                      totalQuestions = adaptiveSet.length;
                      print(adaptiveSet);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              AdaptiveSegmentedCircularProgress(
                                stops:
                                    ((adaptiveSetCount + 1) / totalQuestions),
                                count: adaptiveSetCount + 1,
                                total: totalQuestions,
                              )
                            ],
                          ),
                          Text(
                            adaptiveSet[adaptiveSetCount]['question'],
                            style: titleStyleWhite(
                                fontsize: DeviceSizeConfig.deviceWidth * 0.05),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            backgroundColor: kBackgroundColorBright,
                          ),
                        ),
                      );
                    }
                  }),
            ),
            width: DeviceSizeConfig.deviceWidth,
            height: DeviceSizeConfig.deviceHeight * 0.40,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(3, 5),
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              width: DeviceSizeConfig.deviceWidth * 0.9,
              child: FutureBuilder<List>(
                  future: _adaptiveLearningController.populateList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      answerIndex =
                          snapshot.data[adaptiveSetCount]['answerIndex'];
                      answerOptions =
                          snapshot.data[adaptiveSetCount]['options'];
                      return Column(
                          children: answerOptions
                              .map((options) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 12.0),
                                    child: AppButtons(
                                      onPressed: () {
                                        setState(() {
                                          //set the selected option's index
                                          selectedOptionIndex =
                                              answerOptions.indexOf(options);
                                        });

                                        //check the answer
                                        isAnswered = _adaptiveLearningController
                                            .checkAnswer(selectedOptionIndex,
                                                answerIndex);

                                        Timer(Duration(seconds: 1), () async {
                                          if (adaptiveSetCount ==
                                              totalQuestions - 1) {
                                            await _adaptiveLearningController
                                                .calcScore(modules, false);

                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/student-home',
                                                (route) => false);
                                          } else {
                                            setState(() {
                                              adaptiveSetCount++;
                                              selectedOptionIndex = null;
                                            });
                                          }
                                        });
                                      },
                                      buttonText: Text(
                                        options,
                                        style: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            color: getRightButtonColor(
                                                    isAnswered,
                                                    selectedOptionIndex,
                                                    answerOptions
                                                        .indexOf(options))
                                                .last),
                                        textAlign: TextAlign.center,
                                      ),
                                      fillColor: getRightButtonColor(
                                              isAnswered,
                                              selectedOptionIndex,
                                              answerOptions.indexOf(options))
                                          .first,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(17.0))),
                                    ),
                                  ))
                              .toList());
                    } else {
                      return Center(
                          child: Container(
                        child: CircularProgressIndicator(),
                      ));
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  Future<List> getModule() async {
    var module;
    module = await _adaptiveLearningController.getAllModules();

    setState(() {
      modules = module;
    });
    return module;
  }
}

List<Color> getRightButtonColor(
    bool isAnswered, int selectedOptionIndex, int currentIndex) {
  if (currentIndex == selectedOptionIndex) {
    if (isAnswered) {
      return [kGreenColor, kWhite];
    } else {
      return [kRed, kWhite];
    }
  } else {
    return [kWhite, kOptionsGrey];
  }
}

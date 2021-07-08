

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/badge_controller.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import 'package:fyp_app_design/controller/student-progress-controller.dart';
import 'package:fyp_app_design/view/components/indicator.dart';

class StudentProgressView extends StatefulWidget {
  @override
  _StudentProgressViewState createState() => _StudentProgressViewState();
}

class _StudentProgressViewState extends State<StudentProgressView> {
  StudentProgressController _progressController = StudentProgressController();
  BadgeController _badgeController = BadgeController();
  Map _moduleAndTitle = {};
  List unlockedBadgesList = [];

  @override
  void initState() {
    _progressController.getModuleTitle().then((value) {
      setState(() {
        _moduleAndTitle = value;
      });
    });

    _progressController.getBadgeList().then((value) {
      if (value != null) {
        setState(() {
          unlockedBadgesList = value;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryLightBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 8.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Progress',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w800,
                        fontSize: DeviceSizeConfig.deviceWidth * 0.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      width: DeviceSizeConfig.deviceWidth,
                      height: DeviceSizeConfig.deviceHeight * 0.8,
                      decoration: BoxDecoration(
                        color: kLightTextFieldColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(3.0, 3.0),
                              blurRadius: 8.0,
                              spreadRadius: 2.0)
                        ],
                        border: Border.all(
                          color: Colors.orange,
                          width: 4.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: DeviceSizeConfig.deviceHeight * 0.5,
                            child: FutureBuilder<Map>(
                              future: _progressController.getProgressData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List completedModule =
                                      snapshot.data.keys.toList();
                                  Map colorAndModule = _progressController
                                      .matchColorWithCompletedModule(
                                          completedModule);
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Modules Completed',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:
                                                DeviceSizeConfig.deviceWidth *
                                                    0.07,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: double.infinity,
                                            height:
                                                DeviceSizeConfig.deviceHeight *
                                                    0.2,
                                            child: PieChart(
                                              PieChartData(
                                                  centerSpaceRadius:
                                                      DeviceSizeConfig
                                                              .deviceWidth *
                                                          0.25,
                                                  sections: [
                                                    for (var item
                                                        in completedModule)
                                                        
                                                      PieChartSectionData(
                                                        title: _progressController
                                                            .convertDoubleToIntPercentage(
                                                                snapshot.data,
                                                                item),
                                                        color: colorAndModule[
                                                            item],
                                                        value: _progressController
                                                            .getAmountOfCompletion(
                                                                snapshot.data,
                                                                item),
                                                      )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var item in completedModule)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Indicator(
                                                  color: colorAndModule[item],
                                                  text: _moduleAndTitle[item],
                                                  textColor: Colors.black,
                                                  isSquare: true,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Text(
                                          'Nothing to show yet...',
                                          style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  DeviceSizeConfig.deviceWidth *
                                                      0.04),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      width: DeviceSizeConfig.deviceWidth,
                      decoration: BoxDecoration(
                        color: kLightTextFieldColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(3.0, 3.0),
                              blurRadius: 8.0,
                              spreadRadius: 2.0)
                        ],
                        border: Border.all(
                          color: Colors.blue,
                          width: 4.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Badges',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: DeviceSizeConfig.deviceWidth * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: DeviceSizeConfig.deviceHeight * 0.07,
                            ),
                            if (unlockedBadgesList.isNotEmpty)
                              for (var item in unlockedBadgesList)
                                FutureBuilder(
                                  future: _badgeController
                                      .getBadgeDetailsById(item),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          width: DeviceSizeConfig.deviceWidth *
                                              0.8,
                                          height:
                                              DeviceSizeConfig.deviceHeight *
                                                  0.15,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            color: kWhite,
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: DeviceSizeConfig
                                                          .deviceHeight *
                                                      0.1,
                                                  height: DeviceSizeConfig
                                                          .deviceHeight *
                                                      0.1,
                                                  child: Lottie.network(snapshot
                                                      .data['badgeUrl']),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 8.0,
                                                ),
                                                child: Container(
                                                  width: DeviceSizeConfig
                                                          .deviceWidth *
                                                      0.45,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data['badgeName'],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: DeviceSizeConfig
                                                                  .deviceWidth *
                                                              0.05,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8.0),
                                                        child: Text(
                                                          snapshot.data[
                                                              'badgeDescription'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                DeviceSizeConfig
                                                                        .deviceWidth *
                                                                    0.04,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Container(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                            if (unlockedBadgesList.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                  'Nothing to show yet...',
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.normal,
                                      fontSize:
                                          DeviceSizeConfig.deviceWidth * 0.04),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _buildBadgeCard(List unlockedBadgesList) {
  //   for (var item in unlockedBadgesList) {
  //     return FutureBuilder(
  //       future: _badgeController.getBadgeDetailsById(item),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return Container(
  //             color: kBlue1,
  //           );
  //         } else {
  //           return Center(
  //             child: Container(
  //               child: CircularProgressIndicator(),
  //             ),
  //           );
  //         }
  //       },
  //     );
  //   }
  // }
}

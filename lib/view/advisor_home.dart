import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/advisor_controller.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/controller/advisor_progress_controller.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/indicator.dart';

class AdvisorHomeView extends StatefulWidget {
  @override
  _AdvisorHomeViewState createState() => _AdvisorHomeViewState();
}

class _AdvisorHomeViewState extends State<AdvisorHomeView> {
  SharedPreferences _sharedPreferences;
  AdvisorController _advisorController = AdvisorController();
  AdvisorProgressController _advProgressCon = AdvisorProgressController();
  ModuleController _moduleController = ModuleController();
  PageController _pageController;
  int _currentIndex = 0;
  String matricsId;
  Map userData = {}, moduleWithColors = {};
  List moduleIdList = [], progressData = [];
  String selectedModuleTitle = '';
  Map allModulesWithTitle = {};
  bool setStateFinished = false;
  final List chartColor = [
    Colors.grey,
    kGreenColor,
    kBlue1,
    Colors.red,
  ];
  final List chartText = [
    'Incomplete',
    'Progressive Understanding',
    'No difference',
    'Unprogressive Understanding'
  ];

  Future initSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);

    _moduleController.getAllModules().then((value) {
      setState(() {
        moduleIdList = value;
      });
    });

    _moduleController.getModuleWithColorCode().then((value) {
      setState(() {
        moduleWithColors = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    initSharedPref().whenComplete(() {
      if (matricsId == null) {
        matricsId = _sharedPreferences.getString('advisorMatricsId');
        if (matricsId != null) {
          _advisorController.getAdvisorData(matricsId).then((value) {
            setState(() {
              userData = value;
            });
          });
        }
      }
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() {
              _currentIndex = i;
              print(_currentIndex);
            });
            _pageController.animateToPage(_currentIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.blue,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.emoji_events),
              title: Text("Dashboard"),
              selectedColor: Colors.orange,
            ),

            /// Profile
          ],
        ),
        body: PageView(
          onPageChanged: (value) {
            print(value);
            setState(() {
              _currentIndex = value;
            });
          },
          controller: _pageController,
          children: [
            Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                toolbarHeight: DeviceSizeConfig.deviceHeight * 0.1,
                leadingWidth: DeviceSizeConfig.deviceHeight * 0.1,
                leading: userData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: DeviceSizeConfig.deviceWidth * 0.35,
                          height: DeviceSizeConfig.deviceWidth * 0.35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGrey1,
                          ),
                          child: Container(
                            width: DeviceSizeConfig.deviceWidth * 0.3,
                            height: DeviceSizeConfig.deviceWidth * 0.3,
                            child: ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/loading_indicator.gif',
                                image: userData['avatarUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Container(child: CircularProgressIndicator())),
                title: Text(
                  'Hi ${userData['fName']}',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: DeviceSizeConfig.deviceWidth * 0.08,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: kGrey1,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/advisor-settings',
                            arguments: matricsId);
                      },
                      iconSize: DeviceSizeConfig.deviceWidth * 0.08,
                    ),
                  ),
                ],
              ),
              backgroundColor: kBackgroundColorBright,
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: kPrimaryColor,
                label: Text(
                  'Create a Module',
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                icon: Icon(Icons.add),
                onPressed: () =>
                    Navigator.pushNamed(context, '/advisor-create-module'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: DeviceSizeConfig.deviceHeight * 0.03,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Modules',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                          color: kGrey1,
                          fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                        ),
                      ),
                    ),
                    Container(
                      width: DeviceSizeConfig.deviceWidth * 0.9,
                      height: DeviceSizeConfig.deviceHeight * 0.7,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: moduleIdList.length,
                                itemBuilder: (context, index) {
                                  try {
                                    return GestureDetector(
                                      onTap: () async {
                                        await _addModuleId(moduleIdList[index]);
                                        Navigator.pushNamed(
                                            context, '/advisor-update-module',
                                            arguments: moduleWithColors[
                                                moduleIdList[index]]);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 24.0),
                                        child: Container(
                                          width: DeviceSizeConfig.deviceWidth *
                                              0.9,
                                          height:
                                              DeviceSizeConfig.deviceHeight *
                                                  0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(2, 4),
                                                blurRadius: 5.0,
                                                color: Colors.black45,
                                              )
                                            ],
                                            color: moduleWithColors[
                                                        moduleIdList[index]]
                                                    ['containerColor']
                                                .color,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: DeviceSizeConfig
                                                        .deviceWidth *
                                                    0.45,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Text(
                                                    moduleWithColors[
                                                            moduleIdList[index]]
                                                        ['moduleTitle'],
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: DeviceSizeConfig
                                                              .deviceWidth *
                                                          0.07,
                                                      color: kWhite,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: DeviceSizeConfig
                                                        .deviceWidth *
                                                    0.4,
                                                height: DeviceSizeConfig
                                                        .deviceWidth *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/loading_indicator.gif',
                                                    image: moduleWithColors[
                                                            moduleIdList[index]]
                                                        ["thumbnailUrl"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    return Center(
                                      child: Container(),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
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
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height:
                                        DeviceSizeConfig.deviceHeight * 0.75,
                                    child: FutureBuilder<List>(
                                      future: _advProgressCon
                                          .getStudentAdaptiveScores(
                                              selectedModuleTitle.isEmpty
                                                  ? 'M001'
                                                  : allModulesWithTitle.keys
                                                      .firstWhere((k) =>
                                                          allModulesWithTitle[
                                                              k] ==
                                                          selectedModuleTitle)),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          print(snapshot.data);

                                          progressData = snapshot.data;

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 8.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Student Understanding',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: DeviceSizeConfig
                                                            .deviceWidth *
                                                        0.07,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: DeviceSizeConfig
                                                            .deviceHeight *
                                                        0.2,
                                                    child:
                                                        progressData.isNotEmpty
                                                            ? PieChart(
                                                                PieChartData(
                                                                  centerSpaceRadius:
                                                                      DeviceSizeConfig
                                                                              .deviceWidth *
                                                                          0.25,
                                                                  sections: [
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            snapshot.data.length -
                                                                                1;
                                                                        i++)
                                                                      PieChartSectionData(
                                                                          title: _advProgressCon.convertDoubleToText(snapshot.data[
                                                                              i]),
                                                                          color: chartColor[
                                                                              i],
                                                                          value:
                                                                              snapshot.data[i])
                                                                  ],
                                                                ),
                                                              )
                                                            : Center(
                                                                child: Container(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Container(
                                                  width: DeviceSizeConfig
                                                          .deviceWidth *
                                                      0.7,
                                                  child: Text(
                                                    snapshot.data.isEmpty
                                                        ? 'Total Students: --'
                                                        : 'Total Students: ${snapshot.data.last}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      fontSize: DeviceSizeConfig
                                                              .deviceWidth *
                                                          0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )),
                                                FutureBuilder<
                                                        Map<String, String>>(
                                                    future: _advProgressCon
                                                        .getModuleTitle(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (timeStamp) {
                                                          if (!setStateFinished) {
                                                            setState(() {
                                                              allModulesWithTitle =
                                                                  snapshot.data;
                                                              setStateFinished =
                                                                  true;
                                                            });
                                                          }
                                                        });

                                                        List<String> options =
                                                            snapshot.data.values
                                                                .toList();
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      12.0),
                                                          child:
                                                              AppDropdownFormField(
                                                            value: selectedModuleTitle
                                                                    .isEmpty
                                                                ? snapshot.data[
                                                                    'M001']
                                                                : selectedModuleTitle,
                                                            options: options,
                                                            fillColor:
                                                                kLightTextFieldColor,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                progressData
                                                                    .clear();
                                                                selectedModuleTitle =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    for (int i = 0; i < 4; i++)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Indicator(
                                                          color: chartColor[i],
                                                          text: chartText[i],
                                                          textColor:
                                                              Colors.black,
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
                                              child:
                                                  CircularProgressIndicator(),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _addModuleId(String moduleId) async {
    await moduleWithColors[moduleId].putIfAbsent('moduleId', () => moduleId);
  }
}

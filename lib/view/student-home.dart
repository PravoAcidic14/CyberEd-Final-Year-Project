import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/controller/student_home_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp_app_design/view/components/homepage_row_title.dart';
import 'package:fyp_app_design/view/student-progress.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:fyp_app_design/controller/user_auth.dart';

import 'components/homepage_module_container.dart';
import 'components/student_profile_buttons.dart';
import 'components/student_profile_header.dart';

class StudentHomeView extends StatefulWidget {
  @override
  _StudentHomeViewState createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView>
    with SingleTickerProviderStateMixin {
  UserAuth _userAuth = UserAuth(FirebaseAuth.instance);
  UserController _userController = UserController();
  StudentHomeController _studentHomeController = StudentHomeController();
  StudentProgressView _studentProgressView = StudentProgressView();
  PageController _pageController;
  List _recommendedModulesList = [], _allModulesList = [];
  List<StudentProfilePageButtons> _profileButtons = [];
  Map userMap = {}, userOldAdaptiveScore = {};
  String userFirstName, userAvatarURL;
  int _currentIndex = 1;
  AnimationController _fader;
  var points = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);

    _userController.getUserStudentData().then((value) {
      setState(() {
        userMap = value;
      });
    });

    _userController.getUserAdaptiveScores().then((value) {
      setState(() {
        userOldAdaptiveScore = value;
      });
    });

    _studentHomeController.getRecommendedModuleDisplay().then((recommended) {
      setState(() {
        _recommendedModulesList = recommended;
      });
    });
    _studentHomeController.getAllModuleDisplay().then((list) {
      setState(() {
        _allModulesList = list;
      });
    });

    _fader =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..forward();

    _profileButtons = [
      StudentProfilePageButtons(
        onPressed: () =>
            Navigator.pushNamed(context, '/edit-profile').then((value) {
          _userController.getUserStudentData().then((value) {
            setState(() {
              userMap = value;
            });
          });
        }),
        btnIcon: Icons.people,
        btnLabel: "Personal Information",
        fontColor: Colors.black,
      ),
      StudentProfilePageButtons(
        onPressed: () => userTapSignout(),
        btnIcon: Icons.exit_to_app,
        btnLabel: "Sign Out",
        fontColor: Colors.red,
      )
    ];

    super.initState();
  }

  void userTapSignout() {
    CoolAlert.show(
      context: context,
      showCancelBtn: true,
      type: CoolAlertType.warning,
      title: "Are you sure?",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      onConfirmBtnTap: () => _userAuth.signOut().whenComplete(() =>
          Navigator.popUntil(context, ModalRoute.withName('/student-login'))),
    );
  }

  @override
  void dispose() {
    _fader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("recommended length " + _recommendedModulesList.length.toString());
    print("all length " + _allModulesList.length.toString());
    DeviceSizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() => _currentIndex = i);
            _pageController.animateToPage(_currentIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          items: [
            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.emoji_events),
              title: Text("Dashboard"),
              selectedColor: Colors.orange,
            ),

            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.blue,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
        backgroundColor: kBackgroundColorBright,
        body: PageView(
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          controller: _pageController,
          children: [
            _studentProgressView,
            Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        kBlue1,
                        kBlue2,
                        kBlue3,
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                toolbarHeight: DeviceSizeConfig.deviceHeight * 0.12,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
                elevation: 5.0,
                shadowColor: Colors.black,
                leadingWidth: DeviceSizeConfig.deviceHeight * 0.12,
                leading: userMap.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: DeviceSizeConfig.deviceWidth * 0.3,
                          height: DeviceSizeConfig.deviceWidth * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGrey2,
                          ),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/loading_indicator.gif',
                              image: userMap['avatarUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(child: CircularProgressIndicator()),
                title: userMap.isNotEmpty
                    ? FadeTransition(
                        opacity: _fader,
                        child: Text(
                          'Hi ' + userMap['firstName'],
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: DeviceSizeConfig.deviceWidth * 0.07,
                          ),
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: StreamBuilder<Event>(
                        stream: _userController.getTotalPoints(),
                        builder: (context, snapshots) {
                          if (snapshots.hasData) {
                            return Text(
                                snapshots.data.snapshot.value.toString() +
                                    ' XP');
                          } else {
                            return Container(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.lightGreenAccent[400],
                      shadowColor: Colors.black,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: kPrimaryLightBackground,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomePageRowTitle(title: "Recommended For You"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var modules in _recommendedModulesList)
                              HomePageModuleContainer(
                                moduleId: modules["moduleId"],
                                moduleTitle: modules["moduleTitle"],
                                thumbnailUrl: modules["thumbnailUrl"],
                              ),
                          ],
                        ),
                      ),
                      HomePageRowTitle(title: "All Topics"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var modules in _allModulesList)
                              HomePageModuleContainer(
                                moduleId: modules["moduleId"],
                                moduleTitle: modules["moduleTitle"],
                                thumbnailUrl: modules["thumbnailUrl"],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: kLightTextFieldColor,
              body: Container(
                child: Column(
                  children: [
                    StudentProfilePageHeader(userMap: userMap),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return _profileButtons[index];
                        },
                        itemCount: _profileButtons.length,
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
  }
}

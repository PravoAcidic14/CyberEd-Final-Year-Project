//this screen is a non functional screen and only used to inform users of any event

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/view/components/buttons.dart';
import 'package:lottie/lottie.dart';

class IntroBeforeAdaptiveQuizScreen extends StatefulWidget {
  const IntroBeforeAdaptiveQuizScreen({Key key}) : super(key: key);

  @override
  _IntroBeforeAdaptiveQuizScreenState createState() =>
      _IntroBeforeAdaptiveQuizScreenState();
}

class _IntroBeforeAdaptiveQuizScreenState
    extends State<IntroBeforeAdaptiveQuizScreen> with TickerProviderStateMixin {
  AnimationController _animationController,
      _lottieController,
      _buttonAnimController;
  Animation<double> _fadeInfadeOut, _buttonAnim;
  UserController _userController = UserController();
  int greetTextCounter = 0;
  Map userMap = Map();
  List<String> animatableGreetText = [
    'Before you start learning Cyber Security here',
    'Help us personalize your learning plan by taking a 3 - 4 minute test',
    'All the best!',
  ];

  @override
  void initState() {
    super.initState();
    //get user name
    _userController.getUserStudentData().then((value) {
      animatableGreetText.insert(
          0, 'Welcome to CyberEd, ' + value['firstName']);
    });

    //animation controllers

    _lottieController = AnimationController(vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    _buttonAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000), value: 0.00001);

    //animation
    _fadeInfadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _buttonAnim =
        CurvedAnimation(parent: _buttonAnimController, curve: Curves.bounceOut);

    //animation method
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controlAnimation(greetTextCounter);
    });
  }

  void controlAnimation(int greetTextCounterValue) {
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer.run(() {
          _animationController.stop();
        });
        Timer(Duration(milliseconds: 2500), () {
          if (greetTextCounterValue < 3) {
            _animationController.reverse().whenComplete(() {
              updateState();
            });
          } else {
            _animationController.stop();
            _buttonAnimController.forward();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    print(greetTextCounter);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kBlue3, kPrimaryColor])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset(
                'assets/welcome_lottie.json',
                width: DeviceSizeConfig.deviceWidth * 0.85,
                height: DeviceSizeConfig.deviceWidth * 0.85,
                frameRate: FrameRate.max,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController..duration = composition.duration;
                  _lottieController.forward();
                  _lottieController.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      _lottieController.repeat(
                          min: 0.2233370556175936, max: 1.0);
                    }
                  });
                },
              ),
              FutureBuilder(
                future: _userController.getUserStudentData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userMap = snapshot.data;
                    return Center(
                      child: FadeTransition(
                        opacity: _fadeInfadeOut,
                        child: Container(
                          width: DeviceSizeConfig.deviceWidth * 0.85,
                          child: Text(
                            animatableGreetText[greetTextCounter].toString(),
                            style: semiBoldTextStyleCustom(
                              fontsize: DeviceSizeConfig.deviceWidth * 0.06,
                              color: kWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          backgroundColor: kWhite,
                        ),
                      ),
                    );
                  }
                },
              ),
              ScaleTransition(
                scale: _buttonAnim,
                alignment: Alignment.center,
                child: Container(
                  width: DeviceSizeConfig.deviceWidth * 0.7,
                  child: AppButtons(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/adaptive-quiz', (route) => false);
                    },
                    buttonText: Text(
                      'Get Started',
                      style: semiBoldTextStyleCustom(
                        fontsize: DeviceSizeConfig.deviceWidth * 0.05,
                      ),
                    ),
                    fillColor: kGreenColor,
                    otherColor: kGreenDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateState() {
    if (greetTextCounter < 3) {
      setState(() {
        greetTextCounter++;
      });
      controlAnimation(greetTextCounter);
    }
  }

  void displayNextScreen() {}

  @override
  void dispose() {
    _animationController.dispose();
    _lottieController.dispose();
    _buttonAnimController.dispose();
    super.dispose();
  }
}

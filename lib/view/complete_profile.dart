import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/model/users.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';
import 'package:fyp_app_design/view/components/text_field.dart';
import 'package:fyp_app_design/view/components/buttons.dart';

class CompleteProfilePageView extends StatefulWidget {
  @override
  _CompleteProfilePageViewState createState() =>
      _CompleteProfilePageViewState();
}

class _CompleteProfilePageViewState extends State<CompleteProfilePageView> {
  final String firstPageTitle = 'Let\'s Start with your Name';
  final String secondPageTitle = 'Thanks!  What\'s your Year Level?';
  final String lastPageTitle = 'Great! Now just pick an Avatar';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  String ageRangeString = '10 - 12';
  int ageRange;
  File avatarImage;
  String userProfilePicUrl;
  bool pictureChosen = false;

  User _user = FirebaseAuth.instance.currentUser;

  PageController _pageController = PageController();
  AppImagePicker _appImagePicker = AppImagePicker();
  StorageController _storageController = StorageController();
  Student _studentModel = Student(FirebaseAuth.instance.currentUser);

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColorBright,
        body: PageView(
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                      child: Container(
                        child: Form(
                          key: _formKey1,
                          child: Column(
                            children: [
                              Text(
                                firstPageTitle,
                                style: titleStyleBlack(fontsize: 30.0),
                              ),
                              SizedBox(
                                height: DeviceSizeConfig.deviceHeight * 0.10,
                              ),
                              AppTextField(
                                textEditingController: firstNameController,
                                textFieldStyle: kTextFieldStyleDark,
                                labelText: 'First Name',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                              AppTextField(
                                textEditingController: lastNameController,
                                textFieldStyle: kTextFieldStyleDark,
                                labelText: 'Last Name',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    AppButtons(
                      buttonText: Text(
                        'Next',
                        style: kButtonTextStyleW,
                      ),
                      shape: RoundedRectangleBorder(),
                      fillColor: kGreenColor,
                      otherColor: kGreenDarker,
                      onPressed: () {
                        if (_formKey1.currentState.validate()) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                      child: Container(
                        child: Form(
                          key: _formKey2,
                          child: Column(
                            children: [
                              Text(
                                secondPageTitle,
                                style: titleStyleBlack(fontsize: 30.0),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: DeviceSizeConfig.deviceHeight * 0.10,
                              ),
                              AppDropdownFormField(
                                value: ageRangeString,
                                labelText: "Age",
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                options: ["10 - 12", "13 - 15", "16 - 17"],
                                onChanged: (value) {
                                  if (value == "10 - 12") {
                                    setState(() {
                                      ageRangeString = '10 - 12';
                                    });
                                  } else if (value == "13 - 15") {
                                    setState(() {
                                      ageRangeString = '13 - 15';
                                    });
                                  } else if (value == "16 - 17") {
                                    setState(() {
                                      ageRangeString = '16 - 17';
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: DeviceSizeConfig.deviceWidth,
                        height: DeviceSizeConfig.deviceHeight * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                width: DeviceSizeConfig.deviceWidth,
                                height: DeviceSizeConfig.deviceHeight,
                                child: AppButtons(
                                  buttonText: Text(
                                    'Back',
                                    style: kButtonTextStyleW,
                                  ),
                                  fillColor: kDarkTextFieldColor,
                                  shape: RoundedRectangleBorder(),
                                  otherColor: kGrey1,
                                  onPressed: () {
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: DeviceSizeConfig.deviceWidth,
                                height: DeviceSizeConfig.deviceHeight,
                                child: AppButtons(
                                  buttonText: Text(
                                    'Next',
                                    style: kButtonTextStyleW,
                                  ),
                                  fillColor: kGreenColor,
                                  shape: RoundedRectangleBorder(),
                                  otherColor: kGreenDarker,
                                  onPressed: () {
                                    if (_formKey2.currentState.validate()) {
                                      _pageController.nextPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut);
                                    }
                                  },
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                      child: Container(
                        child: Form(
                          key: _formKey3,
                          child: Column(
                            children: [
                              Text(
                                lastPageTitle,
                                style: titleStyleBlack(fontsize: 30.0),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: DeviceSizeConfig.deviceHeight * 0.10,
                              ),
                              Container(
                                width: DeviceSizeConfig.deviceWidth * 0.3,
                                height: DeviceSizeConfig.deviceWidth * 0.3,
                                child: CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 55,
                                  child: Container(
                                      width:
                                          DeviceSizeConfig.deviceWidth * 0.27,
                                      height:
                                          DeviceSizeConfig.deviceWidth * 0.27,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGrey2,
                                      ),
                                      child: ClipOval(
                                        child: userProfilePicUrl != null
                                            ? 
                                            FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/loading_indicator.gif',
                                                image: userProfilePicUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      )),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50.0),
                                child: Container(
                                  width: DeviceSizeConfig.deviceWidth * 0.9,
                                  height: DeviceSizeConfig.deviceHeight * 0.1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          width: DeviceSizeConfig.deviceWidth *
                                              0.35,
                                          height:
                                              DeviceSizeConfig.deviceHeight *
                                                  0.07,
                                          child: AppButtons(
                                            icon: Icon(Icons.camera_front),
                                            buttonText: Text('Camera',
                                                style: titleStyleWhite(
                                                    fontsize: 18.0)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7.0))),
                                            fillColor: kBlue2,
                                            onPressed: () async {
                                              avatarImage =
                                                  await _appImagePicker
                                                      .openCamera()
                                                      .catchError((error) {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: error);
                                              });

                                              if (avatarImage != null) {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.loading,
                                                    text:
                                                        'Loading Image', barrierDismissible: false,);
                                              }
                                              var tempFile =
                                                  await _storageController
                                                      .uploadNewUserProfileImage(
                                                          _user,
                                                          avatarImage,
                                                          context);

                                              if (tempFile != null) {
                                                setState(() {
                                                  userProfilePicUrl = tempFile;
                                                  Navigator.pop(context);
                                                });
                                              } else {}
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          width: DeviceSizeConfig.deviceWidth *
                                              0.35,
                                          height:
                                              DeviceSizeConfig.deviceHeight *
                                                  0.07,
                                          child: AppButtons(
                                            icon: Icon(Icons.image),
                                            buttonText: Text(
                                              'Gallery',
                                              style: boldTextStyleCustom(
                                                  fontsize: 18.0,
                                                  color: kBlue2),
                                            ),
                                            fillColor: kBackgroundColorBright,
                                            childColor: kBlue2,
                                            borderSide: BorderSide(
                                              color: kBlue2,
                                              width: 3.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7.0))),
                                            onPressed: () async {
                                              avatarImage =
                                                  await _appImagePicker
                                                      .openGallery()
                                                      .catchError((error) {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: error);
                                              });

                                              if (avatarImage != null) {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.loading,
                                                    text:
                                                        'Loading Image...',
                                                        barrierDismissible: false);
                                              }
                                              var tempFile =
                                                  await _storageController
                                                      .uploadNewUserProfileImage(
                                                          _user,
                                                          avatarImage,
                                                          context);

                                              if (tempFile != null) {
                                                setState(() {
                                                  userProfilePicUrl = tempFile;
                                                  Navigator.pop(context);
                                                });
                                              } else {}
                                            },
                                          ),
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
                    Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: DeviceSizeConfig.deviceWidth,
                        height: DeviceSizeConfig.deviceHeight * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                width: DeviceSizeConfig.deviceWidth,
                                height: DeviceSizeConfig.deviceHeight,
                                child: AppButtons(
                                  buttonText: Text(
                                    'Back',
                                    style: kButtonTextStyleW,
                                  ),
                                  shape: RoundedRectangleBorder(),
                                  fillColor: kDarkTextFieldColor,
                                  otherColor: kGrey1,
                                  onPressed: () {
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: DeviceSizeConfig.deviceWidth,
                                height: DeviceSizeConfig.deviceHeight,
                                child: AppButtons(
                                  buttonText: Text(
                                    'Finish',
                                    style: kButtonTextStyleW,
                                  ),
                                  shape: RoundedRectangleBorder(),
                                  fillColor: kGreenColor,
                                  otherColor: kGreenDarker,
                                  onPressed: () {
                                    if (userProfilePicUrl != null) {
                                      _studentModel.createNewStudent(
                                          context: context,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          ageRange: ageRangeString,
                                          avatarUrl: userProfilePicUrl,
                                          onConfirmBtnTap: () =>
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/intro-before-adaptive-quiz',
                                                  (route) => false));
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: 'Please pick an Avatar first.');
                                    }
                                  },
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
            ),
          ],
        ),
      ),
    );
  }
}

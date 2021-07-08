import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/controller/student_home_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';

import '../constants.dart';
import 'components/buttons.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  UserController _userController = UserController();
  AppImagePicker _appImagePicker = AppImagePicker();
  StudentHomeController _studentHomeController = StudentHomeController();
  TextEditingController _firstNameController,
      _lastNameController,
      _emailController;
  final _formKey = GlobalKey<FormState>();
  AlertDialog alert;
  File _avatarImage;
  Map userMap = {}, _newUserDetails = {};
  List _dropdownItems = ["10 - 12", "13 - 15", "16 - 17"];
  String _fName, _lName, _email, ageRange;

  // set up the buttons

  @override
  void initState() {
    myFocusNode.addListener(_onFocusChange);

    _userController.getUserStudentData().then((value) {
      setState(() {
        userMap = value;
        ageRange = userMap["ageRange"];
        _fName = userMap["firstName"];
        _lName = userMap["lastName"];
        _email = userMap["email"];
      });
    });

    Widget cancelButton = TextButton(
      child: Text("Camera"),
      onPressed: () async {
        var tempFile = await _appImagePicker
            .openCamera()
            .whenComplete(() => Navigator.pop(context));
        setState(() {
          _avatarImage = tempFile;
        });
      },
    );
    Widget continueButton = TextButton(
      child: Text("Gallery"),
      onPressed: () async {
        var tempFile = await _appImagePicker
            .openGallery()
            .whenComplete(() => Navigator.pop(context));
        setState(() {
          _avatarImage = tempFile;
        });
      },
    );

    alert = AlertDialog(
      title: Text("Update Profile Picture"),
      content: Text("Please Choose Image Source"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    super.initState();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + myFocusNode.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    _firstNameController = TextEditingController(text: _fName);
    _lastNameController = TextEditingController(text: _lName);
    _emailController = TextEditingController(text: _email);

    _firstNameController
      ..selection =
          TextSelection.collapsed(offset: _firstNameController.text.length);
    _lastNameController
      ..selection =
          TextSelection.collapsed(offset: _lastNameController.text.length);
    _emailController
      ..selection =
          TextSelection.collapsed(offset: _emailController.text.length);
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Personal Information"),
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: _avatarImage == null
                                        ? FutureBuilder(
                                            future: _userController
                                                .getUserStudentData(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/loading_indicator.gif',
                                                  image: snapshot
                                                      .data["avatarUrl"],
                                                  fit: BoxFit.cover,
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
                                          )
                                        : Image.file(
                                            _avatarImage,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                      child: new CircleAvatar(
                                        backgroundColor: kBlue1,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'First Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Last Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Focus(
                                        onFocusChange: (value) {
                                          setState(() {
                                            _fName = _firstNameController.text;
                                          });
                                        },
                                        child: new TextFormField(
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          controller: _firstNameController,
                                          validator: (value) {
                                            if (value == null ||
                                                value == "" ||
                                                value.isEmpty) {
                                              return "Please enter your First Name";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Focus(
                                      onFocusChange: (value) {
                                        setState(() {
                                          _lName = _lastNameController.text;
                                        });
                                      },
                                      child: new TextFormField(
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: _lastNameController,
                                        validator: (value) {
                                          if (value == null ||
                                              value == "" ||
                                              value.isEmpty) {
                                            return "Please enter your Last Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ), //put here

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Focus(
                                        onFocusChange: (value) {
                                          setState(() {
                                            _email = _emailController.text;
                                          });
                                        },
                                        child: new TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !value.contains("@") ||
                                                !value.contains(".com")) {
                                              return "Please enter a valid Email";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: _emailController,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Age',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new DropdownButtonFormField(
                                      hint: Text("${userMap['ageRange']}"),
                                      items: _dropdownItems.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: kTextFieldStyleDark,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value == "10 - 12") {
                                          setState(() {
                                            ageRange = "10 - 12";
                                          });
                                        } else if (value == "13 - 15") {
                                          setState(() {
                                            ageRange = "13 - 15";
                                          });
                                        } else if (value == "16 - 17") {
                                          setState(() {
                                            ageRange = "16 - 17";
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 100.0, horizontal: 16.0),
                    child: Center(
                      child: Container(
                        height: DeviceSizeConfig.deviceWidth * 0.17,
                        width: DeviceSizeConfig.deviceWidth * 1.0,
                        child: AppButtons(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _newUserDetails = {
                                "firstName": _firstNameController.text,
                                "lastName": _lastNameController.text,
                                "email": _emailController.text,
                                "ageRange": ageRange,
                              };

                              print('new data ' + _newUserDetails.toString());

                              await _studentHomeController
                                  .sendStudentDataToUpdate(
                                    _avatarImage,
                                    _newUserDetails,
                                  )
                                  .then((value) => Navigator.pop(context))
                                  .onError((error, stackTrace) {
                                return CoolAlert.show(
                                  type: CoolAlertType.error,
                                  text:
                                      "An Error Has Occured. Please Try Again Later",
                                  context: context,
                                );
                              }).whenComplete(() async {
                                await _userController
                                    .getUserStudentData()
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      userMap = value;
                                    });
                                  }
                                });
                              });
                            }
                          },
                          buttonText: Text(
                            'Save',
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

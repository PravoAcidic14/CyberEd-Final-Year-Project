import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/advisor_controller.dart';
import 'package:fyp_app_design/view/components/buttons.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';

class AdvisorProfileView extends StatefulWidget {
  @override
  AdvisorProfileViewState createState() => AdvisorProfileViewState();
}

class AdvisorProfileViewState extends State<AdvisorProfileView>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  AdvisorController _advisorController = AdvisorController();
  AppImagePicker _appImagePicker = AppImagePicker();
  Map userData = {};
  String matricsId;
  File _avatarImage;
  AlertDialog alert;
  TextEditingController _firstNameController,
      _lastNameController,
      _emailController,
      _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    myFocusNode.addListener(_onFocusChange);

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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + myFocusNode.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    matricsId = ModalRoute.of(context).settings.arguments;
    if (matricsId != null) {
      if (userData['fName'] == null) {
        _advisorController.getAdvisorData(matricsId).then((value) {
          setState(() {
            userData = value;
          });
        });
      }
    }

    _firstNameController = TextEditingController(text: userData['fName']);
    _lastNameController = TextEditingController(text: userData['lName']);
    _emailController = TextEditingController(text: userData['email']);
    _passwordController = TextEditingController(text: userData['password']);
    _firstNameController
      ..selection =
          TextSelection.collapsed(offset: _firstNameController.text.length);
    _lastNameController
      ..selection =
          TextSelection.collapsed(offset: _lastNameController.text.length);
    _emailController
      ..selection =
          TextSelection.collapsed(offset: _emailController.text.length);
    _passwordController
      ..selection =
          TextSelection.collapsed(offset: _passwordController.text.length);
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
                                            future: _advisorController
                                                .getAdvisorData(matricsId),
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
                                            userData['fName'] =
                                                _firstNameController.text;
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
                                          userData['lName'] =
                                              _lastNameController.text;
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
                                            userData['email'] =
                                                _emailController.text;
                                          });
                                        },
                                        child: new TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !value.contains("@")) {
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
                                          'Password',
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
                                            userData['password'] =
                                                _passwordController.text;
                                          });
                                        },
                                        child: new TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          validator: (value) {
                                            if (validateStructure(value) !=
                                                    true ||
                                                value.isEmpty) {
                                              return "Password should at least contain \nminimum 1 uppercase, \n1 lowercase, \n1 number \nand 1 special character";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: _passwordController,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
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

                              await _advisorController
                                  .sendAdvisorDataToUpdate(
                                      _avatarImage, userData, matricsId)
                                  .then((value) {
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                return CoolAlert.show(
                                  type: CoolAlertType.error,
                                  text:
                                      "An Error Has Occured. Please Try Again Later",
                                  context: context,
                                );
                              }).whenComplete(() async {
                                await _advisorController
                                    .getAdvisorData(matricsId)
                                    .then((value) {
                                  if (mounted) {
                                    setState(() {
                                      userData = value;
                                    });
                                  }
                                });
                              });

                              // await _studentHomeController
                              //     .sendStudentDataToUpdate(
                              //       _avatarImage,
                              //       _newUserDetails,
                              //     )
                              //     .then((value) => Navigator.pop(context))
                              //     .onError((error, stackTrace) {
                              //   return CoolAlert.show(
                              //     type: CoolAlertType.error,
                              //     text:
                              //         "An Error Has Occured. Please Try Again Later",
                              //     context: context,
                              //   );
                              // }).whenComplete(() async {
                              //   await _userController
                              //       .getUserStudentData()
                              //       .then((value) {
                              //     if (mounted) {
                              //       setState(() {
                              //         userMap = value;
                              //       });
                              //     }
                              //   });
                              // });
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

  // ignore: unused_element
  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  // ignore: deprecated_member_use
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  // ignore: deprecated_member_use
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  // ignore: unused_element
  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}

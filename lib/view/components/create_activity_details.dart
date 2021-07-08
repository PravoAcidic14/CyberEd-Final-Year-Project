import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import 'package:fyp_app_design/view/components/file_picker.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';
import '../../constants.dart';
import 'text_field.dart';
import 'package:path/path.dart';

class CreateActivityDetails extends StatefulWidget {
  CreateActivityDetails(
      {Key key, this.createdActivityDetails, this.currentActivity})
      : super(key: key);

  final Map createdActivityDetails;
  final int currentActivity;

  @override
  _CreateActivityDetailsState createState() => _CreateActivityDetailsState();
}

class _CreateActivityDetailsState extends State<CreateActivityDetails> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController activityTitleCon,
      activityPointsCon,
      videoUrlCon,
      slideUrlCon,
      posterUrlCon;

  String activityType;
  String answerValue = '';
  String gameType = 'Draggable Game';
  AppFilePicker _appFilePicker = AppFilePicker();
  Map activityDetails = {}, dragAndDropGameData = {}, guessGameData = {};
  var tempFile;
  File pdfFile;
  bool isGame = false;
  String setAmountString = '1 Set';
  int setAmount = 1;
  String imageConText = 'Choose an Image';
  AppImagePicker _appImagePicker = AppImagePicker();
  File avatarImage;

  @override
  void initState() {
    print('this is the map in argument');
    print(widget.createdActivityDetails);

    activityTitleCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                    'activity${widget.currentActivity}']['activityTitle']
                : ''
            : '');

    activityPointsCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                    'activity${widget.currentActivity}']['activityPoints']
                : ''
            : '');

    videoUrlCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                    'activity${widget.currentActivity}']['videoUrl']
                : ''
            : '');

    slideUrlCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                    'activity${widget.currentActivity}']['slidesPath']
                : ''
            : '');

    posterUrlCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                    'activity${widget.currentActivity}']['posterPath']
                : ''
            : '');

    activityType = widget.createdActivityDetails.isNotEmpty
        ? widget.createdActivityDetails
                .containsKey('activity${widget.currentActivity}')
            ? widget.createdActivityDetails['activity${widget.currentActivity}']
                ['activityType']
            : 'Video'
        : 'Video';

    // print('This is the length' +
    //     widget
    //         .createdActivityDetails['activity${widget.currentActivity}']
    //             ['gameContent']
    //         .length);
    if (activityType == 'Game') {
      isGame = true;

      setAmount = widget.createdActivityDetails.isNotEmpty
          ? widget.createdActivityDetails
                  .containsKey('activity${widget.currentActivity}')
              ? widget
                  .createdActivityDetails['activity${widget.currentActivity}']
                      ['gameContent']
                  .length
              : 1
          : 1;

      gameType = widget.createdActivityDetails.isNotEmpty
          ? widget.createdActivityDetails
                  .containsKey('activity${widget.currentActivity}')
              ? widget.createdActivityDetails[
                  'activity${widget.currentActivity}']['gameType']
              : 'Draggable Game'
          : 'Draggable Game';

      var appendSetString = setAmount == 1 ? 'Set' : 'Sets';

      setAmountString = '$setAmount ' + appendSetString;
    }

    super.initState();
  }

  GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _guessGameFormKey = GlobalKey<FormState>();

  TextEditingController set1Con =
      TextEditingController(text: 'Create Set 1 Data');
  TextEditingController set2Con =
      TextEditingController(text: 'Create Set 2 Data');
  TextEditingController set3Con =
      TextEditingController(text: 'Create Set 3 Data');
  TextEditingController set4Con =
      TextEditingController(text: 'Create Set 4 Data');
  TextEditingController set5Con =
      TextEditingController(text: 'Create Set 5 Data');
  TextEditingController set6Con =
      TextEditingController(text: 'Create Set 6 Data');
  TextEditingController set7Con =
      TextEditingController(text: 'Create Set 7 Data');
  TextEditingController set8Con =
      TextEditingController(text: 'Create Set 8 Data');
  TextEditingController set9Con =
      TextEditingController(text: 'Create Set 9 Data');
  TextEditingController set10Con =
      TextEditingController(text: 'Create Set 10 Data');

  Future<void> showGuessingWordAlertDialog(
      BuildContext context, int setNum) async {
    TextEditingController _answerWordCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['answer']
                : ''
            : '');

    TextEditingController _hintCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['hint']
                : ''
            : '');

    TextEditingController _imageCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? 'Image Chosen'
                : 'Choose an Image'
            : 'Choose an Image');

    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Create Set $setNum Data',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              content: Form(
                  key: _guessGameFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextField(
                          textEditingController: _answerWordCon,
                          labelText: 'Answer Word',
                          maxLength: 12,
                          fillColor: kLightTextFieldColor,
                          labelStyle: kHintStyleDark,
                          textFieldStyle: kTextFieldStyleDark,
                          textCapitalization: TextCapitalization.sentences,
                          textInputType: TextInputType.text,
                          onTap: () {},
                        ),
                        AppTextField(
                          textEditingController: _hintCon,
                          labelText: 'Hint Text',
                          fillColor: kLightTextFieldColor,
                          labelStyle: kHintStyleDark,
                          textFieldStyle: kTextFieldStyleDark,
                          textCapitalization: TextCapitalization.sentences,
                          textInputType: TextInputType.text,
                          onTap: () {},
                        ),
                        AppTextField(
                          textEditingController: _imageCon,
                          labelText: 'Hint Image',
                          fillColor: kLightTextFieldColor,
                          labelStyle: kHintStyleDark,
                          textFieldStyle: kTextFieldStyleDark,
                          isUploadPic: true,
                          onTap: () async {
                            var tempFile = await _appImagePicker.openGallery();
                            setState(() {
                              avatarImage = tempFile;
                              _imageCon.text = "Image Chosen";
                            });
                          },
                          onIconButtonTap: () async {
                            var tempFile = await _appImagePicker.openGallery();
                            setState(() {
                              avatarImage = tempFile;
                              _imageCon.text = "Image Chosen";
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_guessGameFormKey.currentState.validate()) {
                      print(setNum);
                      if (_imageCon.text == "Choose an Image") {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: 'Please choose an image first.');
                      } else {
                        var tempGameSet = {};
                        tempGameSet['answer'] = _answerWordCon.text;
                        tempGameSet['hint'] = _hintCon.text;
                        tempGameSet['imagePath'] = avatarImage.path;
                        guessGameData['set$setNum'] = tempGameSet;
                        setState(() {
                          _getController(setNum).text =
                              'Created  ${Emojis.checkBoxWithCheck}';
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('SAVE'),
                ),
              ],
            );
          });
        });
  }

  Future<void> showDraggableAlertDialog(
      BuildContext context, int setNum) async {
    TextEditingController questionCon = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['question']
                : ''
            : '');
    TextEditingController option1Con = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['options'][0]
                : ''
            : '');
    TextEditingController option2Con = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['options'][1]
                : ''
            : '');
    TextEditingController option3Con = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['options'][2]
                : ''
            : '');
    TextEditingController option4Con = TextEditingController(
        text: widget.createdActivityDetails.isNotEmpty
            ? widget.createdActivityDetails
                    .containsKey('activity${widget.currentActivity}')
                ? widget.createdActivityDetails[
                        'activity${widget.currentActivity}']['gameContent']
                    ['set$setNum']['options'][3]
                : ''
            : '');

    answerValue = widget.createdActivityDetails.isNotEmpty
        ? widget.createdActivityDetails
                .containsKey('activity${widget.currentActivity}')
            ? widget.createdActivityDetails['activity${widget.currentActivity}']
                ['gameContent']['set$setNum']['answer']
            : ''
        : '';

    return await showDialog(
        context: context,
        builder: (context) {
          List<String> options = [
            option1Con.text == '' ? 'Option 1' : option1Con.text,
            option2Con.text == '' ? 'Option 2' : option2Con.text,
            option3Con.text == '' ? 'Option 3' : option3Con.text,
            option4Con.text == '' ? 'Option 4' : option4Con.text
          ];

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Create Set $setNum Data',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              content: Form(
                key: _dialogFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        textEditingController: questionCon,
                        labelText: 'Question',
                        fillColor: kLightTextFieldColor,
                        labelStyle: kHintStyleDark,
                        textFieldStyle: kTextFieldStyleDark,
                        textCapitalization: TextCapitalization.sentences,
                        textInputType: TextInputType.text,
                        helperText:
                            'Please input \'/target/\' to represent the answer field in the question.',
                        onTap: () {},
                      ),
                      for (var i = 0; i < 4; i++)
                        AppTextField(
                          textEditingController: i == 0
                              ? option1Con
                              : i == 1
                                  ? option2Con
                                  : i == 2
                                      ? option3Con
                                      : option4Con,
                          labelText: 'Option ${i + 1}',
                          fillColor: kLightTextFieldColor,
                          labelStyle: kHintStyleDark,
                          textFieldStyle: kTextFieldStyleDark,
                          textCapitalization: TextCapitalization.sentences,
                          textInputType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              if (answerValue.isNotEmpty) {
                                if (options[i] == answerValue) {
                                  answerValue = value;
                                  options[i] = value;
                                } else {
                                  options[i] = value;
                                }
                              } else {
                                options[i] = value;
                              }
                            });
                          },
                          onTap: () {},
                        ),
                      AppDropdownFormField(
                        fillColor: kLightTextFieldColor,
                        value: answerValue.isEmpty ? options[0] : answerValue,
                        options: options,
                        onChanged: (value) {
                          setState(() {
                            answerValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_dialogFormKey.currentState.validate()) {
                      print(setNum);
                      if (questionCon.text.contains('/target/')) {
                        if (answerValue.isNotEmpty) {
                          var tempGameSet = {};
                          tempGameSet['question'] = questionCon.text;
                          tempGameSet['options'] = options;
                          tempGameSet['answer'] = answerValue;
                          dragAndDropGameData['set$setNum'] = tempGameSet;
                          setState(() {
                            _getController(setNum).text =
                                'Created  ${Emojis.checkBoxWithCheck}';
                          });
                          Navigator.pop(context);
                        } else {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'Please choose an answer.');
                        }
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text:
                                'Please input \'/target/\' to represent the answer field in the question.');
                      }
                    }
                  },
                  child: Text('SAVE'),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: DeviceSizeConfig.deviceWidth * 0.6,
                              child: Text(
                                'Enter New Details',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: DeviceSizeConfig.deviceWidth * 0.06,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                      Form(
                        key: _key,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: DeviceSizeConfig.deviceHeight * 0.03,
                            ),
                            AppTextField(
                              textEditingController: activityTitleCon,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Activity Title',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: activityPointsCon,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Activity Points',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.number,
                              isActivityPoints: true,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppDropdownFormField(
                                labelText: 'Choose Activity Type',
                                fillColor: kLightTextFieldColor,
                                value: activityType,
                                options: ['Video', 'Slides', 'Poster', 'Game'],
                                onChanged: (value) {
                                  if (value == 'Video') {
                                    setState(() {
                                      activityType = "Video";
                                    });
                                  } else if (value == 'Slides') {
                                    setState(() {
                                      activityType = "Slides";
                                    });
                                  } else if (value == 'Poster') {
                                    setState(() {
                                      activityType = "Poster";
                                    });
                                  } else if (value == 'Game') {
                                    setState(() {
                                      activityType = "Game";
                                      isGame = true;
                                    });
                                  }
                                }),
                            activityType == 'Video' ||
                                    activityType == 'Slides' ||
                                    activityType == 'Poster'
                                ? AppTextField(
                                    textEditingController:
                                        activityType == 'Video'
                                            ? videoUrlCon
                                            : activityType == 'Slides'
                                                ? slideUrlCon
                                                : activityType == 'Poster'
                                                    ? posterUrlCon
                                                    : posterUrlCon,
                                    textFieldStyle: kTextFieldStyleDark,
                                    labelText: activityType == 'Video'
                                        ? 'YouTube Video URL'
                                        : activityType == 'Slides'
                                            ? 'Slides PDF File'
                                            : activityType == 'Poster'
                                                ? 'Poster PDF File'
                                                : 'Game Content',
                                    labelStyle: kHintStyleDark,
                                    fillColor: kLightTextFieldColor,
                                    textInputType: TextInputType.text,
                                    isUploadPic: activityType == 'Slides' ||
                                            activityType == 'Poster'
                                        ? true
                                        : false,
                                    readOnly: activityType == 'Slides' ||
                                            activityType == 'Poster' ||
                                            activityType == 'Game'
                                        ? true
                                        : false,
                                    isPasswordHidden: false,
                                    typePassword: false,
                                    onTap: () async {
                                      if (activityType == 'Slides' ||
                                          activityType == 'Poster') {
                                        File tempPDFFile =
                                            await _appFilePicker.pickPDFFile();
                                        if (tempPDFFile != null) {
                                          print(tempPDFFile);
                                          setState(() {
                                            pdfFile = tempPDFFile;
                                            if (activityType == 'Slides') {
                                              slideUrlCon.text =
                                                  basename(tempPDFFile.path);
                                            } else if (activityType ==
                                                'Poster') {
                                              posterUrlCon.text =
                                                  basename(tempPDFFile.path);
                                            }
                                          });
                                        }
                                      }
                                    },
                                  )
                                : AppDropdownFormField(
                                    fillColor: kLightTextFieldColor,
                                    labelText: 'Choose Game Type',
                                    value: gameType,
                                    options: [
                                      'Draggable Game',
                                      'Guess The Word Game'
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        gameType = value;
                                      });
                                    },
                                  ),
                            isGame == true
                                ? AppDropdownFormField(
                                    fillColor: kLightTextFieldColor,
                                    value: setAmountString,
                                    labelText: 'Choose Set Amount',
                                    options: [
                                      '1 Set',
                                      '2 Sets',
                                      '3 Sets',
                                      '4 Sets',
                                      '5 Sets',
                                      '6 Sets',
                                      '7 Sets',
                                      '8 Sets',
                                      '9 Sets',
                                      '10 Sets'
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        setAmountString = value;
                                        setAmount = int.parse('${value[0]}');
                                      });
                                    },
                                  )
                                : Container(),
                            if (isGame == true)
                              for (var i = 1; i <= setAmount; i++)
                                AppTextField(
                                  textEditingController: _getController(i),
                                  readOnly: true,
                                  labelText: 'Create Set $i',
                                  fillColor: kLightTextFieldColor,
                                  labelStyle: kHintStyleDark,
                                  textFieldStyle: kTextFieldStyleDark,
                                  onTap: () {
                                    if (gameType == "Draggable Game") {
                                      showDraggableAlertDialog(context, i);
                                    } else if (gameType ==
                                        "Guess The Word Game") {
                                          showGuessingWordAlertDialog(context, i);
                                        }
                                  },
                                )
                            else
                              Container(),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_key.currentState.validate()) {
                                      // print(moduleTitleCon.text);
                                      activityDetails['activityTitle'] =
                                          activityTitleCon.text;
                                      activityDetails['activityPoints'] =
                                          activityPointsCon.text;
                                      activityDetails['activityType'] =
                                          activityType;
                                      if (activityType == 'Video') {
                                        activityDetails['videoUrl'] =
                                            videoUrlCon.text;
                                      } else if (activityType == 'Slides') {
                                        activityDetails['slidesPath'] =
                                            pdfFile.path;
                                      } else if (activityType == 'Poster') {
                                        activityDetails['posterPath'] =
                                            pdfFile.path;
                                      } else if (activityType == 'Game') {
                                        activityDetails['gameType'] = gameType;
                                        if (gameType == "Draggable Game") {
                                          activityDetails['gameContent'] =
                                              dragAndDropGameData;
                                        } else {
                                          activityDetails['gameContent'] =
                                              guessGameData;
                                        }
                                      }
                                      if (isGame == true) {
                                        if (gameType == "Draggable Game") {
                                          if (dragAndDropGameData.length ==
                                              setAmount) {
                                            Navigator.pop(
                                                context, activityDetails);
                                          } else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text:
                                                    'Please create all the Game Sets first.');
                                          }
                                        } else  {
                                          if (guessGameData.length ==
                                            setAmount) {
                                          Navigator.pop(
                                              context, activityDetails);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text:
                                                  'Please create all the Game Sets first.');
                                        }
                                        }
                                      } else {
                                        Navigator.pop(context, activityDetails);
                                      }

                                      print(guessGameData);

                                    }
                                  },
                                  child: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.9,
                                    height: DeviceSizeConfig.deviceHeight * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: kGreenColor,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 4),
                                          blurRadius: 5.0,
                                          color: Colors.black45,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              DeviceSizeConfig.deviceWidth *
                                                  0.06,
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  // ignore: missing_return
  TextEditingController _getController(int i) {
    if (i == 1) {
      return set1Con;
    } else if (i == 2) {
      return set2Con;
    } else if (i == 3) {
      return set3Con;
    } else if (i == 4) {
      return set4Con;
    } else if (i == 5) {
      return set5Con;
    } else if (i == 6) {
      return set6Con;
    } else if (i == 7) {
      return set7Con;
    } else if (i == 8) {
      return set8Con;
    } else if (i == 9) {
      return set9Con;
    } else if (i == 10) {
      return set10Con;
    }
  }
}

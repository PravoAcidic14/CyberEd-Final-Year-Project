import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import 'package:fyp_app_design/controller/game_controller.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';
import 'package:fyp_app_design/view/nf-screens/web_view_screen.dart';
import '../../constants.dart';
import 'text_field.dart';

class UpdateGameSet extends StatefulWidget {
  UpdateGameSet({Key key, this.gameDetails, this.gameType}) : super(key: key);

  final Map gameDetails;
  final String gameType;

  @override
  _UpdateGameSetState createState() => _UpdateGameSetState();
}

class _UpdateGameSetState extends State<UpdateGameSet> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  GameController _gameController = GameController();
  TextEditingController questionCon,
      optionCon1,
      optionCon2,
      optionCon3,
      optionCon4,
      answerCon,
      guessAnswerCon,
      answerHintCon,
      imageHintCon;

  Map newGameContentDetails = {};
  String answerText;
  AppImagePicker _appImagePicker = AppImagePicker();
  File avatarImage;
  var value;

  @override
  void initState() {
    if (widget.gameType == 'draggable') {
      questionCon = TextEditingController(text: widget.gameDetails['question']);
      optionCon1 =
          TextEditingController(text: widget.gameDetails['options'][0]);
      optionCon2 =
          TextEditingController(text: widget.gameDetails['options'][1]);
      optionCon3 =
          TextEditingController(text: widget.gameDetails['options'][2]);
      optionCon4 =
          TextEditingController(text: widget.gameDetails['options'][3]);
      answerCon = TextEditingController(text: widget.gameDetails['answer']);

      if (optionCon1.text == answerCon.text) {
        value = 1;
      } else if (optionCon2.text == answerCon.text) {
        value = 2;
      } else if (optionCon3.text == answerCon.text) {
        value = 3;
      } else if (optionCon4.text == answerCon.text) {
        value = 4;
      }
    } else if (widget.gameType == 'guess') {
      guessAnswerCon =
          TextEditingController(text: widget.gameDetails['answer']);
      answerHintCon = TextEditingController(text: widget.gameDetails['hint']);
      imageHintCon = TextEditingController(text: 'View Image');
    }

    super.initState();
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
                          child: widget.gameType == 'draggable'
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height:
                                          DeviceSizeConfig.deviceHeight * 0.03,
                                    ),
                                    AppTextField(
                                      textEditingController: questionCon,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Question',
                                      labelStyle: kHintStyleDark,
                                      helperText:
                                          'Please input \'/target/\' to represent the answer field in the question.',
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                      textEditingController: optionCon1,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Answer Option 1',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                      textEditingController: optionCon2,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Answer Option 2',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                      textEditingController: optionCon3,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Answer Option 3',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                      textEditingController: optionCon4,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Answer Option 4',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppDropdownFormField(
                                      value: value == 1
                                          ? optionCon1.text
                                          : value == 2
                                              ? optionCon2.text
                                              : value == 3
                                                  ? optionCon3.text
                                                  : optionCon4.text,
                                      labelText: "Answer",
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      options: [
                                        optionCon1.text,
                                        optionCon2.text,
                                        optionCon3.text,
                                        optionCon4.text
                                      ],
                                      onChanged: (value) {
                                        if (value == optionCon1.text) {
                                          setState(() {
                                            answerText = optionCon1.text;
                                          });
                                        } else if (value == optionCon2.text) {
                                          setState(() {
                                            answerText = optionCon2.text;
                                          });
                                        } else if (value == optionCon3.text) {
                                          setState(() {
                                            answerText = optionCon3.text;
                                          });
                                        } else if (value == optionCon4.text) {
                                          setState(() {
                                            answerText = optionCon4.text;
                                          });
                                        }
                                      },
                                    ),
                                    Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_key.currentState.validate()) {
                                              CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.loading,
                                                  title: 'Loading...');
                                              newGameContentDetails['gameId'] =
                                                  widget.gameDetails['gameId'];
                                              newGameContentDetails[
                                                      'question'] =
                                                  questionCon.text;
                                              newGameContentDetails['answer'] =
                                                  answerText;
                                              newGameContentDetails['setNum'] =
                                                  widget.gameDetails['setNum'];
                                              newGameContentDetails['options'] =
                                                  [
                                                optionCon1.text,
                                                optionCon2.text,
                                                optionCon3.text,
                                                optionCon4.text
                                              ];
                                              await _gameController
                                                  .updateDraggableGameContent(
                                                      newGameContentDetails)
                                                  .then((value) {
                                                Navigator.pop(context);
                                                return CoolAlert.show(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    type: CoolAlertType.success,
                                                    title: 'Success',
                                                    text: value,
                                                    onConfirmBtnTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    });
                                              }).catchError((onError) {
                                                Navigator.pop(context);
                                                return CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.error,
                                                  title: 'Oops...',
                                                  text: onError.toString(),
                                                );
                                              });
                                            }
                                          },
                                          child: Container(
                                            width:
                                                DeviceSizeConfig.deviceWidth *
                                                    0.9,
                                            height:
                                                DeviceSizeConfig.deviceHeight *
                                                    0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
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
                                                'UPDATE',
                                                style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: DeviceSizeConfig
                                                          .deviceWidth *
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
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height:
                                          DeviceSizeConfig.deviceHeight * 0.03,
                                    ),
                                    AppTextField(
                                      textEditingController: guessAnswerCon,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Answer Word',
                                      labelStyle: kHintStyleDark,
                                      maxLength: 12,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                      textEditingController: answerHintCon,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: 'Hint',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      textInputType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () {},
                                    ),
                                    AppTextField(
                                        textEditingController: imageHintCon,
                                        textFieldStyle: kTextFieldStyleDark,
                                        labelText: 'Image Hint',
                                        labelStyle: kHintStyleDark,
                                        fillColor: kLightTextFieldColor,
                                        isUploadPic: true,
                                        isPasswordHidden: false,
                                        typePassword: false,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewContainer(
                                                          widget.gameDetails[
                                                              'imageUrl'])));
                                        },
                                        onIconButtonTap: () async {
                                          var tempFile = await _appImagePicker
                                              .openGallery();
                                          setModalState(() {
                                            avatarImage = tempFile;
                                            imageHintCon.text =
                                                "Thumbnail Chosen";
                                          });
                                        }),
                                        Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_key.currentState.validate()) {
                                              CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.loading,
                                                  title: 'Loading...');
                                              newGameContentDetails['gameId'] =
                                                  widget.gameDetails['gameId'];
                                              newGameContentDetails[
                                                      'answer'] =
                                                  guessAnswerCon.text;
                                              newGameContentDetails['hint'] =
                                                  answerHintCon.text;
                                              newGameContentDetails['setNum'] =
                                                  widget.gameDetails['setNum'];
                                              await _gameController
                                                  .updateGuessGameContent(
                                                      newGameContentDetails, avatarImage)
                                                  .then((value) {
                                                Navigator.pop(context);
                                                return CoolAlert.show(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    type: CoolAlertType.success,
                                                    title: 'Success',
                                                    text: value,
                                                    onConfirmBtnTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    });
                                              }).catchError((onError) {
                                                Navigator.pop(context);
                                                return CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.error,
                                                  title: 'Oops...',
                                                  text: onError.toString(),
                                                );
                                              });
                                            }
                                          },
                                          child: Container(
                                            width:
                                                DeviceSizeConfig.deviceWidth *
                                                    0.9,
                                            height:
                                                DeviceSizeConfig.deviceHeight *
                                                    0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
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
                                                'UPDATE',
                                                style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: DeviceSizeConfig
                                                          .deviceWidth *
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
                                ))
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}

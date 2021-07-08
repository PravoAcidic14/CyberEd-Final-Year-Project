import 'dart:io';
import 'package:fyp_app_design/controller/activity_controller.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:path/path.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/components/text_field.dart';
import 'package:fyp_app_design/view/components/file_picker.dart';
import '../../constants.dart';
import '../nf-screens/pdf_view_screen.dart';
import '../update_game_content.dart';

class UpdateActivityDetails extends StatefulWidget {
  UpdateActivityDetails(
      {Key key, this.activityDetails, this.activityId, this.moduleDetails})
      : super(key: key);

  final Map activityDetails;
  final int activityId;
  final Map moduleDetails;

  @override
  _UpdateActivityDetailsState createState() => _UpdateActivityDetailsState();
}

class _UpdateActivityDetailsState extends State<UpdateActivityDetails> {
  AppFilePicker _appFilePicker = AppFilePicker();
  ActivityController activityController = ActivityController();
  StorageController _storageController = StorageController();
  TextEditingController activityTitleCon,
      activityPointsCon,
      videoUrlCon,
      uploadSlidesCon,
      uploadPostersCon,
      gameContentCon;
  final String chooseSlidesInitText = 'Choose a Slides PDF';
  final String choosePosterInitText = 'Choose a Poster PDF';
  final GlobalKey<FormState> _formKey = GlobalKey();
  File pdfFile, oldPdfFile;
  Map newActivityDetails = {};

  @override
  void initState() {
    //for title and points
    activityTitleCon =
        TextEditingController(text: widget.activityDetails['activityTitle']);
    activityPointsCon = TextEditingController(
        text: widget.activityDetails['activityPoints'].toString());

    // for video
    if (widget.activityDetails['activityType'] == 'video') {
      videoUrlCon =
          TextEditingController(text: widget.activityDetails['videoUrl']);
    }

    // for slides
    if (widget.activityDetails['activityType'] == 'slides') {
      print('its a slide');
      uploadSlidesCon = TextEditingController(
          text: widget.activityDetails['slidesName'] + '.pdf');
    }

    // for posters
    if (widget.activityDetails['activityType'] == 'poster') {
      print('its a poster');
      uploadPostersCon = TextEditingController(
          text: widget.activityDetails['posterName'] + '.pdf');
    }

    //for game
    if (widget.activityDetails['activityType'] == 'game') {
      print('its a game');
      gameContentCon =
          TextEditingController(text: 'Click to Edit Game Content');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
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
                                setState(() {
                                  if (widget.activityDetails['activityType'] ==
                                      'slides') {
                                    uploadSlidesCon.text = chooseSlidesInitText;
                                  } else if (widget
                                          .activityDetails['activityType'] ==
                                      'poster') {
                                    uploadPostersCon.text =
                                        choosePosterInitText;
                                  }
                                });
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
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
                            labelText: 'Activity Points (XP)',
                            labelStyle: kHintStyleDark,
                            fillColor: kLightTextFieldColor,
                            textInputType: TextInputType.number,
                            isActivityPoints: true,
                            isPasswordHidden: false,
                            typePassword: false,
                            onTap: () {},
                          ),
                          widget.activityDetails['activityType'] == 'video'
                              ? AppTextField(
                                  textEditingController: videoUrlCon,
                                  textFieldStyle: kTextFieldStyleDark,
                                  labelText: 'Youtube Video URL',
                                  labelStyle: kHintStyleDark,
                                  fillColor: kLightTextFieldColor,
                                  isUploadPic: false,
                                  isPasswordHidden: false,
                                  typePassword: false,
                                  onTap: () {})
                              : widget.activityDetails['activityType'] ==
                                          'slides' ||
                                      widget.activityDetails['activityType'] ==
                                          'poster'
                                  ? AppTextField(
                                      textEditingController:
                                          widget.activityDetails[
                                                      'activityType'] ==
                                                  'slides'
                                              ? uploadSlidesCon
                                              : uploadPostersCon,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelText: widget.activityDetails[
                                                  'activityType'] ==
                                              'slides'
                                          ? 'Slides PDF'
                                          : 'Poster PDF',
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      isUploadPic: true,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      onTap: () async {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.loading,
                                            title: 'Loading...');

                                        widget.activityDetails[
                                                    'activityType'] ==
                                                'slides'
                                            ? openSlideOldPdf(context)
                                            : openPosterOldPdf(context);
                                      },
                                      onIconButtonTap: () async {
                                        File tempFile =
                                            await _appFilePicker.pickPDFFile();
                                        if (tempFile != null) {
                                          setState(() {
                                            pdfFile = tempFile;
                                            if (widget.activityDetails[
                                                    'activityType'] ==
                                                'slides') {
                                              uploadSlidesCon.text =
                                                  basename(tempFile.path);
                                            } else if (widget.activityDetails[
                                                    'activityType'] ==
                                                'poster') {
                                              uploadPostersCon.text =
                                                  basename(tempFile.path);
                                            }
                                          });
                                        }
                                      })
                                  : AppTextField(
                                      textEditingController: gameContentCon,
                                      textFieldStyle: kTextFieldStyleDark,
                                      labelStyle: kHintStyleDark,
                                      fillColor: kLightTextFieldColor,
                                      labelText: 'Game Content',
                                      isUploadPic: false,
                                      isPasswordHidden: false,
                                      typePassword: false,
                                      readOnly: true,
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UpdateGameContent(
                                            activityDetails:
                                                widget.activityDetails,
                                                
                                          );
                                        }));
                                      },
                                    ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState.validate()) {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.loading,
                                        title: 'Loading...');
                                    newActivityDetails['moduleId'] =
                                        widget.moduleDetails['moduleId'];
                                    newActivityDetails['activityId'] =
                                        widget.activityId;
                                    newActivityDetails['level'] =
                                        widget.activityDetails['level'];
                                    newActivityDetails['activityTitle'] =
                                        activityTitleCon.text;
                                    newActivityDetails['activityPoints'] =
                                        activityPointsCon.text;
                                    newActivityDetails['activityType'] =
                                        widget.activityDetails['activityType'];
                                    if (widget
                                            .activityDetails['activityType'] ==
                                        'video') {
                                      newActivityDetails['videoUrl'] =
                                          videoUrlCon.text;
                                    } else if (widget
                                            .activityDetails['activityType'] ==
                                        'slides') {
                                      newActivityDetails['oldUrl'] =
                                          widget.activityDetails['slidesUrl'];
                                    } else if (widget
                                            .activityDetails['activityType'] ==
                                        'poster') {
                                      newActivityDetails['oldUrl'] =
                                          widget.activityDetails['posterUrl'];
                                    }

                                    await activityController
                                        .updateActivityDetails(
                                            newActivityDetails, pdfFile)
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
                                    // print(newActivityDetails);
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
                                      'UPDATE',
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            DeviceSizeConfig.deviceWidth * 0.06,
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future openSlideOldPdf(BuildContext context) async {
    oldPdfFile = await _storageController.loadFirebase(
        widget.activityDetails['moduleId'],
        'level${widget.activityDetails['level']}',
        widget.activityDetails['slidesName'] + '.pdf');
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PDFViewContainer(oldPdfFile)));
  }

  Future openPosterOldPdf(BuildContext context) async {
    oldPdfFile = await _storageController.loadFirebase(
        widget.activityDetails['moduleId'],
        'level${widget.activityDetails['level']}',
        widget.activityDetails['posterName'] + '.pdf');
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PDFViewContainer(oldPdfFile)));
  }
}

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/view/nf-screens/web_view_screen.dart';

import '../../constants.dart';
import 'image_picker.dart';
import 'text_field.dart';

class UpdateModuleDetails extends StatefulWidget {
  const UpdateModuleDetails({
    Key key,
    @required this.moduleDetails,
    @required AppImagePicker appImagePicker,
  })  : _appImagePicker = appImagePicker,
        super(key: key);

  final Map moduleDetails;
  final AppImagePicker _appImagePicker;

  @override
  _UpdateModuleDetailsState createState() => _UpdateModuleDetailsState();
}

class _UpdateModuleDetailsState extends State<UpdateModuleDetails> {
  File avatarImage;
  Map newModuleDetails = {};
  TextEditingController uploadPicController;
  TextEditingController moduleTitleCon, moduleDescCon;
  ModuleController moduleController = ModuleController();

  @override
  void initState() {
    uploadPicController = TextEditingController(text: "View Thumbnail");
    moduleTitleCon =
        TextEditingController(text: widget.moduleDetails['moduleTitle']);
    moduleDescCon =
        TextEditingController(text: widget.moduleDetails['moduleDescription']);
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
                                  avatarImage = null;
                                  uploadPicController.text =
                                      "Choose a Thumbnail";
                                });
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: DeviceSizeConfig.deviceHeight * 0.03,
                        ),
                        AppTextField(
                          textEditingController: moduleTitleCon,
                          textFieldStyle: kTextFieldStyleDark,
                          labelText: 'Module Title',
                          labelStyle: kHintStyleDark,
                          fillColor: kLightTextFieldColor,
                          textInputType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          isPasswordHidden: false,
                          typePassword: false,
                          onTap: () {},
                        ),
                        AppTextField(
                          textEditingController: moduleDescCon,
                          textFieldStyle: kTextFieldStyleDark,
                          labelText: 'Module Description',
                          labelStyle: kHintStyleDark,
                          fillColor: kLightTextFieldColor,
                          textInputType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          isPasswordHidden: false,
                          typePassword: false,
                          onTap: () {},
                        ),
                        AppTextField(
                            textEditingController: uploadPicController,
                            textFieldStyle: kTextFieldStyleDark,
                            labelText: 'Module Thumbnail',
                            labelStyle: kHintStyleDark,
                            fillColor: kLightTextFieldColor,
                            isUploadPic: true,
                            isPasswordHidden: false,
                            typePassword: false,
                            onTap: () {
                              print(widget.moduleDetails['thumbnailUrl']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewContainer(
                                          widget
                                              .moduleDetails['thumbnailUrl'])));
                            },
                            onIconButtonTap: () async {
                              var tempFile =
                                  await widget._appImagePicker.openGallery();
                              setModalState(() {
                                avatarImage = tempFile;
                                uploadPicController.text = "Thumbnail Chosen";
                              });
                            }),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              onTap: () async {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    title: 'Loading...');
                                newModuleDetails['moduleId'] =
                                    widget.moduleDetails['moduleId'];
                                newModuleDetails['moduleTitle'] =
                                    moduleTitleCon.text;
                                newModuleDetails['moduleDescription'] =
                                    moduleDescCon.text;
                                print(newModuleDetails);
                                await moduleController
                                    .updateModuleDetails(
                                        newModuleDetails, avatarImage)
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';
import 'package:fyp_app_design/view/components/update_module_details.dart';

class AdvisorUpdateModuleView extends StatefulWidget {
  @override
  _AdvisorUpdateModuleViewState createState() =>
      _AdvisorUpdateModuleViewState();
}

class _AdvisorUpdateModuleViewState extends State<AdvisorUpdateModuleView> {
  ModuleController _moduleController = ModuleController();
  AppImagePicker _appImagePicker = AppImagePicker();
  File avatarImage;
  String uploadFieldText = 'Choose a Thumbnail';
  String uploadFieldSuccessText = 'Thumbnail Selected';
  String initialText = 'Choose a Thumbnail';

  @override
  Widget build(BuildContext context) {
    Map moduleDetails = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: kBackgroundColorBright,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              width: DeviceSizeConfig.deviceWidth * 0.9,
              child: Text(
                'Update ${moduleDetails['moduleTitle']}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: DeviceSizeConfig.deviceWidth * 0.08,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: DeviceSizeConfig.deviceHeight * 0.05,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 4.0,
                  right: 4.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isDismissible: false,
                        backgroundColor: kBackgroundColorBright,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return UpdateModuleDetails(
                              moduleDetails: moduleDetails,
                              appImagePicker: _appImagePicker);
                        }).whenComplete(() {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: DeviceSizeConfig.deviceWidth,
                    height: DeviceSizeConfig.deviceHeight * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 4),
                          blurRadius: 5.0,
                          color: Colors.black45,
                        )
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        child: Text(
                          'Edit Module Details',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Divider(
                indent: 4.0,
                endIndent: 4.0,
                thickness: 2.0,
                color: kGrey3,
              ),
            ),
            for (var i = 1; i < 4; i++)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 4.0,
                    right: 4.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      moduleDetails['level'] = i;
                      Navigator.pushNamed(context, '/advisor-update-level',
                          arguments: moduleDetails);
                    },
                    child: Container(
                      width: DeviceSizeConfig.deviceWidth,
                      height: DeviceSizeConfig.deviceHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 4),
                            blurRadius: 5.0,
                            color: Colors.black45,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 12.0,
                                left: 16.0,
                              ),
                              child: Text(
                                'Edit Level $i',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 18.0),
                              child: Text(
                                '${moduleDetails['moduleLevel'][i - 1]} Activities',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.normal,
                                  fontSize: DeviceSizeConfig.deviceWidth * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(child: SizedBox()),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        text:
                            'Are you sure you want to delete ${moduleDetails['moduleTitle']} module?',
                        showCancelBtn: true,
                        cancelBtnText: 'No',
                        confirmBtnText: 'Yes',
                        onConfirmBtnTap: () async {
                          await _moduleController
                              .deleteModule(moduleDetails['moduleId'])
                              .whenComplete(() {
                            return CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                title: 'Deleted Succesfully',
                                onConfirmBtnTap: () =>
                                    Navigator.restorablePopAndPushNamed(
                                        context, '/advisor-home'));
                          });
                        },
                        onCancelBtnTap: () => Navigator.pop(context));
                  },
                  child: Container(
                    width: DeviceSizeConfig.deviceWidth * 0.9,
                    height: DeviceSizeConfig.deviceHeight * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.red[400],
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
                        'DELETE',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: DeviceSizeConfig.deviceWidth * 0.06,
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
    );
  }
}

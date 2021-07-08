import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/advisor_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvisorSettingsView extends StatefulWidget {
  @override
  _AdvisorSettingsViewState createState() => _AdvisorSettingsViewState();
}

class _AdvisorSettingsViewState extends State<AdvisorSettingsView> {
  SharedPreferences _sharedPreferences;
  AdvisorController _advisorController = AdvisorController();
  Map userData = {};

  Future initSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future getStudentScore(String studentId) async {}

  @override
  Widget build(BuildContext context) {
    String matricsId = ModalRoute.of(context).settings.arguments;
    initSharedPref().whenComplete(() {
      if (matricsId == null) {
        matricsId = _sharedPreferences.getString('advisorMatricsId');
        if (matricsId != null) {
          _advisorController.getAdvisorData(matricsId).then((value) {
            setState(() {
              userData = value;
            });
          });
        }
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text('Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.restorablePopAndPushNamed(context, '/advisor-home'),
          ),
        ),
        backgroundColor: kBackgroundColorBright,
        body: Column(
          children: [
            SizedBox(
              height: DeviceSizeConfig.deviceHeight * 0.05,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/advisor-profile',
                  arguments: matricsId),
              child: Center(
                child: Container(
                  width: DeviceSizeConfig.deviceWidth * 0.9,
                  height: DeviceSizeConfig.deviceHeight * 0.1,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(4.0, 2.0),
                          color: Colors.black45,
                          blurRadius: 5.0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: GestureDetector(
                onTap: () {
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.warning,
                      text: 'Are you sure you wish to log out?',
                      showCancelBtn: true,
                      onCancelBtnTap: () => Navigator.pop(context),
                      onConfirmBtnTap: () {
                        _sharedPreferences
                            .setBool('advisorLoggedIn', false)
                            .whenComplete(() {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/first-screen', (route) => false);
                        });
                      });
                },
                child: Center(
                  child: Container(
                    width: DeviceSizeConfig.deviceWidth * 0.9,
                    height: DeviceSizeConfig.deviceHeight * 0.1,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(4.0, 2.0),
                            color: Colors.black45,
                            blurRadius: 5.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/advisor_controller.dart';

import '../constants.dart';
import 'components/appbar.dart';
import 'components/shapes.dart';
import 'components/text_field.dart';

class AdvisorLoginView extends StatefulWidget {
  AdvisorLoginView({Key key}) : super(key: key);

  @override
  _AdvisorLoginViewState createState() => _AdvisorLoginViewState();
}

class _AdvisorLoginViewState extends State<AdvisorLoginView> {
  var _circleOffset = List.filled(6, -1000.0);
  final _formKey = GlobalKey<FormState>();
  final _matricsIDCon = TextEditingController();
  final _passwordCon = TextEditingController();
  // ignore: missing_required_param
  final appTextField = AppTextField();
  AdvisorController _advisorController = AdvisorController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _circleOffset[0] = -60.0;
        _circleOffset[1] = -5.0;
        _circleOffset[2] = -90.0;
        _circleOffset[3] = -30.0;
        _circleOffset[4] = -40.0;
        _circleOffset[5] = -90.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    final String title = 'Login As Advisor';

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: kPrimaryColor,
        appBar: CustomAppBar(
          height: 50.0,
          iconColor: Colors.white,
          route: '/',
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: -150.0,
              right: _circleOffset[0],
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.50,
                height: DeviceSizeConfig.deviceWidth * 0.50,
                angleValue: 12.0,
                bgColor: kGrey1,
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              top: _circleOffset[1],
              right: -80.0,
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                angleValue: 4.0,
                bgColor: kGrey2,
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: 200.0,
              right: _circleOffset[2],
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                angleValue: 0.5294,
                bgColor: kGrey1,
              ),
              duration: Duration(milliseconds: 1800),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: _circleOffset[3],
              right: -40.0,
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                angleValue: 12.0,
                bgColor: kGrey3,
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: _circleOffset[3],
              right: 25.0,
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.25,
                height: DeviceSizeConfig.deviceWidth * 0.25,
                angleValue: 0.5294,
                bgColor: kGrey2,
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: -40.0,
              left: _circleOffset[3],
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                angleValue: 12.0,
                bgColor: kGrey1,
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              top: 240.0,
              left: _circleOffset[5],
              child: AppSquare(
                width: DeviceSizeConfig.deviceWidth * 0.4,
                height: DeviceSizeConfig.deviceWidth * 0.4,
                angleValue: 18.0,
                bgColor: kGrey3,
              ),
              duration: Duration(milliseconds: 2300),
              curve: Curves.easeInOut,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 75.0, 16.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: titleStyleWhite(fontsize: 35),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Container(
                        //height: DeviceSizeConfig.deviceHeight * 0.4,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppTextField(
                                textFieldStyle: kTextFieldStyleDark,
                                textEditingController: _matricsIDCon,
                                labelText: 'Matrics ID',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.text,
                                typePassword: false,
                                typeConfirmPassword: false,
                                isPasswordHidden: false,
                                maxLength: 7,
                                errorMessage: appTextField
                                    .checkMatricsID(_matricsIDCon.text),
                              ),
                              AppTextField(
                                textFieldStyle: kTextFieldStyleDark,
                                textEditingController: _passwordCon,
                                labelText: 'Password',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.visiblePassword,
                                isPasswordHidden: true,
                                typePassword: true,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                    child: Container(
                      width: DeviceSizeConfig.deviceWidth * 0.9,
                      height: DeviceSizeConfig.deviceHeight * 0.1,
                      child: RawMaterialButton(
                        fillColor: kGreenColor,
                        focusColor: kGreenDarker,
                        hoverColor: kGreenDarker,
                        splashColor: kGreenDarker,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () async {
                          await _advisorController
                              .advisorSignIn(_matricsIDCon.text,
                                  _passwordCon.text, context)
                              .then((value) {
                            if (value == true) {
                              print(value);
                              return SnackBar(
                                  content: Text('Successfully Signed In'));
                            } else {
                              return ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  
                                      content: Text(
                                          'Please check your credentials and try again')));
                            }
                          });
                        },
                        child: Text(
                          'Sign In',
                          style: kButtonTextStyleW,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

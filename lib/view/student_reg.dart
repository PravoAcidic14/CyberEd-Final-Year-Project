import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/user_auth.dart';
import 'package:fyp_app_design/view/components/shapes.dart';
import 'package:fyp_app_design/view/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'components/appbar.dart';

class StudentRegisterView extends StatefulWidget {
  const StudentRegisterView({Key key}) : super(key: key);

  @override
  _StudentRegisterViewState createState() => _StudentRegisterViewState();
}

class _StudentRegisterViewState extends State<StudentRegisterView> {
  var _circleOffset = List.filled(6, -1000.0);
  final _formKey = GlobalKey<FormState>();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();
  final _confirmPassCon = TextEditingController();
  // ignore: missing_required_param
  final appTextField = AppTextField();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _circleOffset[0] = -80.0;
        _circleOffset[1] = -80.0;
        _circleOffset[2] = -60.0;
        _circleOffset[3] = -40.0;
        _circleOffset[4] = -60.0;
        _circleOffset[5] = -60.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    final String title = 'Create An Account';

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColorBright,
        appBar: CustomAppBar(
          height: 50.0,
          iconColor: Colors.black,
          route: '/',
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: 110.0,
              right: _circleOffset[0],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.45,
                height: DeviceSizeConfig.deviceWidth * 0.45,
                bgColor: const Color(0xFF4B7AFF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: -120.0,
              right: _circleOffset[1],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.55,
                height: DeviceSizeConfig.deviceWidth * 0.55,
                bgColor: const Color(0xFF00A6FF),
              ),
              duration: Duration(milliseconds: 1800),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: 20.0,
              right: _circleOffset[2],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF4BC0FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: -50.0,
              left: _circleOffset[3],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF00A6FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              top: 300.0,
              left: _circleOffset[4],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.30,
                height: DeviceSizeConfig.deviceWidth * 0.30,
                bgColor: const Color(0xFF4B7AFF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              top: 240.0,
              left: _circleOffset[5],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF4BC0FF),
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
                      style: titleStyleBlack(fontsize: 35),
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
                                textEditingController: _emailCon,
                                labelText: 'E-mail Address',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.emailAddress,
                                isPasswordHidden: false,
                                typePassword: false,
                                typeConfirmPassword: false,
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
                              AppTextField(
                                textFieldStyle: kTextFieldStyleDark,
                                textEditingController: _confirmPassCon,
                                labelText: 'Confirm Password',
                                labelStyle: kHintStyleDark,
                                fillColor: kLightTextFieldColor,
                                textInputType: TextInputType.visiblePassword,
                                isPasswordHidden: true,
                                typePassword: false,
                                typeConfirmPassword: true,
                                errorMessage: appTextField.checkPasswordMatch(
                                    _passwordCon.text, _confirmPassCon.text),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Already have an account? ',
                              style: kTextSpanStaticStyle(color: Colors.black),
                            ),
                            TextSpan(
                                text: 'Sign In',
                                style:
                                    kTextSpanDynamicStyle(color: kGreenColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, '/student-login');
                                  })
                          ],
                        ),
                      ),
                    ),
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            context
                                .read<UserAuth>()
                                .userRegister(
                                  context: context,
                                  email: _emailCon.text.trim(),
                                  password: _passwordCon.text.trim(),
                                );
                          }
                        },
                        child: Text(
                          'Register',
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

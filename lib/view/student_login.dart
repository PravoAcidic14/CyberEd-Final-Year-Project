import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/user_auth.dart';

import 'package:provider/provider.dart';
import 'package:fyp_app_design/view/components/appbar.dart';
import '../constants.dart';
import 'components/shapes.dart';
import 'components/text_field.dart';

class StudentLoginView extends StatefulWidget {
  StudentLoginView({Key key}) : super(key: key);

  @override
  _StudentLoginViewState createState() => _StudentLoginViewState();
}

class _StudentLoginViewState extends State<StudentLoginView> {
  var _circleOffset = List.filled(6, -1000.0);
  final _formKey = GlobalKey<FormState>();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();
  // ignore: missing_required_param
  final appTextField = AppTextField();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _circleOffset[0] = -80.0;
        _circleOffset[1] = -90.0;
        _circleOffset[2] = -90.0;
        _circleOffset[3] = -80.0;
        _circleOffset[4] = -60.0;
        _circleOffset[5] = -90.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    final String title = 'Login As Student';

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundColorDark,
        appBar: CustomAppBar(
          height: 50.0,
          iconColor: Colors.white,
          route: '/student-reg',
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              top: _circleOffset[0],
              right: 40.0,
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF4BC0FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              top: -80.0,
              right: _circleOffset[1],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.50,
                height: DeviceSizeConfig.deviceWidth * 0.50,
                bgColor: const Color(0xFF00A6FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: 140.0,
              right: _circleOffset[2],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.45,
                height: DeviceSizeConfig.deviceWidth * 0.45,
                bgColor: const Color(0xFF4B7AFF),
              ),
              duration: Duration(milliseconds: 1800),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: _circleOffset[3],
              right: -40.0,
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF4BC0FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: _circleOffset[3],
              left: 20.0,
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
                bgColor: const Color(0xFF4BC0FF),
              ),
              duration: Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
            ),
            AnimatedPositioned(
              bottom: -70.0,
              left: _circleOffset[3],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.35,
                height: DeviceSizeConfig.deviceWidth * 0.35,
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
            AnimatedPositioned(
              top: 300.0,
              left: _circleOffset[4],
              child: AppCircle(
                width: DeviceSizeConfig.deviceWidth * 0.30,
                height: DeviceSizeConfig.deviceWidth * 0.30,
                bgColor: const Color(0xFF00A6FF),
              ),
              duration: Duration(milliseconds: 2000),
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
                                textFieldStyle: kTextFieldStyleLight,
                                textEditingController: _emailCon,
                                labelText: 'E-mail Address',
                                labelStyle: kHintStyleLight,
                                fillColor: kDarkTextFieldColor,
                                textInputType: TextInputType.emailAddress,
                                isPasswordHidden: false,
                                typePassword: false,
                                typeConfirmPassword: false,
                              ),
                              AppTextField(
                                textFieldStyle: kTextFieldStyleLight,
                                textEditingController: _passwordCon,
                                labelText: 'Password',
                                labelStyle: kHintStyleLight,
                                fillColor: kDarkTextFieldColor,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              style: kTextSpanStaticStyle(color: Colors.white),
                            ),
                            TextSpan(
                                text: 'Register',
                                style:
                                    kTextSpanDynamicStyle(color: kGreenColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context,
                                        ModalRoute.withName('/student-reg'));
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
                            context.read<UserAuth>().userSignIn(
                                  context: context,
                                  email: _emailCon.text.trim(),
                                  password: _passwordCon.text.trim(),
                                );
                          }
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/advisor_login.dart';
import 'package:fyp_app_design/view/student_reg.dart';
import 'package:lottie/lottie.dart';
import 'package:fyp_app_design/constants.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                width: DeviceSizeConfig.deviceWidth * 0.65,
                height: DeviceSizeConfig.deviceWidth * 0.65,
                child: Lottie.asset('assets/first_screen_lottie.json'),
              ),
            ),
            Text(
              'Cyber Security',
              style: titleStyleBlack(fontsize: 45),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Cyber Awareness is the key to Cyber Safety',
                textAlign: TextAlign.center,
                style: kTextStyle,
              ),
            ),
            Text(
              '~Motto of CyberHack&Ethics SIG',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 16.0,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(59, 58, 66, 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: DeviceSizeConfig.deviceWidth * 0.9,
                height: DeviceSizeConfig.deviceHeight * 0.1,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentRegisterView(),
                                  ),
                                );
                              },
                              fillColor: Colors.white,
                              splashColor: Colors.grey[100],
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I\'m a Student',
                                    style: kButtonTextStyleB,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(-15.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdvisorLoginView(),
                                  ),
                                );
                              },
                              fillColor: Color.fromRGBO(59, 58, 66, 1.0),
                              splashColor: Color.fromRGBO(25, 23, 32, 1.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I\'m an Advisor',
                                    style: kButtonTextStyleW,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

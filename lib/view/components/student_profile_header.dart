import 'package:flutter/material.dart';

import '../../constants.dart';

class StudentProfilePageHeader extends StatelessWidget {
  const StudentProfilePageHeader({
    Key key,
    @required this.userMap,
  }) : super(key: key);

  final Map userMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceSizeConfig.deviceWidth,
      height: DeviceSizeConfig.deviceHeight * 0.25 + kToolbarHeight,
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        boxShadow: [
          BoxShadow(
              color: Colors.black45,
              offset: Offset(3.0, 3.0),
              blurRadius: 8.0,
              spreadRadius: 2.0)
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: DeviceSizeConfig.deviceWidth * 0.3,
              height: DeviceSizeConfig.deviceWidth * 0.3,
              child: CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 55,
                child: Container(
                  width: DeviceSizeConfig.deviceWidth * 0.27,
                  height: DeviceSizeConfig.deviceWidth * 0.27,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kGrey2,
                  ),
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading_indicator.gif',
                      image: userMap['avatarUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: userMap["firstName"] + " " + userMap["lastName"],
                      style: TextStyle(
                        fontFamily: "Glacial Indifference",
                        fontWeight: FontWeight.w700,
                        color: kWhite,
                        fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                      ),
                    ),
                    TextSpan(
                      text: "\n" + userMap["ageRange"].toString() + " Years Old",
                      style: TextStyle(
                        fontFamily: "Glacial Indifference",
                        fontWeight: FontWeight.w400,
                        color: kWhite,
                        fontSize: DeviceSizeConfig.deviceWidth * 0.05,
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

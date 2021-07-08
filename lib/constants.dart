import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//device metadata
class DeviceSizeConfig {
  static MediaQueryData mediaQueryData;
  static double deviceHeight;
  static double deviceWidth;
  static double deviceTextScaleFactor;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    deviceWidth = mediaQueryData.size.width;
    deviceHeight = mediaQueryData.size.height;
    deviceTextScaleFactor = mediaQueryData.textScaleFactor;
  }
}

//style constants
const kTextStyle = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: Colors.black87);

const kHintStyleDark = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: kDarkIconColor);

const kHintStyleLight = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: kLightIconColor);

const kTextFieldStyleDark = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: Colors.black);

const kTextFieldStyleLight = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: Colors.white);

TextStyle kTextSpanStaticStyle({Color color}) {
  return TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: color,
  );
}

TextStyle kTextSpanDynamicStyle({Color color}) {
  return TextStyle(
      fontFamily: 'Open Sans',
      fontSize: 15,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: color);
}

const kButtonTextStyleW = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    color: Colors.white);

const kButtonTextStyleB = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 22,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    color: Colors.black);

const kOptionsTextStyleB = TextStyle(
    fontFamily: 'Open Sans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: kOptionsGrey);

TextStyle titleStyleBlack({double fontsize}) {
  return TextStyle(
      fontFamily: 'Open Sans',
      fontSize: fontsize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: -1.0);
}

TextStyle titleStyleWhite({double fontsize}) {
  return TextStyle(
    fontFamily: 'Open Sans',
    fontSize: fontsize,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle boldTextStyleCustom({double fontsize, Color color}) {
  return TextStyle(
    fontFamily: 'Open Sans',
    fontSize: fontsize,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    color: color,
  );
}

TextStyle semiBoldTextStyleCustom(
    {double fontsize, Color color, List<Shadow> shadows}) {
  return TextStyle(
      fontFamily: 'Open Sans',
      fontSize: fontsize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: color,
      shadows: shadows);
}

//color constants
const Color kPrimaryColor = Color(0xFF3DBBFF);
const Color kPrimaryLightBackground = Color(0xFFF4F8FF);
const Color kTextColor = Color(0xFF1F2D3D);
const Color kTextGreyColor = Color(0xFF5A6978);
const Color kOptionsGrey = Color(0xFF47525E);
const Color kBackgroundColorBright = Color(0xFFEDF3FF);
const Color kBackgroundColorDark = Color(0xFF191720);
const Color kLightTextFieldColor = Color(0xFFEDEDED);
const Color kDarkTextFieldColor = Color(0xFF4E4E4E);
const Color kLightIconColor = Colors.white70;
const Color kDarkIconColor = Color(0xFF5A6978);
const Color kGreenColor = Color(0xFF60CC36);
const Color kGreenDarker = Color(0xFF4EAF28);
const Color kGreenTileColor = Color(0xFF77D353);
const Color kGrey1 = Color(0xFF343F4B);
const Color kGrey2 = Color(0xFF5A6978);
const Color kGrey3 = Color(0xFF969FAA);
const Color kBlue1 = Color(0xFF4B7AFF);
const Color kBlue2 = Color(0xFF00A6FF);
const Color kBlue3 = Color(0xFF4BC0FF);
const Color kRed = Colors.red;
const Color kWhite = Colors.white;
const Color kAdaptiveProgressColor = Color(0xFFF9991D);

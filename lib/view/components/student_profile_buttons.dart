import 'package:flutter/material.dart';

import '../../constants.dart';

class StudentProfilePageButtons extends StatelessWidget {
  const StudentProfilePageButtons({
    Key key,
    this.onPressed,
    this.btnLabel,
    this.btnIcon, this.fontColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String btnLabel;
  final IconData btnIcon;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(left: 45.0),
              alignment: Alignment.centerLeft,
              primary: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              elevation: 5.0,
              minimumSize: Size(
                DeviceSizeConfig.deviceWidth * 0.9,
                DeviceSizeConfig.deviceHeight * 0.17,
              ),
            ),
            icon: Icon(
              btnIcon,
              color: fontColor.withOpacity(0.6),
              size: DeviceSizeConfig.deviceWidth * 0.1,
            ),
            label: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                btnLabel,
                style: TextStyle(
                  fontFamily: "Open Sans",
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                  color: fontColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

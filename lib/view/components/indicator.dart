import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final Color textColor;

  const Indicator({
    Key key,
    @required this.color,
    @required this.text,
    @required this.isSquare,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: DeviceSizeConfig.deviceWidth * 0.07,
          height: DeviceSizeConfig.deviceWidth * 0.07,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          width: DeviceSizeConfig.deviceWidth * 0.7,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: DeviceSizeConfig.deviceWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}

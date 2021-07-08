import 'package:flutter/material.dart';

import '../../constants.dart';

class AppButtons extends StatelessWidget {
  final Text buttonText;
  final double elevation;
  final BorderSide borderSide;
  final Color fillColor, childColor, otherColor;
  final Icon icon;
  final ShapeBorder shape;
  final GestureTapCallback onPressed;
  const AppButtons({
    Key key,
    @required this.onPressed,
    this.buttonText,
    this.fillColor,
    this.childColor,
    this.shape,
    this.icon,
    this.otherColor,
    this.borderSide,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceSizeConfig.deviceWidth,
      height: DeviceSizeConfig.deviceHeight * 0.1,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(fillColor),
                  foregroundColor: MaterialStateProperty.all(childColor),
                  overlayColor: MaterialStateProperty.all(otherColor),
                  shape: MaterialStateProperty.all(shape),
                  elevation: MaterialStateProperty.all(elevation),
                  side: MaterialStateProperty.all(borderSide)),
              child: buttonText)
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(fillColor),
                foregroundColor: MaterialStateProperty.all(childColor),
                overlayColor: MaterialStateProperty.all(otherColor),
                shape: MaterialStateProperty.all(shape),
                side: MaterialStateProperty.all(borderSide),
              ),
              icon: icon,
              label: buttonText,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppCircle extends StatelessWidget {
  final double width;
  final double height;
  final Color bgColor;

  const AppCircle(
      {Key key,
      @required this.width,
      @required this.height,
      @required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
    );
  }
}

class AppSquare extends StatelessWidget {
  final double width, height, angleValue;
  final Color bgColor;

  const AppSquare(
      {Key key, this.width, this.height, this.bgColor, this.angleValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / angleValue,
      child: Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}

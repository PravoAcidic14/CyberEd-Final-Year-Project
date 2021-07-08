import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants.dart';

class AdaptiveSegmentedCircularProgress extends StatelessWidget {
  final double stops;
  final int count, total;
  const AdaptiveSegmentedCircularProgress({
    this.stops,
    Key key,
    this.count,
    this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    return TweenAnimationBuilder(
        tween: Tween(begin: stops - stops, end: stops),
        duration: Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Container(
            width: DeviceSizeConfig.deviceWidth * 0.17,
            height: DeviceSizeConfig.deviceWidth * 0.17,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                      startAngle: 3 * math.pi / 2,
                      endAngle: 7 * math.pi / 2,
                      colors: [kAdaptiveProgressColor, kGrey3],
                      tileMode: TileMode.repeated,
                      stops: [value, value],
                      center: Alignment.center,
                    ).createShader(rect);
                  },
                  child: Container(
                    width: DeviceSizeConfig.deviceWidth * 0.17,
                    height: DeviceSizeConfig.deviceWidth * 0.17,
                    decoration:
                        BoxDecoration(color: kWhite, shape: BoxShape.circle),
                  ),
                ),
                Center(
                  child: Container(
                    width: DeviceSizeConfig.deviceWidth * 0.17 - 17,
                    height: DeviceSizeConfig.deviceWidth * 0.17 - 17,
                    decoration: BoxDecoration(
                        color: kPrimaryColor, shape: BoxShape.circle),
                    child: total != null
                        ? Center(
                            child: Text(
                              '$count / $total',
                              style: boldTextStyleCustom(
                                color: kWhite,
                                fontsize: DeviceSizeConfig.deviceWidth * 0.05,
                              ),
                            ),
                          )
                        : null,
                  ),
                )
              ],
            ),
          );
        });
  }
}

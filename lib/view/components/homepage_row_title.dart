import 'package:flutter/material.dart';

import '../../constants.dart';

class HomePageRowTitle extends StatelessWidget {
  const HomePageRowTitle({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            fontSize: DeviceSizeConfig.deviceWidth * 0.05),
      ),
    );
  }
}

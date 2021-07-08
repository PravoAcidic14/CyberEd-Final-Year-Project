import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';


class HomePageModuleContainer extends StatelessWidget {
  HomePageModuleContainer({
    Key key,
    this.thumbnailUrl,
    this.moduleId,
    this.moduleTitle,
  }) : super(key: key);

  final String thumbnailUrl, moduleId, moduleTitle;

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            width: DeviceSizeConfig.deviceWidth * 0.45,
            height: DeviceSizeConfig.deviceHeight * 0.35,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black87,
                    offset: Offset(4.0, 2.0),
                    blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              image: DecorationImage(
                alignment: Alignment(-.2, 0),
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              return Navigator.pushNamed(context, '/activity-view',
                  arguments: moduleId);
            },
            child: Container(
              width: DeviceSizeConfig.deviceWidth * 0.45,
              height: DeviceSizeConfig.deviceHeight * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8)
                    ]),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    moduleTitle,
                    style: TextStyle(
                      fontFamily: "Open Sans",
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                      fontSize: DeviceSizeConfig.deviceWidth * 0.06,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

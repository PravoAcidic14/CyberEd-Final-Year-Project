import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/badge_controller.dart';
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class BadgeUnlockedView extends StatelessWidget {
  const BadgeUnlockedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BadgeController _badgeController = BadgeController();
    Map badgeArguments = ModalRoute.of(context).settings.arguments;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBlue1, kBlue2, kBlue3],
        ),
      ),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.restorablePopAndPushNamed(
                  context,
                  '/activity-view',
                  arguments: badgeArguments['moduleId']
                );
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () => Navigator.restorablePopAndPushNamed(
                  context,
                  '/activity-view',
                  arguments: badgeArguments['moduleId']
                ),
                child: Icon(Icons.close),
              )),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Congratulations! You unlocked a badge',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                      fontSize: DeviceSizeConfig.deviceWidth * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: DeviceSizeConfig.deviceHeight * 0.1),
                FutureBuilder(
                  future: _badgeController.getBadgeDetailsById(badgeArguments['badgeId']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            width: DeviceSizeConfig.deviceWidth * 0.6,
                            height: DeviceSizeConfig.deviceWidth * 0.6,
                            child: Lottie.network(snapshot.data['badgeUrl']),
                          ),
                          SizedBox(
                            height: DeviceSizeConfig.deviceHeight * 0.1,
                          ),
                          Text(
                            snapshot.data['badgeName'],
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: DeviceSizeConfig.deviceWidth * 0.07,
                              color: kWhite,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              snapshot.data['badgeDescription'],
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: DeviceSizeConfig.deviceWidth * 0.05,
                                color: kWhite,
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

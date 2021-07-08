import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/activity_controller.dart';

import 'components/update_activity_details.dart';

class AdvisorUpdateLevelView extends StatefulWidget {
  AdvisorUpdateLevelView({Key key}) : super(key: key);

  @override
  _AdvisorUpdateLevelViewState createState() => _AdvisorUpdateLevelViewState();
}

class _AdvisorUpdateLevelViewState extends State<AdvisorUpdateLevelView> {
  ActivityController _activityController = ActivityController();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map moduleDetails = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: kBackgroundColorBright,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            Container(
              width: DeviceSizeConfig.deviceWidth * 0.9,
              child: Text(
                'Update ${moduleDetails['moduleTitle']} - Level ${moduleDetails['level']}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: DeviceSizeConfig.deviceWidth * 0.08,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: DeviceSizeConfig.deviceHeight * 0.04,
            ),
            FutureBuilder<List>(
              future: _activityController.getActivityByLevel(
                  moduleDetails['moduleId'], moduleDetails['level']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      width: DeviceSizeConfig.deviceWidth * 0.9,
                      height: DeviceSizeConfig.deviceHeight * 0.7,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 4.0,
                                      right: 8.0,
                                      bottom: 4.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isDismissible: false,
                                            backgroundColor:
                                                kBackgroundColorBright,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              snapshot.data[index]
                                                  ['activityId'] = index;
                                              snapshot.data[index]['level'] =
                                                  moduleDetails['level'];
                                              snapshot.data[index]['moduleId'] =
                                                  moduleDetails['moduleId'];
                                              return UpdateActivityDetails(
                                                moduleDetails: moduleDetails,
                                                activityId: index,
                                                activityDetails:
                                                    snapshot.data[index],
                                              );
                                            }).whenComplete(() {
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        width:
                                            DeviceSizeConfig.deviceWidth * 0.9,
                                        height:
                                            DeviceSizeConfig.deviceHeight * 0.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: kWhite,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 4),
                                              blurRadius: 5.0,
                                              color: Colors.black45,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      width: DeviceSizeConfig
                                                              .deviceWidth *
                                                          0.5,
                                                      child: Text(
                                                        snapshot.data[index]
                                                            ['activityTitle'],
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: DeviceSizeConfig
                                                                  .deviceWidth *
                                                              0.05,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Icon(
                                                      selectIcon(
                                                          snapshot.data[index]
                                                              ["activityType"]),
                                                      color: Colors.black,
                                                      size: DeviceSizeConfig
                                                              .deviceWidth *
                                                          0.1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  IconData selectIcon(String activityType) {
    if (activityType == "video") {
      return Icons.play_circle_fill;
    } else if (activityType == "game") {
      return Icons.sports_esports;
    } else if (activityType == "slides") {
      return Icons.slideshow;
    } else if (activityType == "poster") {
      return Icons.info;
    }
  }
}

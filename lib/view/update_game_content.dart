import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/game_controller.dart';
import 'package:fyp_app_design/view/components/update_game_set.dart';

class UpdateGameContent extends StatefulWidget {
  UpdateGameContent({Key key, this.activityDetails}) : super(key: key);

  final activityDetails;
  @override
  _UpdateGameContentState createState() => _UpdateGameContentState();
}

class _UpdateGameContentState extends State<UpdateGameContent> {
  GameController gameController = GameController();

  @override
  Widget build(BuildContext context) {
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
                'Update ${widget.activityDetails['activityTitle']}',
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
            FutureBuilder(
              future: gameController
                  .getGameDetails(widget.activityDetails['gameId']),
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
                              itemCount: snapshot.data['setAmount'],
                              itemBuilder: (context, index) {
                                var realIndex = index + 1;
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
                                              snapshot.data['gameContent']
                                                          ['set$realIndex']
                                                      ['gameId'] =
                                                  widget.activityDetails[
                                                      'gameId'];
                                              snapshot.data['gameContent']
                                                      ['set$realIndex']
                                                  ['setNum'] = realIndex;
                                              return UpdateGameSet(
                                                gameDetails:
                                                    snapshot.data['gameContent']
                                                        ['set$realIndex'],
                                                        gameType: widget.activityDetails['gameType'],
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
                                            Container(
                                              width:
                                                  DeviceSizeConfig.deviceWidth *
                                                      0.5,
                                              child: Center(
                                                child: Text(
                                                  'Update Set $realIndex',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: DeviceSizeConfig
                                                            .deviceWidth *
                                                        0.05,
                                                    color: Colors.black,
                                                  ),
                                                ),
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
}

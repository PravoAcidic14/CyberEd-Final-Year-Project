import 'package:cool_alert/cool_alert.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/guess_the_word_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';

class HangmanGameView extends StatefulWidget {
  HangmanGameView({Key key}) : super(key: key);

  @override
  _HangmanGameViewState createState() => _HangmanGameViewState();
}

class _HangmanGameViewState extends State<HangmanGameView> {
  Map gameMainData;
  String defaultQuestion = 'Question --',
      answerString = '',
      onDragCompleteString = '';
  List<String> mainQuestionText = [];
  int _defaultIndex = 1, setCount, totalAnsweredCorrectly = 0;
  bool setStateFinished = false, accepted = false, allActivityCompleted;
  GuessTheWordController _guessTheWordCon = GuessTheWordController();
  UserController _userController = UserController();
  List<String> alphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];
  List<String> _choosenLetters = [];
  String _currentWord;
  List<String> _currentwordList = [];
  int _numberOfTries = 5;

  // @override
  // void initState() {
  //   //current word must be from database
  //   _currentWord = 'spyware';
  //   _currentwordList = _currentWord.toUpperCase().split("");
  //   super.initState();
  // }

  // checkNumberOfTries(int tryNum) {
  //   if (tryNum == 0) {
  //     return CoolAlert.show(
  //         context: context,
  //         type: CoolAlertType.error,
  //         text:
  //             'No more tries left  ${Emojis.cryingFace}... Please try again later.');
  //   } else {
  //     return null;
  //   }
  // }

  // void _incrementCounter() {
  //   setState(() {
  //     _currentWord = 'spyware';
  //     _choosenLetters = [];
  //     _currentwordList = _currentWord.toUpperCase().split("");
  //     _wrongCount = -1;
  //     _gameOver = false;
  //   });
  // }

  bool _hasWon() {
    if (_currentwordList.isEmpty || _choosenLetters.isEmpty) {
      return false;
    }

    bool _hasWonBool = true;
    _currentwordList.forEach((eachletter) {
      if (!_choosenLetters.contains(eachletter.toUpperCase())) {
        _hasWonBool = false;
      }
    });
    if (_hasWonBool) {
      setState(() {
        // _currentAnimation = "won";
      });
    }
    return _hasWonBool;
  }

  // int _getScore() {}

  @override
  Widget build(BuildContext context) {
    if (gameMainData == null || gameMainData.isEmpty) {
      gameMainData = ModalRoute.of(context).settings.arguments;
    }
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
          color: kWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    defaultQuestion,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                      fontSize: DeviceSizeConfig.deviceWidth * 0.07,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    '$_numberOfTries Lives',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.pink[100],
                  avatar: Icon(Icons.favorite, color: Colors.red[600]),
                  elevation: 5.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Container(
                height: DeviceSizeConfig.deviceHeight * 0.01,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: setCount != null
                        ? (_defaultIndex / setCount).toDouble()
                        : 1.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kAdaptiveProgressColor),
                    backgroundColor: Color(0xFFFFDAB8),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: DeviceSizeConfig.deviceHeight * 0.02,
            ),
            Expanded(
              child: Container(
                width: DeviceSizeConfig.deviceWidth * 0.9,
                height: DeviceSizeConfig.deviceHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  color: kBackgroundColorBright,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(3.0, -2.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: _guessTheWordCon
                            .parseGameContentFromId(gameMainData['gameId']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            setCount = snapshot.data['setAmount'];
                            _currentWord = snapshot.data['gameContent']
                                ['set$_defaultIndex']['answer'];
                            _currentwordList =
                                _currentWord.toUpperCase().split("");
                            if (!setStateFinished) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                setState(() {
                                  setStateFinished = true;
                                  defaultQuestion =
                                      "Question $_defaultIndex/$setCount";

                                  if (_defaultIndex != setCount) {
                                    onDragCompleteString = 'Next';
                                  } else {
                                    onDragCompleteString = 'Finish';
                                  }
                                });
                              });
                            }
                            return Column(
                              children: [
                                Center(
                                  child: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.8,
                                    height:
                                        DeviceSizeConfig.deviceHeight * 0.25,
                                    child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/loading_indicator.gif',
                                        image: snapshot.data['gameContent']
                                            ['set$_defaultIndex']['imageUrl']),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.8,
                                    child: Text(
                                      snapshot.data['gameContent']
                                          ['set$_defaultIndex']['hint'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            DeviceSizeConfig.deviceWidth * 0.06,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(_currentWord.length,
                                        (int index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Text(
                                          ((_choosenLetters.contains(
                                                  _currentWord[index]
                                                      .toUpperCase()))
                                              ? _currentWord[index]
                                                  .toUpperCase()
                                              : " "),
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 30,
                                          ),
                                        ),
                                      );
                                    })),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Wrap(
                                    spacing: 2,
                                    runSpacing: 2,
                                    // alignment: WrapAlignment.center,
                                    children: alphabets.map((letter) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(1.0),
                                          primary: _choosenLetters.contains(
                                                  letter.toUpperCase())
                                              ? _currentwordList.contains(
                                                      letter.toUpperCase())
                                                  ? kGreenColor
                                                  : Colors.red
                                              : kWhite,
                                          minimumSize: Size(35.0, 35.0),
                                        ),
                                        child: Text(
                                          letter,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: _choosenLetters.contains(
                                                    letter.toUpperCase())
                                                ? kWhite
                                                : Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_choosenLetters
                                              .contains(letter.toUpperCase())) {
                                            //letter already selected
                                            return null;
                                          } else if (_numberOfTries == 0) {
                                            //no more tries left
                                            return CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text:
                                                    'No more tries left ${Emojis.cryingFace}... Please try again later.',
                                                confirmBtnText: 'Okay',
                                                onConfirmBtnTap: () =>
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/activity-view')));
                                          } else {
                                            //letter newly pressed
                                            setState(() {
                                              _choosenLetters
                                                  .add(letter.toUpperCase());
                                            });
                                            if (!_currentwordList.contains(
                                                letter.toUpperCase())) {
                                              setState(() {
                                                --_numberOfTries;
                                              });
                                            } else {
                                              bool checkWinOrLoose = _hasWon();

                                              if (checkWinOrLoose) {
                                                if (_defaultIndex < setCount) {
                                                  CoolAlert.show(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      type:
                                                          CoolAlertType.success,
                                                      title: 'Correct!',
                                                      confirmBtnText: 'Next',
                                                      onConfirmBtnTap: () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          setStateFinished = false;
                                                          _choosenLetters
                                                              .clear();
                                                          ++_defaultIndex;
                                                        });
                                                      });
                                                } else {
                                                  CoolAlert.show(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    type: CoolAlertType.success,
                                                    text:
                                                        'Congratulations! You successfully completed Guess The Word Challenge!',
                                                    confirmBtnText: 'Yay!',
                                                    onConfirmBtnTap: () async {
                                                      await _userController
                                                          .completeActivity(
                                                              activityId:
                                                                  gameMainData[
                                                                      "activityId"],
                                                              activityListLength:
                                                                  gameMainData[
                                                                      "activityListLength"],
                                                              moduleId:
                                                                  gameMainData[
                                                                      "moduleId"],
                                                              level:
                                                                  gameMainData[
                                                                      "level"],
                                                              activityPoints:
                                                                  int.parse(
                                                                      gameMainData[
                                                                          "activityPoints"].toString()))
                                                          .whenComplete(() {
                                                        Navigator.restorablePopAndPushNamed(
                                                            context,
                                                            '/activity-view',
                                                            arguments:
                                                                gameMainData[
                                                                    "moduleId"]);
                                                        if (allActivityCompleted) {
                                                          return CoolAlert.show(
                                                              context: context,
                                                              type:
                                                                  CoolAlertType
                                                                      .success,
                                                              title:
                                                                  'Congratulations!',
                                                              text: 'You have successfully completed ' +
                                                                  gameMainData[
                                                                      'activityTitle'] +
                                                                  '!');
                                                        }
                                                      });
                                                    },
                                                  );
                                                }
                                              }
                                            }
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                                child: Container(
                              child: CircularProgressIndicator(),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //   Column(
    //     children: [
    //       Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: List.generate(_currentWord.length, (int index) {
    //             return Padding(
    //               padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    //               child: Text(
    //                 ((_choosenLetters
    //                             .contains(_currentWord[index].toUpperCase()) ||
    //                         _wrongCount > _numberOfTries)
    //                     ? _currentWord[index].toUpperCase()
    //                     : " "),
    //                 style: TextStyle(
    //                   decoration: TextDecoration.underline,
    //                   fontSize: 30,
    //                 ),
    //               ),
    //             );
    //           })),
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
    //         child: Wrap(
    //           spacing: 10,
    //           runSpacing: 10,
    //           // alignment: WrapAlignment.center,
    //           children: alphabets.map((letter) {
    //             print(alphabets.length);
    //             return ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 padding: EdgeInsets.all(1.0),
    //                 primary: _choosenLetters.contains(letter.toUpperCase())
    //                     ? _currentwordList.contains(letter.toUpperCase())
    //                         ? kGreenColor
    //                         : Colors.red
    //                     : kWhite,
    //                 minimumSize: Size(45.0, 50.0),
    //               ),
    //               child: Text(
    //                 letter,
    //                 style: TextStyle(
    //                   fontSize: 40,
    //                   color: _choosenLetters.contains(letter.toUpperCase())
    //                       ? kWhite
    //                       : Colors.black,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 if (_choosenLetters.contains(letter.toUpperCase())) {
    //                   //letter already selected
    //                   return null;
    //                 } else if (_numberOfTries == 0) {
    //                   //no more tries left
    //                   return CoolAlert.show(
    //                       context: context,
    //                       type: CoolAlertType.error,
    //                       text:
    //                           'No more tries left ${Emojis.cryingFace}... Please try again later.',
    //                       confirmBtnText: 'Okay',
    //                       onConfirmBtnTap: () => Navigator.popUntil(
    //                           context, ModalRoute.withName('/activity-view')));
    //                 } else {
    //                   //letter newly pressed
    //                   setState(() {
    //                     _choosenLetters.add(letter.toUpperCase());

    //                     if (!_currentwordList.contains(letter.toUpperCase())) {
    //                       --_numberOfTries;
    //                     }
    //                   });
    //                 }
    //               },
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

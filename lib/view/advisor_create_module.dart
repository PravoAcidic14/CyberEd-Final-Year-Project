import 'package:cool_alert/cool_alert.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/create_new_module_controller.dart';
import 'package:fyp_app_design/view/components/buttons.dart';
import 'package:fyp_app_design/view/components/create_adaptive_question.dart';
import 'package:fyp_app_design/view/components/create_module_details.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/view/components/text_field.dart';

import 'components/create_activity_details.dart';

class AdvisorCreateModule extends StatefulWidget {
  AdvisorCreateModule({Key key}) : super(key: key);

  @override
  _AdvisorCreateModuleState createState() => _AdvisorCreateModuleState();
}

class _AdvisorCreateModuleState extends State<AdvisorCreateModule> {
  CreateNewModule _createModuleCon = CreateNewModule();
  List<Step> _stepperItems = [];
  StepState _state1, _state2, _state3, _state4, _state5;
  int _currentStepIndex,
      totalActivityLvl1,
      totalActivityLvl2,
      totalActivityLvl3;
  GlobalKey<FormState> _moduleDetailsKey,
      _adaptiveQuizKey = GlobalKey<FormState>();
  Map adaptiveSet = {},
      moduleDetails = {},
      activityLvl1Details = {},
      activityLvl2Details = {},
      activityLvl3Details = {};
  bool allCreated;
  @override
  void initState() {
    _currentStepIndex = 0;

    _state1 = StepState.editing;
    _state2 = StepState.disabled;
    _state3 = StepState.disabled;
    _state4 = StepState.disabled;
    _state5 = StepState.disabled;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _stepperItems = [
      Step(
        title: Text(
          'Module Details',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: DeviceSizeConfig.deviceWidth * 0.045,
          ),
        ),
        content: ModuleDetailsForm(
          formKey: _moduleDetailsKey,
          newModuleDetails: moduleDetails,
        ),
        state: _state1,
        isActive: _currentStepIndex >= 0,
      ),
      Step(
        title: Text(
          'Adaptive Questions',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: DeviceSizeConfig.deviceWidth * 0.045,
          ),
        ),
        subtitle: Text(
          'This part cannot be updated later.',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            fontSize: DeviceSizeConfig.deviceWidth * 0.04,
          ),
        ),
        content: AdaptiveQuizForm(
          formKey: _adaptiveQuizKey,
          newAdaptiveQuiz: adaptiveSet,
        ),
        state: _state2,
        isActive: _currentStepIndex >= 1,
      ),
      Step(
        title: Text(
          'Level 1 Activities',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: DeviceSizeConfig.deviceWidth * 0.045,
          ),
        ),
        content: ActivityForm(
          newActivityDetails: activityLvl1Details,
          totalActivity: totalActivityLvl1,
        ),
        state: _state3,
        isActive: _currentStepIndex >= 2,
      ),
      Step(
        title: Text(
          'Level 2 Activities',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: DeviceSizeConfig.deviceWidth * 0.045,
          ),
        ),
        content: ActivityForm(
          newActivityDetails: activityLvl2Details,
          totalActivity: totalActivityLvl2,
        ),
        state: _state4,
        isActive: _currentStepIndex >= 3,
      ),
      Step(
        title: Text(
          'Level 3 Activities',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: DeviceSizeConfig.deviceWidth * 0.045,
          ),
        ),
        content: ActivityForm(
          newActivityDetails: activityLvl3Details,
          totalActivity: totalActivityLvl3,
        ),
        state: _state5,
        isActive: _currentStepIndex >= 4,
      ),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColorBright,
      appBar: AppBar(
        title: Text(
          'Create New Module',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  primaryColor: kGreenColor,
                ),
                child: Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: _stepperItems,
                  type: StepperType.vertical,
                  currentStep: _currentStepIndex,
                  onStepContinue: () {
                    if (_currentStepIndex == 4) {
                      if (activityLvl3Details.isNotEmpty &&
                          activityLvl3Details.length == totalActivityLvl3) {
                        //ToDo remove all pre created maps

                        print(activityLvl1Details);
                        print('LVL 2');
                        print(activityLvl2Details);
                        print('LVL 3');
                        print(activityLvl3Details);

                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          showCancelBtn: true,
                          text:
                              'Some parts cannot be edited later. Are you sure to create this module now?',
                          onConfirmBtnTap: () async {
                            Navigator.pop(context);
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                text: 'Loading...');
                            await _createModuleCon
                                .startTransaction(
                                    moduleDetails['moduleDetails'],
                                    adaptiveSet,
                                    activityLvl1Details,
                                    activityLvl2Details,
                                    activityLvl3Details)
                                .whenComplete(() {
                              Navigator.pop(context);
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                text: 'The module has been created succesfully',
                                onConfirmBtnTap: () {
                                  Navigator.restorablePopAndPushNamed(
                                      context, '/advisor-home');
                                },
                              );
                            });
                          },
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                'Please create all $totalActivityLvl3 activities first.');
                      }
                    } else if (_currentStepIndex == 0) {
                      if (moduleDetails.isNotEmpty &&
                          moduleDetails['moduleDetails'].length == 6) {
                        print(moduleDetails);
                        setState(() {
                          totalActivityLvl1 = int.parse(
                              moduleDetails['moduleDetails']
                                  ['totalActivityLvl1']);
                          totalActivityLvl2 = int.parse(
                              moduleDetails['moduleDetails']
                                  ['totalActivityLvl2']);
                          totalActivityLvl3 = int.parse(
                              moduleDetails['moduleDetails']
                                  ['totalActivityLvl3']);
                        });
                        changeStepState();
                      } else {
                        print(moduleDetails);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text: 'Please create the module details first.');
                      }
                    } else if (_currentStepIndex == 1) {
                      if (adaptiveSet['adaptiveSets'] != null &&
                          adaptiveSet['adaptiveSets'].length ==
                              adaptiveSet['totalSetNum']) {
                        changeStepState();
                        print(adaptiveSet);
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                'Please create all the adaptive questions first.');
                      }
                    } else if (_currentStepIndex == 2) {
                      if (activityLvl1Details.isNotEmpty &&
                          activityLvl1Details.length == totalActivityLvl1) {
                        changeStepState();
                        print(activityLvl1Details);
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                'Please create all $totalActivityLvl1 activities first.');
                      }
                    } else if (_currentStepIndex == 3) {
                      if (activityLvl2Details.isNotEmpty &&
                          activityLvl2Details.length == totalActivityLvl2) {
                        changeStepState();
                        print(activityLvl2Details);
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                'Please create all $totalActivityLvl2 activities first.');
                      }
                    }
                  },
                  onStepCancel: () {
                    _currentStepIndex == 0
                        // ignore: unnecessary_statements
                        ? null
                        : setState(() {
                            if (_currentStepIndex == 1) {
                              _state2 = StepState.indexed;
                              _state1 = StepState.editing;
                            } else if (_currentStepIndex == 2) {
                              _state3 = StepState.indexed;
                              _state2 = StepState.editing;
                            } else if (_currentStepIndex == 3) {
                              _state4 = StepState.indexed;
                              _state3 = StepState.editing;
                            } else if (_currentStepIndex == 4) {
                              _state5 = StepState.complete;
                              _state4 = StepState.editing;
                            }
                            _currentStepIndex = _currentStepIndex - 1;
                          });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeStepState() {
    setState(() {
      if (_currentStepIndex == 0) {
        _state1 = StepState.complete;
        _state2 = StepState.editing;
      } else if (_currentStepIndex == 1) {
        _state2 = StepState.complete;
        _state3 = StepState.editing;
      } else if (_currentStepIndex == 2) {
        _state3 = StepState.complete;
        _state4 = StepState.editing;
      } else if (_currentStepIndex == 3) {
        _state4 = StepState.complete;
        _state5 = StepState.editing;
      } else if (_currentStepIndex == 4) {
        _state5 = StepState.complete;
      }
      _currentStepIndex = _currentStepIndex + 1;
    });
  }
}

class AdaptiveQuizForm extends StatefulWidget {
  AdaptiveQuizForm({
    Key key,
    this.formKey,
    this.newAdaptiveQuiz,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Map newAdaptiveQuiz;

  @override
  _AdaptiveQuizFormState createState() => _AdaptiveQuizFormState();
}

class _AdaptiveQuizFormState extends State<AdaptiveQuizForm> {
  var setValue = '2 Questions';
  int setValueInt = 2;
  TextEditingController questionSetCon1 =
          TextEditingController(text: 'Tap to Create'),
      questionSetCon2 = TextEditingController(text: 'Tap to create'),
      questionSetCon3 = TextEditingController(text: 'Tap to create'),
      questionSetCon4 = TextEditingController(text: 'Tap to create');
  String succesEmoji = Emojis.checkMark;
  Map adaptiveSets = {};

  _AdaptiveQuizFormState();

  @override
  void initState() {
    widget.newAdaptiveQuiz['totalSetNum'] = 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AppDropdownFormField(
            fillColor: kLightTextFieldColor,
            value: setValue,
            labelText: "Choose number of questions",
            labelStyle: kHintStyleDark,
            options: ['2 Questions', '3 Questions', '4 Questions'],
            onChanged: (String value) {
              if (value == '2 Questions') {
                setState(() {
                  setValue = '2 Questions';
                  setValueInt = 2;
                  widget.newAdaptiveQuiz['totalSetNum'] = 2;
                });
              } else if (value == '3 Questions') {
                setState(() {
                  setValue = '3 Questions';
                  setValueInt = 3;
                  widget.newAdaptiveQuiz['totalSetNum'] = 3;
                });
              } else if (value == '4 Questions') {
                setState(() {
                  setValue = '4 Questions';
                  setValueInt = 4;
                  widget.newAdaptiveQuiz['totalSetNum'] = 4;
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: kGrey3,
              thickness: 2.0,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          for (var i = 0; i < setValueInt; i++)
            AppTextField(
              textEditingController: getController(i),
              labelText: 'Question Set ${i + 1}',
              fillColor: kLightTextFieldColor,
              labelStyle: kHintStyleDark,
              textFieldStyle: kTextFieldStyleDark,
              readOnly: true,
              onTap: () async {
                showModalBottomSheet(
                    isDismissible: false,
                    backgroundColor: kBackgroundColorBright,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CreateAdaptiveQuestion(
                        createdQuestionSet: widget.newAdaptiveQuiz,
                        setNum: i + 1,
                      );
                    }).then((value) {
                  setState(() {
                    if (value != null) {
                      adaptiveSets['set${i + 1}'] = value;
                      getController(i).text = 'Created  ' + succesEmoji;

                      if (adaptiveSets.length ==
                          widget.newAdaptiveQuiz['totalSetNum']) {
                        print('all created');
                        widget.newAdaptiveQuiz['adaptiveSets'] = adaptiveSets;
                      } else {
                        widget.newAdaptiveQuiz['adaptiveSets'] = adaptiveSets;
                        //widget.newAdaptiveQuiz.remove('adaptiveSets');
                      }
                    }
                  });
                });
              },
            ),
        ],
      ),
    );
  }

  TextEditingController getController(int i) => i == 0
      ? questionSetCon1
      : i == 1
          ? questionSetCon2
          : i == 2
              ? questionSetCon3
              : questionSetCon4;
}

class ModuleDetailsForm extends StatefulWidget {
  const ModuleDetailsForm({
    Key key,
    this.formKey,
    this.newModuleDetails,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Map newModuleDetails;

  @override
  _ModuleDetailsFormState createState() => _ModuleDetailsFormState();
}

class _ModuleDetailsFormState extends State<ModuleDetailsForm> {
  var tempFile;
  TextEditingController createModuleDetailsCon =
      TextEditingController(text: 'Tap to Create');
  String succesEmoji = Emojis.checkMark;
  Map moduleDetails = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AppTextField(
            textEditingController: createModuleDetailsCon,
            labelText: 'Module Details',
            fillColor: kLightTextFieldColor,
            labelStyle: kHintStyleDark,
            textFieldStyle: kTextFieldStyleDark,
            readOnly: true,
            onTap: () async {
              showModalBottomSheet(
                  isDismissible: false,
                  backgroundColor: kBackgroundColorBright,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return CreateModuleDetails(
                      createdModuleDetails: widget.newModuleDetails,
                    );
                  }).then((value) {
                setState(() {
                  if (value != null) {
                    widget.newModuleDetails['moduleDetails'] = value;
                    createModuleDetailsCon.text = 'Created  ' + succesEmoji;
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }
}

class ActivityForm extends StatefulWidget {
  ActivityForm({Key key, this.newActivityDetails, this.totalActivity})
      : super(key: key);

  final Map newActivityDetails;
  final int totalActivity;

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  List<bool> _isCreated = [];
  List<Color> _btnColor = [];
  List<Color> _btnTextColor = [];
  Color _btnBeforeCreateFillColor = kWhite,
      _btnAfterCreateFillColor = kGreenColor,
      _btnBeforeCreateTextColor = Colors.black,
      _btnAfterCreateTextColor = kWhite;

  @override
  void initState() {
    for (var i = 0; i < widget.totalActivity; i++) {
      //ToDo make this false back after testing
      _isCreated.insert(i, false);
      _btnColor.insert(i, _btnBeforeCreateFillColor);
      _btnTextColor.insert(i, _btnBeforeCreateTextColor);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_isCreated);
    return Column(
      children: [
        for (var i = 1; i <= widget.totalActivity; i++)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Container(
              height: DeviceSizeConfig.deviceHeight * 0.075,
              child: AppButtons(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  fillColor: _btnColor[i - 1],
                  buttonText: Text(
                      _isCreated[i - 1] == false
                          ? _getBeforeCreateBtnText(i)
                          : _getAfterCreateBtnText(),
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                        color: _btnTextColor[i - 1],
                        fontSize: DeviceSizeConfig.deviceWidth * 0.047,
                      )),
                  onPressed: () async {
                    print(widget.newActivityDetails);
                    showModalBottomSheet(
                        isDismissible: false,
                        backgroundColor: kBackgroundColorBright,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return CreateActivityDetails(
                            createdActivityDetails: widget.newActivityDetails,
                            currentActivity: i,
                          );
                        }).then((value) {
                      setState(() {
                        if (value != null) {
                          widget.newActivityDetails['activity$i'] = value;
                          print(widget.newActivityDetails);
                          _isCreated[i - 1] = true;
                          _btnColor[i - 1] = _btnAfterCreateFillColor;
                          _btnTextColor[i - 1] = _btnAfterCreateTextColor;
                        }
                      });
                    });
                  }),
            ),
          ),
      ],
    );
  }

  String _getBeforeCreateBtnText(int activityCount) {
    if (activityCount == 1) {
      return 'Create 1st Activity';
    } else if (activityCount == 2) {
      return 'Create 2nd Activity';
    } else if (activityCount == 3) {
      return 'Create 3rd Activity';
    } else {
      return 'Create ${activityCount}th Activity';
    }
  }

  String _getAfterCreateBtnText() {
    return 'Created  ${Emojis.checkBoxWithCheck}';
  }
}

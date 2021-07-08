import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/components/dropdown.dart';
import '../../constants.dart';
import 'text_field.dart';

class CreateAdaptiveQuestion extends StatefulWidget {
  CreateAdaptiveQuestion({Key key, this.createdQuestionSet, this.setNum})
      : super(key: key);

  final Map createdQuestionSet;
  final int setNum;

  @override
  _CreateAdaptiveQuestionState createState() => _CreateAdaptiveQuestionState();
}

class _CreateAdaptiveQuestionState extends State<CreateAdaptiveQuestion> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController questionCon,
      optionCon1,
      optionCon2,
      optionCon3,
      optionCon4,
      answerCon;

  Map adaptiveSetDetails = {};
  String answerText;
  List<String> options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  String answerValue = '';
  var value;

  @override
  void initState() {
    print(widget.createdQuestionSet);
    questionCon = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['question']
                    : ''
                : ''
            : '');
    optionCon1 = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['options'][0]
                    : ''
                : ''
            : '');
    optionCon2 = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['options'][1]
                    : ''
                : ''
            : '');
    optionCon3 = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['options'][2]
                    : ''
                : ''
            : '');
    optionCon4 = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['options'][3]
                    : ''
                : ''
            : '');
    answerCon = TextEditingController(
        text: widget.createdQuestionSet.isNotEmpty
            ? widget.createdQuestionSet.containsKey('adaptiveSets')
                ? widget.createdQuestionSet['adaptiveSets']
                        .containsKey('set${widget.setNum}')
                    ? widget.createdQuestionSet['adaptiveSets']
                        ['set${widget.setNum}']['answer']
                    : ''
                : ''
            : '');

    answerValue = widget.createdQuestionSet.isNotEmpty
        ? widget.createdQuestionSet.containsKey('adaptiveSets')
            ? widget.createdQuestionSet['adaptiveSets']
                    .containsKey('set${widget.setNum}')
                ? widget.createdQuestionSet['adaptiveSets']
                    ['set${widget.setNum}']['answer']
                : ''
            : ''
        : '';

    if (optionCon1.text.isNotEmpty) {
      options[0] = optionCon1.text;
    }
    if (optionCon2.text.isNotEmpty) {
      options[1] = optionCon2.text;
    }
    if (optionCon3.text.isNotEmpty) {
      options[2] = optionCon3.text;
    }
    if (optionCon4.text.isNotEmpty) {
      options[3] = optionCon4.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(options);
    print(answerValue);
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: DeviceSizeConfig.deviceWidth * 0.6,
                              child: Text(
                                'Enter New Details',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: DeviceSizeConfig.deviceWidth * 0.06,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(0.0),
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                      Form(
                        key: _key,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: DeviceSizeConfig.deviceHeight * 0.03,
                            ),
                            AppTextField(
                              textEditingController: questionCon,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Question',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: optionCon1,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Answer Option 1',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  if (answerValue.isNotEmpty) {
                                    if (options[0] == answerValue) {
                                      answerValue = value;
                                      options[0] = value;
                                    } else {
                                      options[0] = value;
                                    }
                                  } else {
                                    options[0] = value;
                                  }
                                });
                              },
                            ),
                            AppTextField(
                              textEditingController: optionCon2,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Answer Option 2',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  if (answerValue.isNotEmpty) {
                                    if (options[1] == answerValue) {
                                      answerValue = value;
                                      options[1] = value;
                                    } else {
                                      options[1] = value;
                                    }
                                  } else {
                                    options[1] = value;
                                  }
                                });
                              },
                            ),
                            AppTextField(
                              textEditingController: optionCon3,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Answer Option 3',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  if (answerValue.isNotEmpty) {
                                    if (options[2] == answerValue) {
                                      answerValue = value;
                                      options[2] = value;
                                    } else {
                                      options[2] = value;
                                    }
                                  } else {
                                    options[2] = value;
                                  }
                                });
                              },
                            ),
                            AppTextField(
                              textEditingController: optionCon4,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Answer Option 4',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                              onChanged: (value) {
                                setState(() {
                                  if (answerValue.isNotEmpty) {
                                    if (options[3] == answerValue) {
                                      answerValue = value;
                                      options[3] = value;
                                    } else {
                                      options[3] = value;
                                    }
                                  } else {
                                    options[3] = value;
                                  }
                                });
                              },
                            ),
                            AppDropdownFormField(
                              value: answerValue.isEmpty
                                  ? options[0]
                                  : answerValue,
                              labelText: "Answer",
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              options: options,
                              onChanged: (value) {
                                setState(() {
                                  answerValue = value;
                                });
                              },
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_key.currentState.validate()) {
                                      if (answerValue.isNotEmpty) {
                                        adaptiveSetDetails['question'] =
                                            questionCon.text;
                                        adaptiveSetDetails['options'] = [
                                          optionCon1.text,
                                          optionCon2.text,
                                          optionCon3.text,
                                          optionCon4.text
                                        ];
                                        adaptiveSetDetails['answer'] =
                                            answerValue;

                                        print(adaptiveSetDetails);

                                        Navigator.pop(
                                            context, adaptiveSetDetails);
                                      } else {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: 'Please choose an answer.');
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: DeviceSizeConfig.deviceWidth * 0.9,
                                    height: DeviceSizeConfig.deviceHeight * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: kGreenColor,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 4),
                                          blurRadius: 5.0,
                                          color: Colors.black45,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              DeviceSizeConfig.deviceWidth *
                                                  0.06,
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}

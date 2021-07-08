import 'package:flutter/material.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class AppTextField<TextFormField> extends StatefulWidget {
  final String labelText, helperText;
  final String errorMessage, initialText;
  final int maxLength;
  final double textFieldHeight;
  final TextInputType textInputType;
  TextCapitalization textCapitalization;
  final GestureTapCallback onTap, onIconButtonTap;
  Function(String) onChanged;
  final TextEditingController textEditingController;
  final Color fillColor;
  final TextStyle labelStyle, textFieldStyle;
  Function checkPassword;
  bool isPasswordHidden = false;
  bool typePassword = false;
  bool typeConfirmPassword = false;
  bool isUploadPic = false;
  bool readOnly = false;
  bool checkUploadPic = false;
  bool isActivityPoints = false;
  bool isTotalActivityCount = false;

  AppTextField({
    Key key,
    this.checkPassword,
    @required this.labelText,
    this.isPasswordHidden,
    this.textInputType,
    this.typePassword,
    this.typeConfirmPassword,
    this.isUploadPic,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.errorMessage,
    this.textEditingController,
    @required this.fillColor,
    @required this.labelStyle,
    @required this.textFieldStyle,
    this.maxLength,
    this.textCapitalization,
    this.initialText,
    this.textFieldHeight,
    this.onIconButtonTap,
    this.helperText,
    this.checkUploadPic,
    this.isActivityPoints,
    this.isTotalActivityCount,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();

  String checkPasswordMatch(oriValue, confirmValue) {
    String errorStatement;

    //print('Confirm value: ' + confirmValue);
    if (oriValue.toString().isNotEmpty && confirmValue.toString().isNotEmpty) {
      if (confirmValue.toString() != oriValue.toString()) {
        errorStatement = 'Please enter same password';
      } else {
        return errorStatement;
      }
      return errorStatement;
    }
    return errorStatement;
  }

  String checkMatricsID(matricsIDValue) {
    RegExp initial = new RegExp(
      r"^[a-zA-z]{1}\d{6}",
      caseSensitive: false,
      multiLine: false,
    );
    if (initial.hasMatch(matricsIDValue)) {
      return null;
    } else {
      return 'Please enter a valid Matrics ID';
    }
  }
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    widget.typePassword ??= false;
    widget.typeConfirmPassword ??= false;
    widget.isPasswordHidden ??= false;
    widget.isUploadPic ??= false;
    widget.readOnly ??= false;
    widget.checkUploadPic ??= false;
    widget.isActivityPoints ??= false;
    widget.isTotalActivityCount ??= false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: DeviceSizeConfig.deviceWidth * 0.9,
        height: DeviceSizeConfig.deviceHeight * 0.1,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              onTap: () => widget.onTap(),
              readOnly: widget.isUploadPic == true
                  ? true
                  : widget.readOnly == true
                      ? true
                      : false,
              controller: widget.textEditingController,
              // ignore: missing_return
              validator: (value) {
                if (widget.textInputType == TextInputType.emailAddress) {
                  return value.isEmpty ||
                          !value.contains("@") ||
                          !value.contains(".com")
                      ? "Please enter a valid E-mail"
                      : null;
                } else if (widget.typePassword) {
                  if (value.length < 6) {
                    return "Please enter password with more than 6 characters";
                  }
                } else if (widget.errorMessage != null) {
                  return widget.errorMessage;
                } else if (widget.textInputType == TextInputType.text) {
                  if (value.isEmpty) {
                    return 'Please enter any value';
                  }
                  //   print(value);
                  //   if (int.parse(value) < 10) {
                  //     return 'Activity Points must at least be 10 XP';
                  //   }
                  // }
                } else if (widget.textInputType == TextInputType.number &&
                    widget.isActivityPoints == true) {
                  if (value.isEmpty) {
                    return 'Please enter any value';
                  } else if (int.parse(value) < 10) {
                    return 'Activity Points must at least be 10 XP';
                  }
                } else if (widget.textInputType == TextInputType.number &&
                    widget.isTotalActivityCount == true) {
                  if (value.isEmpty) {
                    return 'Please enter any value';
                  } else if (int.parse(value) >= 10) {
                    return 'Maximum total activity is 10 activities.';
                  } else if (int.parse(value) == 0) {
                    return 'Please input a value more than 0.';
                  }
                } else if (widget.checkUploadPic) {
                  if (value.isEmpty) {
                    return 'Please select an image';
                  }
                }
              },
              onChanged: (value) => widget.onChanged(value) == null
                  ? null
                  : widget.onChanged(value),
              maxLength: widget.maxLength,
              style: widget.textFieldStyle,
              obscureText: widget.isPasswordHidden,
              initialValue: widget.initialText,
              keyboardType: widget.textInputType,
              textCapitalization: widget.textCapitalization == null
                  ? TextCapitalization.none
                  : widget.textCapitalization,
              decoration: InputDecoration(
                  suffixIcon: widget.typePassword || widget.typeConfirmPassword
                      ? IconButton(
                          icon: Icon(widget.isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              widget.isPasswordHidden =
                                  !widget.isPasswordHidden;
                            });
                          },
                          color: widget.labelStyle.color,
                        )
                      : null,
                  filled: true,
                  labelText: widget.labelText,
                  labelStyle: widget.labelStyle,
                  fillColor: widget.fillColor,
                  helperText: widget.helperText,
                  contentPadding: EdgeInsets.all(20.0),
                  isDense: false,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: kBlue2, width: 3.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: kGreenColor, width: 3.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.red, width: 3.0))),
            ),
            widget.isUploadPic == true
                ? IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: () => widget.onIconButtonTap(),
                    color: kPrimaryColor,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

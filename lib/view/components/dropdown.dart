import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';

class AppDropdownFormField extends StatelessWidget {
  final String labelText;
  final value;
  final Color fillColor;
  final TextStyle labelStyle;
  final List<String> options;
  final Function onChanged;
  const AppDropdownFormField(
      {Key key,
      this.fillColor,
      this.labelText,
      this.labelStyle,
      this.options = const [],
      @required this.onChanged,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceSizeConfig().init(context);
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
        child: DropdownButtonFormField(
          isExpanded: true,
          validator: (value) {
            if (value == '' || value == null) {
              return 'Please Select a value';
            } else {
              return null;
            }
          },
          dropdownColor: fillColor,
          icon: Icon(Icons.arrow_drop_down),
          value: value.toString(),
          onChanged: onChanged,
          items: options.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: kTextFieldStyleDark,
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            labelText: labelText,
            labelStyle: labelStyle,
            contentPadding: EdgeInsets.all(20.0),
            isDense: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: kBlue2, width: 3.0),
            ),
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
              borderSide: BorderSide(color: Colors.red, width: 3.0),
            ),
          ),
        ),
      ),
    );
  }
}

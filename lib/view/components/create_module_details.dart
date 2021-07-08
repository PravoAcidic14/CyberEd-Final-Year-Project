import 'package:flutter/material.dart';
import 'package:fyp_app_design/view/components/image_picker.dart';
import '../../constants.dart';
import 'text_field.dart';
import 'package:path/path.dart';

class CreateModuleDetails extends StatefulWidget {
  CreateModuleDetails({Key key, this.createdModuleDetails}) : super(key: key);

  final Map createdModuleDetails;

  @override
  _CreateModuleDetailsState createState() => _CreateModuleDetailsState();
}

class _CreateModuleDetailsState extends State<CreateModuleDetails> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController moduleTitleCon,
      moduleDescCon,
      ttlActLvl1Con,
      ttlActLvl2Con,
      ttlActLvl3Con,
      modulePicCon;

  Map moduleDetails = {};
  AppImagePicker _appImagePicker = AppImagePicker();
  var tempFile;

  @override
  void initState() {
    moduleTitleCon = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['moduleTitle']
            : '');

    moduleDescCon = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['moduleDesc']
            : '');

    ttlActLvl1Con = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['totalActivityLvl1']
            : '');

    ttlActLvl2Con = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['totalActivityLvl2']
            : '');

    ttlActLvl3Con = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['totalActivityLvl3']
            : '');

    modulePicCon = TextEditingController(
        text: widget.createdModuleDetails.isNotEmpty
            ? widget.createdModuleDetails['moduleDetails']['thumbnailPath']
            : '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              textEditingController: moduleTitleCon,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Module Title',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: moduleDescCon,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Module Description',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: ttlActLvl1Con,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Total Activity for Level 1',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.number,
                              isTotalActivityCount: true,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: ttlActLvl2Con,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Total Activity for Level 2',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.number,
                              isTotalActivityCount: true,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: ttlActLvl3Con,
                              textFieldStyle: kTextFieldStyleDark,
                              labelText: 'Total Activity for Level 3',
                              labelStyle: kHintStyleDark,
                              fillColor: kLightTextFieldColor,
                              textInputType: TextInputType.number,
                              isTotalActivityCount: true,
                              isPasswordHidden: false,
                              typePassword: false,
                              onTap: () {},
                            ),
                            AppTextField(
                              textEditingController: modulePicCon,
                              labelText: 'Module Thumbnail',
                              fillColor: kLightTextFieldColor,
                              labelStyle: kHintStyleDark,
                              textFieldStyle: kTextFieldStyleDark,
                              isUploadPic: true,
                              checkUploadPic: true,
                              onIconButtonTap: () async {
                                tempFile = await _appImagePicker.openGallery();
                                setState(() {
                                  modulePicCon.text = basename(tempFile.path);
                                });

                              },
                              onTap: () async {
                                tempFile = await _appImagePicker.openGallery();
                                setState(() {
                                  modulePicCon.text = basename(tempFile.path);
                                });

                              },
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_key.currentState.validate()) {
                                      print(moduleTitleCon.text);
                                      moduleDetails['moduleTitle'] =
                                          moduleTitleCon.text;
                                      moduleDetails['moduleDesc'] =
                                          moduleDescCon.text;
                                      moduleDetails['totalActivityLvl1'] =
                                          ttlActLvl1Con.text;
                                      moduleDetails['totalActivityLvl2'] =
                                          ttlActLvl2Con.text;
                                      moduleDetails['totalActivityLvl3'] =
                                          ttlActLvl3Con.text;
                                      moduleDetails['thumbnailPath'] =
                                          tempFile.path;

                                      Navigator.pop(context, moduleDetails);
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

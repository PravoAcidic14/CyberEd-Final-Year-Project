import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/model/advisor_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvisorController {
  AdvisorUser _advisorUser = AdvisorUser();
  SharedPreferences _sharedPreference;
  StorageController _storageController = StorageController();

  Future<bool> advisorSignIn(
      String matricsId, String password, BuildContext context) async {
    bool isLogIn;

    await checkMatricsId(matricsId).then((value) async {
      if (value == true) {
        print('user exist');
        isLogIn = await checkPassword(matricsId, password, context);
      } else {
        print('user dont exist');
        isLogIn = false;
      }
    });

    print('this is the status ' + isLogIn.toString());
    return isLogIn;
  }

  Future<bool> checkMatricsId(String matricsId) async {
    bool userExist;
    userExist = await _advisorUser.checkMatricsId(matricsId);
    return userExist;
  }

  Future<bool> checkPassword(
      String matricsId, String password, BuildContext context) async {
    String realPassword;
    _sharedPreference = await SharedPreferences.getInstance();
    realPassword = await _advisorUser.getAdvisorPassword(matricsId);

    if (password == realPassword) {
      print('Success Sign in');
      _sharedPreference.setBool('advisorLoggedIn', true);
      _sharedPreference.setString('advisorMatricsId', matricsId);
      Navigator.pushNamed(context, '/advisor-home');
      return true;
    } else {
      print('Failed Sign in');
      return false;
    }
  }

  Future<Map> getAdvisorData(String matricsId) async {
    Map userData = await _advisorUser.getAdvisorData(matricsId);
    return userData;
  }

  Future<String> updateAdvisorData(Map userData, String matricsId) async {
    try {
      _advisorUser.updateAdvisor(userData: userData, matricsId: matricsId);

      return "Student Details updated successfully";
    } catch (e) {
      return Future.error(
          "Student Details cannot be updated. Please try again later");
    }
  }

  Future sendAdvisorDataToUpdate(File avatarImage,
      Map<dynamic, dynamic> thingsToUpdate, String matricsId) async {
    var tempImageUrl = "";
    if (avatarImage != null) {
      tempImageUrl = await _storageController
          .updateAdvisorProfileImage(matricsId, avatarImage)
          .catchError((error) {
        return "Image cannot be updated. An error has occured.";
      });
    }

    thingsToUpdate['avatarUrl'] = tempImageUrl;
    print(thingsToUpdate);
    await updateAdvisorData(thingsToUpdate, matricsId).then((value) {
      return "Success";
    }).catchError((error) {
      return error.toString();
    });
  }
}

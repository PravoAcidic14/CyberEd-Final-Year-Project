import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';

import 'dart:async';

class StudentHomeController {
  StorageController _storageController = StorageController();
  UserController _userController = UserController();
  ModuleController _moduleController = ModuleController();
  User _user = FirebaseAuth.instance.currentUser;

  

  Future<List> getRecommendedModuleDisplay() async {
    List recommendedModuleList = [];
    List moduleContentDisplay = [];

    recommendedModuleList = await _userController.getUserFirstAdaptiveScoreModuleList();

    for (var i = 0; i < recommendedModuleList.length; i++) {
      Map moduleThumbnail = {"moduleId": recommendedModuleList[i]};
      Map moduleContent =
          await _moduleController.getModuleContent(recommendedModuleList[i]);

      moduleThumbnail["moduleId"] = recommendedModuleList[i];
      moduleThumbnail["thumbnailUrl"] = moduleContent["thumbnailUrl"];
      moduleThumbnail["moduleTitle"] = moduleContent["moduleTitle"];

      moduleContentDisplay..add(moduleThumbnail);
    }
    print(recommendedModuleList);
    return moduleContentDisplay;
  }

  Future<List> getAllModuleDisplay() async {
    List allModuleList = [];
    List moduleContentDisplay = [];

    allModuleList = await _moduleController.getAllModules();

    for (var i = 0; i < allModuleList.length; i++) {
      Map moduleThumbnail = {"moduleId": allModuleList[i]};
      Map moduleContent =
          await _moduleController.getModuleContent(allModuleList[i]);

      moduleThumbnail["moduleId"] = allModuleList[i];
      moduleThumbnail["thumbnailUrl"] = moduleContent["thumbnailUrl"];
      moduleThumbnail["moduleTitle"] = moduleContent["moduleTitle"];

      moduleContentDisplay..add(moduleThumbnail);
    }
    return moduleContentDisplay;
  }

  Future sendStudentDataToUpdate(
      File avatarImage, Map<dynamic, dynamic> thingsToUpdate) async {
    var tempImageUrl = "";
    if (avatarImage != null) {
      tempImageUrl = await _storageController
          .updateUserProfileImage(_user, avatarImage)
          .catchError((error) {
        return "Image cannot be updated. An error has occured.";
      });
    }

    thingsToUpdate.putIfAbsent("avatarUrl", () => tempImageUrl);
    print(thingsToUpdate);
    await _userController.updateStudent(thingsToUpdate).then((value) {
      return "Success";
    }).catchError((error) {
      return error.toString();
    });
  }
}

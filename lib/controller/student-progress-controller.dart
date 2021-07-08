import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';

class StudentProgressController {
  UserController _userController = UserController();
  ModuleController _moduleController = ModuleController();

  Future<Map> getProgressData() async {
    Map userData = await _userController.getUserStudentData();
    Map completedModuleWithStatusMap = userData['completionStatus'];
    return completedModuleWithStatusMap;
  }

  double getAmountOfCompletion(Map completionData, String moduleId) {
    Map tempValue = {};
    List completionStatus = [];
    int noOfCompleted = 0;
    tempValue = completionData[moduleId];
    tempValue.forEach((key, value) {
      completionStatus = value;
    });
    completionStatus.every((element) {
      if (element == 'completed') {
        noOfCompleted = noOfCompleted + 1;
        return true;
      } else {
        return false;
      }
    });

    double percentage =
        (noOfCompleted / completionStatus.length) * 100.toDouble();
    double roundedOffPercentage = double.parse(percentage.toStringAsFixed(0));
    return roundedOffPercentage;
  }

  String convertDoubleToIntPercentage(Map completionData, String moduleId) {
    double percentage = getAmountOfCompletion(completionData, moduleId);
    int intVersion = percentage.toInt();
    return intVersion.toString() + ' %';
  }

  Future<Map> getModuleTitle() async {
    Map moduleAndTitle = {};
    Map moduleContent = await _moduleController.getAllModuleDetails();
    moduleContent.forEach((key, value) {
      moduleAndTitle.putIfAbsent(key, () => value['moduleTitle']);
    });
    return moduleAndTitle;
  }

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.blueGrey,
    Colors.pink
  ];

  Map matchColorWithCompletedModule(List completedModule) {
    Map colorAndModule = {};
    for (var i = 0; i < completedModule.length; i++) {
      colorAndModule.putIfAbsent(completedModule[i], () => colors[i]);
    }
    return colorAndModule;
  }

  Future<List> getBadgeList() async {
    List unlockedBadgesList = [];
    Map unlockedBadges = await _userController.getUnlockedBadges();
    if (unlockedBadges != null) {
      unlockedBadgesList = unlockedBadges['modulesCompletedBadges'];
    }
    return unlockedBadgesList;
  }
}

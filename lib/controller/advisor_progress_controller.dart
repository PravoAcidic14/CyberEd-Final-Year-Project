import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';

class AdvisorProgressController {
  UserController _userController = UserController();
  ModuleController _moduleController = ModuleController();

  Future<List> getStudentData() async {
    return await _userController.getAllStudentId();
  }

  Future<List> getStudentAdaptiveScores(String moduleId) async {
    int incomplete = 0, improved = 0, noChanges = 0, worsen = 0, totalCount;
    List rawStats = [], allPercentage = [];
    List allStudentId = await getStudentData();
    Map studentScore = {};
    totalCount = allStudentId.length;

    for (int i = 0; i < allStudentId.length; i++) {
      studentScore = await _userController.getStudentAdaptiveScores(
          moduleId, allStudentId[i]);
      print(studentScore);

      if (studentScore == null) {
        incomplete = incomplete + 1;
      } else {
        if (studentScore.length == 1 || studentScore.isEmpty) {
          incomplete = incomplete + 1;
        } else {
          if (studentScore['firstAdaptiveScore'] >
              studentScore['lastAdaptiveScore']) {
            improved = improved + 1;
          } else if (studentScore['firstAdaptiveScore'] <
              studentScore['lastAdaptiveScore']) {
            worsen = worsen + 1;
          } else if (studentScore['firstAdaptiveScore'] ==
              studentScore['lastAdaptiveScore']) {
            noChanges = noChanges + 1;
          }
        }
      }
    }

    // allStudentId.forEach((element) async {
    //   await _userController.getStudentAdaptiveScores(moduleId, element).then((value) {
    //     if (value.length == 1) {
    //       ++incomplete;
    //     } else {
    //       if (int.parse(value['firstAdaptiveScore']) >
    //           int.parse(value['lastAdaptiveScore'])) {
    //         ++improved;
    //       } else if (int.parse(value['firstAdaptiveScore']) <=
    //           int.parse(value['lastAdaptiveScore'])) {
    //         ++worsen;
    //       }
    //     }
    //   });
    // });

    rawStats = [incomplete, improved, noChanges, worsen, totalCount];
    print(rawStats);

    for (var i = 0; i < 4; i++) {
      double percentage = rawStats[i] / rawStats[4] * 100;
      double roundedOffPercentage = double.parse(percentage.toStringAsFixed(0));
      allPercentage.insert(i, roundedOffPercentage);
    }

    allPercentage.add(totalCount);

    return allPercentage;
  }

  String convertDoubleToText(double percentage) {
    int intVersion = percentage.toInt();
    return intVersion.toString() + ' %';
  }

  Future<Map<String, String>> getModuleTitle() async {
    List allModuleId = await _moduleController.getAllModules();
    Map<String, String> allModuleTitle = {};

    for (var i = 0; i < allModuleId.length; i++) {
      var moduleContent =
          await _moduleController.getModuleContent(allModuleId[i]);

      allModuleTitle
        ..putIfAbsent(allModuleId[i], () => moduleContent['moduleTitle']);
    }
    // allModuleId.forEach((element) {
    //   _moduleController.getModuleContent(element).then((value) {
    //     allModuleTitle.add(value);
    //   });
    // });
    return allModuleTitle;
  }
}

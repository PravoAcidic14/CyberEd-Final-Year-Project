
import 'package:fyp_app_design/controller/activity_controller.dart';
import 'package:fyp_app_design/controller/adaptive_learning_controller.dart';
import 'package:fyp_app_design/controller/module_controller.dart';

class CreateNewModule {

  ModuleController moduleCon = ModuleController();
  AdaptiveLearningController adaptiveLearningController =
      AdaptiveLearningController();
  ActivityController activityCon = ActivityController();
  List allModuleId = [];

  Future startTransaction(Map moduleDetails, Map adaptiveQuiz, Map activityLvl1,
      Map activityLvl2, Map activityLvl3) async {
    String newModuleId = await getNewModuleId();

    await moduleCon.createNewModule(moduleDetails, newModuleId);
  print('MODULE DETAILS DONE');
    await adaptiveLearningController.createNewAdaptiveSet(
        adaptiveQuiz, newModuleId);
print('ADAPTIVE SET DONE');
    await activityCon.createNewActivity(activityLvl1, 1, newModuleId);
print('ACTIVITY LVL 1 DONE');
    await activityCon.createNewActivity(activityLvl2, 2, newModuleId);
print('ACTIVITY LVL 2 DONE');
    await activityCon.createNewActivity(activityLvl3, 3, newModuleId);
print('ACTIVITY LVL 3 DONE');
    // print('Module Details');
    // print(moduleDetails);
    // print('Adaptive Quiz');
    // print(adaptiveQuiz);
    // print('Activity Level 1');
    // print(activityLvl1);
    // print('Activity Level 2');
    // print(activityLvl2);
    // print('Activity Level 3');
    // print(activityLvl3);
  }

  Future<String> getNewModuleId() async {
    allModuleId = await moduleCon.getAllModules();
    print(allModuleId);
    int idCount = allModuleId.length + 1;

    String newId = 'M' + idCount.toString().padLeft(3, '0');
    print(newId);
    return newId;
  }
}

import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/controller/game_controller.dart';
import 'package:fyp_app_design/view/selected_adaptive_quiz.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/model/activity.dart';

class ActivityController {
  UserController _userController = UserController();
  ActivityModel _activityModel = ActivityModel();
  StorageController _storageController = StorageController();
  GameController _gameController = GameController();
  List _activityList = [];

  Future<Map> matchOldAdaptiveScoreToModule() async {
    Map oldAdaptiveScore = await _userController.getUserAdaptiveScores();
    return oldAdaptiveScore;
  }

  // ignore: missing_return
  Future<List> getActivityLevel(
      String moduleId, Map oldAdaptiveScore, BuildContext context) async {
    bool firstScorePresence;
    List _activity = [], _activityStatus = [];
    // Map oldScores = {};
    var level;

    print(moduleId);
    print(oldAdaptiveScore);

    if (oldAdaptiveScore.isNotEmpty) {
      if (oldAdaptiveScore.containsKey(moduleId)) {
        //check the presence of first score
        firstScorePresence =
            await _userController.checkFirstScorePresence(moduleId);

        // print('this is first score presence ' + firstScorePresence.toString());

        //if first score is present, continue to load the activities.
        if (firstScorePresence == true) {
          level = await oldAdaptiveScore[moduleId];
          level += 1;

          // print(level);

          _activity = await _activityModel.getModuleActivity(
              moduleId, level.toString());

          // print(_activity);

          //get the availability status of each activity
          var levelString = "level$level";

          // print(levelString);
          // print(_activity.length);

          _activityStatus = await _userController.getActivityAvailability(
              moduleId, levelString, _activity.length);

          print(_activityStatus);

          for (var i = 0; i < _activity.length; i++) {
            _activity[i]
                .putIfAbsent("activityListLength", () => _activity.length);
            _activity[i].putIfAbsent("activityId", () => i);
            _activity[i].putIfAbsent("moduleId", () => moduleId);
            _activity[i].putIfAbsent("level", () => levelString);
            _activity[i]
                .putIfAbsent("activityStatus", () => _activityStatus[i]);
          }
          // print(_activity);
          return _activity;
        }
      } else if (!oldAdaptiveScore.containsKey(moduleId)) {
        print('no first score');
        return [];
      }
    }
  }

  Future<List> getActivityByLevel(String moduleId, int level) async {
    _activityList =
        await _activityModel.getModuleActivity(moduleId, level.toString());

    return _activityList;
  }

  Future<Map> checkCompletionStatus() async {
    Map userCompletionStatus = {}, tempMap = {};
    tempMap = await _userController.getUserStudentData();

    userCompletionStatus = tempMap["completionStatus"];
    print(userCompletionStatus);
    return userCompletionStatus;
  }

  Future badgeToUnlock(String moduleId, BuildContext context) async {
    //check if user already unlocked any badge
    bool anyUnlockedBadge;
    int unlockedModuleCompletedBadgeAmount;
    List unlockedModules = [];
    anyUnlockedBadge = await _userController.checkAnyUserUnlockedBadge();

    if (anyUnlockedBadge == false) {
      unlockModuleCompletedBadge(1, moduleId, context);
    } else if (anyUnlockedBadge == true) {
      unlockedModules = await _userController.getUnlockedModulesForBadge();

      if (unlockedModules.contains(moduleId) == false) {
        unlockedModuleCompletedBadgeAmount =
            await _userController.checkAmountOfModuleCompletedBadge();
        switch (unlockedModuleCompletedBadgeAmount) {
          case 1:
            unlockModuleCompletedBadge(2, moduleId, context);
            break;
          case 2:
            unlockModuleCompletedBadge(3, moduleId, context);
            break;
          default:
        }
      }
    }
  }

  Future unlockModuleCompletedBadge(
      int i, String moduleId, BuildContext context) async {
    await _userController.createNewModuleCompletedBadge(i, moduleId, context);
  }

  Future createNewActivity(
      Map activityDetails, int level, String moduleId) async {
    for (var i = 0; i < activityDetails.length; i++) {
      Map currentActivity = activityDetails['activity${i + 1}'];

      if (currentActivity['activityType'] == 'Video') {
        _activityModel.createVideoActivity(currentActivity, level, i, moduleId);
      } else if (currentActivity['activityType'] == 'Slides') {
        String slidesUrl = await _storageController.uploadNewModuleMaterial(
            currentActivity['slidesPath'], moduleId, level);
        currentActivity['slidesUrl'] = slidesUrl;

        _activityModel.createSlidesActivity(
            currentActivity, level, i, moduleId);
      } else if (currentActivity['activityType'] == 'Poster') {
        String posterUrl = await _storageController.uploadNewModuleMaterial(
            currentActivity['posterPath'], moduleId, level);
        currentActivity['posterUrl'] = posterUrl;

        _activityModel.createPosterActivity(
            currentActivity, level, i, moduleId);
      } else if (currentActivity['activityType'] == 'Game') {
        print(currentActivity);
        print('gonna create game content data now');

        if (currentActivity['gameType'] == 'Draggable Game') {
          String newGameId = await _gameController
              .createNewDraggableGame(currentActivity['gameContent']);
          // print(newGameId + ' about to create game activity now');

          _activityModel.createDraggableGameActivity(
              currentActivity, level, i, moduleId, newGameId);
        } else if (currentActivity['gameType'] == 'Guess The Word Game') {
          String newGameId = await _gameController
              .createNewGuessGame(currentActivity['gameContent']);

          _activityModel.createGuessGameActivity(
              currentActivity, level, i, moduleId, newGameId);
        }
      }
    }
  }

  Future updateActivityDetails(Map newActivityDetails, File activityPDF) async {
    if (activityPDF != null) {
      print('pdf exist');
      print(newActivityDetails);

      String pdfUrl;
      await _storageController
          .updateActivityPDF(newActivityDetails, activityPDF)
          .then((value) {
        print('this is new url' + value);
        pdfUrl = value;
      });

      newActivityDetails['pdfUrl'] = pdfUrl;
      newActivityDetails['basenameWithoutExtension'] =
          basenameWithoutExtension(activityPDF.path);
    }
    print('pdf dont exist');
    return await _activityModel.updateActivity(newActivityDetails);
  }
}

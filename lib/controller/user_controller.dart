import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fyp_app_design/model/users.dart';

class UserController {
  Student _student = Student(FirebaseAuth.instance.currentUser);
  Map userMap, adaptiveMap, userOldAdaptiveScore = {};
  Map tempMap = {};
  List tempList = [];
  bool presence, completeReg;
  String userFirstName, returnValue;
  Stream stream;

  Future<String> updateStudent(Map<dynamic, dynamic> studentDetails) async {
    try {
      _student.updateStudent(
        firstName: studentDetails["firstName"],
        lastName: studentDetails["lastName"],
        email: studentDetails["email"],
        avatarUrl: studentDetails["avatarUrl"],
        ageRange: studentDetails["ageRange"],
      );

      return "Student Details updated successfully";
    } catch (e) {
      return Future.error(
          "Student Details cannot be updated. Please try again later");
    }
  }

  Future<Map> getUserStudentData() async {
    userMap = await _student.getStudentData();
    return userMap;
  }

  Future getAllStudentId() async {
    return await _student.getAllStudentId();
  }

  Future getStudentAdaptiveScores(String moduleId, String studentId) async {
    return await _student.getStudentAdaptiveScores(moduleId, studentId);
  }

  Future<Map> getUserAdaptiveScores() async {
    Map userData = {};

    userData = await _student.getStudentData();

    Map adaptiveModule = userData["adaptiveScores"];

    for (var item in adaptiveModule.keys) {
      int score = await _student.getStudentOldAdaptiveScore(item);
      tempList..add(score);
    }

    userOldAdaptiveScore = Map.fromIterables(adaptiveModule.keys, tempList);
    return userOldAdaptiveScore;
  }

  Future<List> getUserFirstAdaptiveScoreModuleList() async {
    Map userData = await _student.getStudentData();
    List personalModules = [];

    personalModules = userData['adaptiveScores'].keys.toList();
    return personalModules;
  }

  Future<bool> checkFirstScorePresence(String moduleId) async {
    Map userData = {};

    userData = await _student.getStudentData();

    if (userData["adaptiveScores"][moduleId]['firstAdaptiveScore'] != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkLastScorePresence(String moduleId) async {
    Map userData = {};

    userData = await _student.getStudentData();

    if (userData["adaptiveScores"][moduleId]['lastAdaptiveScore'] != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkAnyUserUnlockedBadge() async {
    Map userData = {};

    userData = await _student.getStudentData();

    if (userData['unlockedBadges'] == null) {
      print('Its null');
      return false;
    } else {
      print('Its not null');
      return true;
    }
  }

  Future<Map> getUnlockedBadges() async {
    Map unlockedBadgesData = {};

    unlockedBadgesData = await _student.getUnlockedBadges();
    return unlockedBadgesData;
  }

  Future<List> getUnlockedModulesForBadge() async {
    List unlockedModules = [];
    Map unlockedBadgesData = {};

    unlockedBadgesData = await getUnlockedBadges();

    unlockedModules = unlockedBadgesData['modulesCompleted'];
    return unlockedModules;
  }

  Future<int> checkAmountOfModuleCompletedBadge() async {
    Map userData = {};
    List modulesCompletedBadges = [];
    userData = await _student.getStudentData();

    modulesCompletedBadges =
        userData['unlockedBadges']['modulesCompletedBadges'];
    return modulesCompletedBadges.length;
  }

  Future createNewModuleCompletedBadge(
      int i, String moduleId, BuildContext context) async {

Map arguments = {'badgeId' : 'moduleComplete' + i.toString(), 'moduleId' : moduleId};

    await _student.createModuleCompletedBadge(i, moduleId).whenComplete(() {
      Navigator.pushNamed(context, '/badge-unlocked',
          arguments: arguments);
    });
  }

  Future<List> getActivityAvailability(
      String moduleId, String level, int activitylength) async {
    Map userData = {};
    List activityStatus = [];

    print("about to get activity availability");
    

    userData = await _student.getStudentData();

    print(userData);

    if (userData.containsKey('completionStatus')) {
      Map completionStatus = userData['completionStatus'];

      if (completionStatus.containsKey(moduleId)) {
        print(userData["completionStatus"][moduleId]);
        activityStatus = userData["completionStatus"][moduleId][level];
      } else {
        print('completion status is null');
        activityStatus =
            await createCompletionStatus(moduleId, level, activitylength);
      }
    } else {
      activityStatus = await createCompletionStatus(moduleId, level, activitylength);
    }

    // print(activityStatus);

    return activityStatus;
  }

  Future createCompletionStatus(
      String moduleId, String level, int activityLength) async {
    List completionStatus =
        await _student.createCompletionStatus(moduleId, level, activityLength);
    return completionStatus;
  }

  Stream<Event> getTotalPoints() {
    return _student.listenToTotalPoints();
  }

  Future<bool> getStudentAdaptiveScorePresence(User uid) async {
    adaptiveMap = await _student.checkAdaptiveAnswerPresence(uid);
    if (adaptiveMap != null) {
      presence = true;
      return presence;
    } else {
      presence = false;
      return presence;
    }
  }

  Future<bool> getStudentRegistrationCompletion() async {
    try {
      await getUserStudentData();
      if (userMap['firstName'] != null) {
        completeReg = true;
        return completeReg;
      } else {
        completeReg = false;
        return completeReg;
      }
    } catch (e) {
      print('Registration Incomplete');
      completeReg = false;
      return completeReg;
    }
  }

  // ignore: missing_return
  Future completeActivity(
      {int activityId,
      int activityListLength,
      int activityPoints,
      String moduleId,
      String level}) async {
    if (activityId != activityListLength - 1) {
      print(activityId);
      print(activityListLength.toString() + ' length');
      //mark the status of the activityId as completed and unlock the next one
      await _student
          .updateActivityCompleted(activityId, activityPoints, moduleId, level)
          .whenComplete(() =>
              _student.updateActivityUnlocked(activityId + 1, moduleId, level))
          .catchError((onError) {
        print(onError.toString());
        return onError.toString();
      });
    } else {
      //mark the status of the activityId as completed
      print('last activity');
      await _student
          .updateActivityCompleted(activityId, activityPoints, moduleId, level)
          .catchError((onError) {
        print(onError.toString());
        return onError.toString();
      });

      return true;
    }
  }
}

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Student {
  final studentRef =
      FirebaseDatabase.instance.reference().child('users').child('students');
  User _user = FirebaseAuth.instance.currentUser;
  var snapshot;

  Student(this._user);

  Future<CoolAlert> createNewStudent(
      {BuildContext context,
      String firstName,
      String lastName,
      String avatarUrl,
      String ageRange,
      GestureTapCallback onConfirmBtnTap}) async {
    try {
      await studentRef.child(_user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'ageRange': ageRange,
        'email': _user.email,
        'avatarUrl': avatarUrl,
        'totalPoints': 0,
      });
      return CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Your Profile Has Been Created Successfully',
        onConfirmBtnTap: onConfirmBtnTap,
      );
    } on FirebaseException catch (e) {
      return CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
    }
  }

  Future<String> updateStudent({
    String firstName,
    String lastName,
    String email,
    String avatarUrl,
    String ageRange,
  }) async {
    try {
      if (avatarUrl == "") {
        await studentRef.child(_user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'ageRange': ageRange,
          'email': email,
        });
        return Future.value("Student Details updated successfully");
      } else {
        await studentRef.child(_user.uid).update({
          'firstName': firstName,
          'lastName': lastName,
          'ageRange': ageRange,
          'email': email,
          'avatarUrl': avatarUrl,
        });
        return Future.value("Student Details updated successfully");
      }
    } on FirebaseException {
      return Future.error("Student Details cannot be updated");
    }
  }

  Future<String> updateStudentWithoutImage({
    String firstName,
    String lastName,
    String email,
    String ageRange,
  }) async {
    try {
      await studentRef.child(_user.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'ageRange': ageRange,
        'email': email,
      });
      return "Student Details updated successfully";
    } on FirebaseException {
      return Future.error("Student Details cannot be updated");
    }
  }

  Future updatePoints(int activityPoints) async {
    int newTotalPoints;
    try {
      await studentRef
          .child(_user.uid)
          .child('totalPoints')
          .once()
          .then((value) {
        newTotalPoints = value.value + activityPoints;
      });
      if (newTotalPoints != null) {
        await studentRef
            .child(_user.uid)
            .child('totalPoints')
            .set(newTotalPoints);
      }
    } on FirebaseException {}
  }

  Future updateActivityCompleted(
      int activityId, int activityPoints, String moduleId, String level) async {
    try {
      await studentRef
          .child(_user.uid)
          .child('completionStatus')
          .child(moduleId)
          .child(level)
          .update({activityId.toString(): "completed"}).whenComplete(() {
        updatePoints(activityPoints);
      });
    } on FirebaseException catch (e) {
      print(e.message);
      return Future.error('An error has occured. Please try again later');
    }
  }

  Future updateActivityUnlocked(
      int activityId, String moduleId, String level) async {
    try {
      await studentRef
          .child(_user.uid)
          .child('completionStatus')
          .child(moduleId)
          .child(level)
          .update({activityId.toString(): "unlocked"});
    } on FirebaseException {
      return Future.error('An error has occured. Please try again later');
    }
  }

  Future<Map> getUnlockedBadges() async {
    DataSnapshot snapshot =
        await studentRef.child(_user.uid).child('unlockedBadges').once();
    return snapshot.value;
  }

  Future createModuleCompletedBadge(int i, String moduleId) async {
    print("about to save in db edy");
    try {
      await studentRef
          .child(_user.uid)
          .child('unlockedBadges')
          .child('modulesCompletedBadges')
          .child((i - 1).toString())
          .set('moduleComplete' + i.toString());
      await studentRef
          .child(_user.uid)
          .child('unlockedBadges')
          .child('modulesCompleted')
          .child((i - 1).toString())
          .set(moduleId);
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future createStudentOldAdaptiveScore(String moduleId, int oldScore) async {
    try {
      await studentRef
          .child(_user.uid)
          .child('adaptiveScores')
          .child(moduleId)
          .child('firstAdaptiveScore')
          .set(oldScore);
      print('old score added');
    } on FirebaseException catch (e) {
      Future.error(e.message);
    }
  }

  Future createStudentNewAdaptiveScore(String moduleId, int newScore) async {
    print('addaing new score now');
    try {
      await studentRef
          .child(_user.uid)
          .child('adaptiveScores')
          .child(moduleId)
          .child('lastAdaptiveScore')
          .set(newScore);
      print('new score added');
    } on FirebaseException catch (e) {
      Future.error(e.message);
    }
  }

  Future getStudentAdaptiveScores(String moduleId, String studentId) async {
    DataSnapshot dataSnapshot = await studentRef
        .child(studentId)
        .child("adaptiveScores")
        .child(moduleId)
        .once();

    return dataSnapshot.value;
  }

  Future getStudentOldAdaptiveScore(String moduleId) async {
    DataSnapshot dataSnapshot = await studentRef
        .child(_user.uid)
        .child("adaptiveScores")
        .child(moduleId)
        .child("firstAdaptiveScore")
        .once();

    return dataSnapshot.value;
  }

  Future getStudentNewAdaptiveScore(String moduleId) async {
    DataSnapshot dataSnapshot = await studentRef
        .child(_user.uid)
        .child("adaptiveScores")
        .child(moduleId)
        .child("firstAdaptiveScore")
        .once();

    return dataSnapshot.value;
  }

  Future<List> getAllStudentId() async {
    List allStudentId = [];
    await studentRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> modules = snapshot.value;
      modules.forEach((key, value) {
        allStudentId = modules.keys.toList();
      });
    });
    return allStudentId;
  }

  //read user data
  Future getStudentData() async {
    DataSnapshot dataSnapshot = await studentRef.child(_user.uid).once();
    return dataSnapshot.value;
  }

  Future checkAdaptiveAnswerPresence(User user) async {
    DataSnapshot dataSnapshot =
        await studentRef.child(user.uid).child('adaptiveScores').once();
    return dataSnapshot.value;
  }

  Stream<Event> listenToTotalPoints() {
    return studentRef.child(_user.uid).child('totalPoints').onValue;
  }

  Future<List> createCompletionStatus(
      String moduleId, String level, int activityLength) async {
    Map completionData = {};
    for (var i = 0; i < activityLength; i++) {
      if (i == 0) {
        completionData[i.toString()] = "unlocked";
        // await studentRef
        //     .child(_user.uid)
        //     .child('completionStatus')
        //     .child(moduleId)
        //     .child(level)
        //     .set({i.toString(): 'unlocked'});
      } else {
        completionData[i.toString()] = "locked";
        // await studentRef
        //     .child(_user.uid)
        //     .child('completionStatus')
        //     .child(moduleId)
        //     .child(level)
        //     .set({i.toString(): 'locked'});
      }
    }
    await studentRef
        .child(_user.uid)
        .child('completionStatus')
        .child(moduleId)
        .child(level)
        .set(completionData);
    DataSnapshot snapshot = await studentRef
        .child(_user.uid)
        .child('completionStatus')
        .child(moduleId)
        .child(level)
        .once();
    return snapshot.value;
  }
}

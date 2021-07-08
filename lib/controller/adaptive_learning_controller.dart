import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_app_design/controller/module_controller.dart';
import 'package:fyp_app_design/model/adaptive_learning.dart';
import 'dart:async';

import 'package:fyp_app_design/model/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdaptiveLearningController {
  AdaptiveLearningModel _adaptiveLearning = AdaptiveLearningModel();
  Student _students = Student(FirebaseAuth.instance.currentUser);
  ModuleController _moduleController = ModuleController();
  List finalAS = [];
  List<String> modules = [];
  Map<int, int> answers = Map();
  bool _isAnswered = false;
  int questionIndex = 0;

  Future createNewAdaptiveSet(Map adaptiveSet, String moduleId) async {
    print(adaptiveSet);
    for (var i = 1; i <= adaptiveSet['totalSetNum']; i++) {
      int answerIndex = adaptiveSet['adaptiveSets']['set$i']['options']
          .indexOf(adaptiveSet['adaptiveSets']['set$i']['answer']);
      adaptiveSet['adaptiveSets']['set$i']['answerIndex'] = answerIndex;

      _adaptiveLearning.createNewAdaptiveSet(
          adaptiveSet['adaptiveSets']['set$i'], moduleId, i);
    }
  }

  Future<List> getAllModules() async {
    modules = List<String>.from(await _moduleController.getAllModules());

    if (modules.length >= 3) {
      modules.shuffle();
      List<String> newModule = modules.sublist(0, 3);
      print('sublist $newModule');
      setModuleSharedPref(newModule);
      return newModule;
    } else {
      setModuleSharedPref(modules);
      return modules;
    }
  }

  Future<void> setModuleSharedPref(List<String> moduleList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('moduleList', moduleList);
  }

  Future<List> populateList() async {
    if (modules.isEmpty) {
      modules = await getAllModules().whenComplete(() => populateList());
    } else {
      if (modules.length == 1) {
        finalAS = await getSingleModuleAdaptiveSet();
      } else if (modules.length == 2) {
        finalAS = await getTwoModuleAdaptiveSet();
      } else if (modules.length >= 3) {
        finalAS = await getThreeModuleAdaptiveSet();
      }
    }

    return finalAS;
  }

  Future<List> getAdaptiveQuestionsByModule(String moduleId) async {
    List adaptiveSetById = [];

    adaptiveSetById = await _adaptiveLearning.getAdaptiveSet(moduleId);
    return adaptiveSetById;
  }

  bool checkAnswer(int selectedIndex, int answerIndex) {
    //create a variable to note correct or wrong answers temporarily
    int tempAnswer;

    //check if answer is correct
    if (selectedIndex == answerIndex) {
      tempAnswer = 1;
      storeAnswers(tempAnswer);
      _isAnswered = true;
      return _isAnswered;
    } else {
      tempAnswer = 0;
      storeAnswers(tempAnswer);
      _isAnswered = false;
      return _isAnswered;
    }
  }

  void storeAnswers(int tempAnswer) {
    //create the map for every index;

    answers.putIfAbsent(questionIndex, () => tempAnswer);
    questionIndex++;
  }

  Future<List> getTwoModuleAdaptiveSet() async {
    List adaptiveSet = [], adaptiveSet2 = [];

    adaptiveSet = await _adaptiveLearning.getAdaptiveSet(modules[0]);
    adaptiveSet2 = await _adaptiveLearning.getAdaptiveSet(modules[1]);

    var combinedList = new List.from(adaptiveSet)..addAll(adaptiveSet2);
    return combinedList;
  }

  Future<List> getSingleModuleAdaptiveSet() async {
    List adaptiveSet = [];
    adaptiveSet = await _adaptiveLearning.getAdaptiveSet(modules[0]);
    return adaptiveSet;
  }

  Future<List> getThreeModuleAdaptiveSet() async {
    List adaptiveSet = [], adaptiveSet2 = [], adaptiveSet3 = [];

    adaptiveSet = await _adaptiveLearning.getAdaptiveSet(modules[0]);
    adaptiveSet2 = await _adaptiveLearning.getAdaptiveSet(modules[1]);
    adaptiveSet3 = await _adaptiveLearning.getAdaptiveSet(modules[2]);

    var combinedList = new List.from(adaptiveSet)
      ..addAll(adaptiveSet2)
      ..addAll(adaptiveSet3);
    return combinedList;
  }

  Future calcScore(List modulesForScore, bool isLastScore) async {
    //
    int mapIndex = 0;
    print(modulesForScore);
    //for loop for the total number of modules
    for (var i = 0; i < modulesForScore.length; i++) {
      //create a new list and int
      List answersPerModule = [];
      int modulesQuestionQuantity;

      //get adaptive quantity of questions in a module
      await getASQuantity(modulesForScore[i]).then((value) {
        modulesQuestionQuantity = value;
      });

      //for loop for the number of questions in a module
      for (var j = 0; j < modulesQuestionQuantity; j++) {
        var answerAtIndex = answers[mapIndex];
        answersPerModule.add(answerAtIndex);
        answers.remove(mapIndex);
        mapIndex++;
      }

      var moduleFirstScore = checkScorePercentage(answersPerModule);

      if (isLastScore == false) {
        print('is first score');
        await _students.createStudentOldAdaptiveScore(
            modulesForScore[i], moduleFirstScore);
        print('first score saved');
      } else {
        print('is last score');
        await _students.createStudentNewAdaptiveScore(
            modulesForScore[i], moduleFirstScore);

            print('last score saved');
      }
    }
  }



  // ignore: missing_return
  int checkScorePercentage(List numOfQuestions) {
    int scoreFrequency = 0;
    numOfQuestions.forEach((element) {
      if (element == 1) {
        scoreFrequency++;
      }
    });

    if (numOfQuestions.length == 2) {
      if (scoreFrequency == 0) {
        return 0;
      } else if (scoreFrequency == 1) {
        return 1;
      } else if (scoreFrequency == 2) {
        return 2;
      }
    } else if (numOfQuestions.length == 3) {
      //if scoreFrequency is 1, score value is 0.75 which is rounded off to 1
      //if scoreFrequency is 2, score value is 1.5 which is rounded off to 2
      //if scoreFrequency is 3, score value is 2.25 which is rounded off to 2
      if (scoreFrequency == 0) {
        return 0;
      } else if (scoreFrequency == 1) {
        return 1;
      } else if (scoreFrequency == 2 || scoreFrequency == 3) {
        return 2;
      }
    } else if (numOfQuestions.length == 4) {
      //if scoreFrequency is 1, score value is 0.6 which is rounded off to 1
      //if scoreFrequency is 2, score value is 1.2 which is rounded off to 1
      //if scoreFrequency is 3, score value is 1.8 which is rounded off to 2
      //if scoreFrequency is 4, score value is 2.4 which is rounded off to 2
      if (scoreFrequency == 0) {
        return 0;
      } else if (scoreFrequency == 1 || scoreFrequency == 2) {
        return 1;
      } else if (scoreFrequency == 3 || scoreFrequency == 4) {
        return 2;
      }
    }
  }

  Future<int> getASQuantity(modulesForScore) async {
    int quantities;
    quantities = await _adaptiveLearning.adaptiveSetQuantity(modulesForScore);
    return quantities;
  }

  
}

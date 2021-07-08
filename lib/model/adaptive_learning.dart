import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AdaptiveLearningModel {
  final _adaptiveRef =
      FirebaseDatabase.instance.reference().child('adaptiveLearning');

  List _adaptiveSet = [];
  int quantityNum;

  Future<List> getAdaptiveSet(String moduleId) async {
    await _adaptiveRef.child(moduleId).once().then((value) {
      Map<dynamic, dynamic> questions = value.value;
      questions.forEach((key, value) {
        _adaptiveSet = questions.values.toList();
      });
    });
    return _adaptiveSet;
  }

  Future<Map> getAdaptiveQuestionsById(String moduleId) async {
    DataSnapshot snapshot = await _adaptiveRef.child(moduleId).once();
    return snapshot.value;
  }

  // ignore: missing_return
  Future<int> adaptiveSetQuantity(String moduleId) async {
    await _adaptiveRef.child(moduleId).once().then((value) {
      Map quantity = value.value;

      quantityNum = quantity.length;
    });
    return quantityNum;
  }

  Future<bool> createNewAdaptiveSet(
      Map adaptiveSet, String moduleId, int setNum) async {
    try {
      await _adaptiveRef.child(moduleId).child('adaptiveSet$setNum').set({
        'question': adaptiveSet['question'],
        'options': adaptiveSet['options'],
        'answerIndex': adaptiveSet['answerIndex']
      });

      return true;
    } on FirebaseException {
      return false;
    }
  }
}

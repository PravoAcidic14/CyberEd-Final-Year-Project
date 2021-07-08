import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ModuleModel {
  final _moduleRef = FirebaseDatabase.instance.reference().child('module');
  List moduleIdList = [], moduleContentList = [];
  Map<dynamic, dynamic> moduleContent, allModules = {};

  Future<bool> createNewModule(Map moduleDetails, String moduleId) async {
    try {
      await _moduleRef.child(moduleId).set({
        'moduleTitle': moduleDetails['moduleTitle'],
        'moduleDescription': moduleDetails['moduleDesc'],
        'thumbnailUrl': moduleDetails['thumbnailUrl'],
      });
      await _moduleRef.child(moduleId).child('moduleLevel').set({
        '0': moduleDetails['totalActivityLvl1'],
        '1': moduleDetails['totalActivityLvl1'],
        '2': moduleDetails['totalActivityLvl1'],
      });

      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<List> getAllModuleId() async {
    try {
      await _moduleRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> modules = snapshot.value;
        modules.forEach((key, value) {
          moduleIdList = modules.keys.toList();
        });
      });
      return moduleIdList;
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }

  Future<Map> getAllModules() async {
    await _moduleRef.once().then((DataSnapshot snapshot) {
      allModules = snapshot.value;
    });
    return allModules;
  }

  Future<Map> getModuleContent(String moduleId) async {
    await _moduleRef.child(moduleId).once().then((DataSnapshot snapshot) {
      moduleContent = snapshot.value;
    });
    return moduleContent;
  }

  Future deleteModule(String moduleId) async {
    await _moduleRef.child(moduleId).remove();
  }

  Future updateModule(Map newModuleDetails) async {
    try {
      if (newModuleDetails.containsKey('thumbnailUrl')) {
        await _moduleRef.child(newModuleDetails['moduleId']).update({
          'moduleTitle': newModuleDetails['moduleTitle'],
          'moduleDescription': newModuleDetails['moduleDescription'],
          'thumbnailUrl': newModuleDetails['thumbnailUrl']
        });
        return Future.value("Module details updated successfully");
      } else {
        await _moduleRef.child(newModuleDetails['moduleId']).update({
          'moduleTitle': newModuleDetails['moduleTitle'],
          'moduleDescription': newModuleDetails['moduleDescription']
        });
        return Future.value("Module details updated successfully");
      }
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }
}

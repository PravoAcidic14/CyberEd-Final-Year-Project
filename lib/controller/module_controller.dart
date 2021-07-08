import 'dart:io';

import 'package:fyp_app_design/controller/pallete_generator.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/model/module.dart';

class ModuleController {
  ModuleModel _moduleModel = ModuleModel();
  List _moduleIdList = [];
  Map moduleWithColors = {};
  ColorPalleteGenerator _colorPalleteGenerator = ColorPalleteGenerator();
  StorageController _storageController = StorageController();

  Future<bool> createNewModule(Map moduleDetails, String moduleId) async {
    bool result;
    String thumbnailUrl = await _storageController.uploadNewModuleThumbnail(
        moduleDetails['thumbnailPath'], moduleId);
    if (thumbnailUrl == "An Error has occured") {
      result = false;
      return result;
    } else {
      moduleDetails['thumbnailUrl'] = thumbnailUrl;
      _moduleModel.createNewModule(moduleDetails, moduleId).whenComplete(() {
        result = true;
      }).catchError((error) {
        result = false;
      });
      return result;
    }
  }

  Future<List> getAllModules() async {
    _moduleIdList = await _moduleModel.getAllModuleId();
    return _moduleIdList;
  }

  Future<Map> getModuleContent(String moduleId) async {
    Map _moduleContentList = await _moduleModel.getModuleContent(moduleId);
    // print('in controller ' + _moduleContentList.toString());
    return _moduleContentList;
  }

  Future<Map> getAllModuleDetails() async {
    Map _moduleDetails = await _moduleModel.getAllModules();
    return _moduleDetails;
  }

  Future<Map> getModuleWithColorCode() async {
    List moduleIdList = await getAllModules();
    for (var item in moduleIdList) {
      moduleWithColors[item] = await getModuleContent(item);
      moduleWithColors[item]['containerColor'] = await _colorPalleteGenerator
          .getPalleteDominantColor(moduleWithColors[item]['thumbnailUrl']);
    }
    return moduleWithColors;
  }

  Future deleteModule(String moduleId) async {
    await _moduleModel.deleteModule(moduleId);
  }

  Future updateModuleDetails(Map newModuleDetails, File thumbnail) async {
    if (thumbnail != null) {
      String thumbnailUrl;
      await _storageController
          .updateModuleThumbnail(newModuleDetails['moduleId'], thumbnail)
          .then((value) {
        thumbnailUrl = value;
      });

      newModuleDetails['thumbnailUrl'] = thumbnailUrl;
    }
    return await _moduleModel.updateModule(newModuleDetails);
  }
}

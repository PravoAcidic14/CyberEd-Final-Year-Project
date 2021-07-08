import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class StorageController {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadNewModuleThumbnail(
      String thumbnailPath, String moduleId) async {
    File newModuleThumbnail = File(thumbnailPath);

    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('moduleThumbnail')
        .child("${moduleId}_thumbnail.jpg")
        .putFile(newModuleThumbnail);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String moduleThumbnailUrl = await taskSnapshot.ref.getDownloadURL();
      return moduleThumbnailUrl;
    } on firebase_storage.FirebaseException {
      return Future.error('An Error has occured');
    }
  }

  Future<String> uploadNewModuleMaterial(
      String filePath, String moduleId, int level) async {
    File newFile = File(filePath);

    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('moduleMaterials')
        .child(moduleId)
        .child('level$level')
        .child(basename(newFile.path))
        .putFile(newFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String newFileUrl = await taskSnapshot.ref.getDownloadURL();
      return newFileUrl;
    } on firebase_storage.FirebaseException {
      return Future.error('An Error has occured');
    }
  }

  Future<String> uploadNewUserProfileImage(
      User user, File imageFile, BuildContext context) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('profilePic')
        .child("${user.uid}_profilePic.jpg")
        .putFile(imageFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
      return profilePictureUrl;
    } on firebase_storage.FirebaseException catch (e) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
      return e.message;
    }
  }

  Future<String> updateAdvisorProfileImage(
      String matricsId, File imageFile) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('profilePic')
        .child("advisorPics")
        .child('$matricsId.jpg')
        .putFile(imageFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
      return profilePictureUrl;
    } on firebase_storage.FirebaseException {
      return Future.error("An Error Has Occured");
    }
  }

  Future<String> updateUserProfileImage(User user, File imageFile) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('profilePic')
        .child("${user.uid}_profilePic.jpg")
        .putFile(imageFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String profilePictureUrl = await taskSnapshot.ref.getDownloadURL();
      return profilePictureUrl;
    } on firebase_storage.FirebaseException {
      return Future.error("An Error Has Occured");
    }
  }

  Future<File> loadFirebase(String moduleId, String level, String item) async {
    final refPDF =
        storage.ref('moduleMaterials').child(moduleId).child(level).child(item);
    final bytes = await refPDF.getData();

    return storeFile(item, bytes);
  }

  Future<File> storeFile(String url, List<int> bytes) async {
    final filename = url;
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<String> uploadModuleThumbnail(
      String moduleId, File imageFile, BuildContext context) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('moduleThumbnail')
        .child("${moduleId}_thumbnail.jpg")
        .putFile(imageFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String moduleThumbnailUrl = await taskSnapshot.ref.getDownloadURL();
      return moduleThumbnailUrl;
    } on firebase_storage.FirebaseException catch (e) {
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: e.message);
      return e.message;
    }
  }

  Future<String> updateModuleThumbnail(String moduleId, File thumbnail) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('moduleThumbnail')
        .child("${moduleId}_thumbnail.jpg")
        .putFile(thumbnail);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String moduleThumbnailUrl = await taskSnapshot.ref.getDownloadURL();
      return moduleThumbnailUrl;
    } on firebase_storage.FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }

  Future<String> updateActivityPDF(
      Map activityDetails, File activityPDF) async {
    String fileName = basename(activityPDF.path);
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('moduleMaterials')
        .child(activityDetails['moduleId'])
        .child("level${activityDetails['level']}")
        .child(fileName)
        .putFile(activityPDF);

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

    String newPdfUrl = await taskSnapshot.ref.getDownloadURL();
    await storage.refFromURL(activityDetails['oldUrl']).delete();
    return newPdfUrl;
  }

  Future<String> saveNewGuessGameImage(
      String newGameId, String imagePath, int setNum) async {
    File imageFile = File(imagePath);

    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('gameMaterials')
        .child(newGameId)
        .child('set$setNum')
        .child(newGameId + '_set$setNum')
        .putFile(imageFile);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } on firebase_storage.FirebaseException catch (e) {
      return e.message;
    }
  }

  Future updateGuessGameImage(Map newGameDetails, File avatarImage) async {
    firebase_storage.UploadTask uploadTask = storage
        .ref()
        .child('gameMaterials')
        .child(newGameDetails['gameId'])
        .child('set${newGameDetails['setNum']}')
        .child(newGameDetails['gameId'] + '_set${newGameDetails['setNum']}')
        .putFile(avatarImage);

    try {
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } on firebase_storage.FirebaseException catch (e) {
      return e.message;
    }
  }
}

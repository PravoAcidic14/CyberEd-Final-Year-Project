import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:fyp_app_design/controller/storage_controller.dart';
import 'package:fyp_app_design/model/game.dart';

class GameController {
  GameModel _gameModel = GameModel();
  StorageController _storageCon = StorageController();
  final _gameRef = FirebaseDatabase.instance.reference().child('game');

  Future getNewGameId() async {
    List allGameID = await _gameModel.getAllGameId();
    int idCount = allGameID.length + 1;

    String newId = 'G' + idCount.toString().padLeft(3, '0');
    print(newId);
    return newId;
  }

  Future<String> createNewDraggableGame(Map gameContent) async {
    String newGameId = await getNewGameId();

    print(gameContent);

    for (var i = 0; i < gameContent.length; i++) {
      Map currentGameSet = gameContent['set${i + 1}'];

      await _gameModel.createNewDraggableGame(
          newGameId, currentGameSet, i + 1, gameContent.length);
    }

    return newGameId;
  }

  Future<String> createNewGuessGame(Map gameContent) async {
    String newGameId = await getNewGameId();

    for (var i = 0; i < gameContent.length; i++) {
      Map currentGameSet = gameContent['set${i + 1}'];

      String imageUrl = await _storageCon.saveNewGuessGameImage(
          newGameId, currentGameSet['imagePath'], i + 1);
      currentGameSet['imageUrl'] = imageUrl;

      await _gameModel.createNewGuessGame(
          newGameId, currentGameSet, i + 1, gameContent.length);
    }

    return newGameId;
  }

  Future getGameDetails(String gameId) async {
    DataSnapshot snapshot = await _gameRef.child(gameId).once();
    print(snapshot.value);
    return snapshot.value;
  }

  Future updateDraggableGameContent(Map newGameDetails) async {
    String newQuestion = newGameDetails['question'];
    if (newQuestion.contains('/target/')) {
      await _gameModel.updateGameContent(newGameDetails).then((value) {
        return value;
      });
    } else {
      return Future.error(
          "Please input \'target\' to represent the answer field in the question.");
    }
  }
  Future updateGuessGameContent(Map newGameDetails, File avatarImage) async {

    if (avatarImage != null) {
      String imageUrl = await _storageCon.updateGuessGameImage(newGameDetails, avatarImage);

      newGameDetails['imageUrl'] = imageUrl;
    }
    
      await _gameModel.updateGuessGameContent(newGameDetails).then((value) {
        return value;
      });
    
  }
}

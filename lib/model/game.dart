import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GameModel {
  final _gameRef = FirebaseDatabase.instance.reference().child('game');

  Future getAllGameId() async {
    List _gameIdList = [];
    try {
      await _gameRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> gameId = snapshot.value;
        gameId.forEach((key, value) {
          _gameIdList = gameId.keys.toList();
        });
      });
      return _gameIdList;
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }

  Future createNewDraggableGame(
      String gameID, Map gameContent, int setNum, int setTotalAmount) async {
    try {
      await _gameRef
          .child(gameID)
          .child('gameContent')
          .child('set$setNum')
          .set({
        'question': gameContent['question'],
        'options': gameContent['options'],
        'answer': gameContent['answer'],
      });

      await _gameRef.child(gameID).child('setAmount').set(setTotalAmount);

      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future createNewGuessGame(
      String gameID, Map gameContent, int setNum, int setTotalAmount) async {
    try {
      await _gameRef
          .child(gameID)
          .child('gameContent')
          .child('set$setNum')
          .set({
        'answer': gameContent['answer'],
        'hint': gameContent['hint'],
        'imageUrl': gameContent['imageUrl'],
      });

      await _gameRef.child(gameID).child('setAmount').set(setTotalAmount);

      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future getGameById(String gameId) async {
    try {
      DataSnapshot _snapshot = await _gameRef.child(gameId).once();
      return _snapshot.value;
    } catch (e) {
      Future.error("An error has occured. Please Try Again Later.");
    }
  }

  Future<String> updateGameContent(Map newGameDetails) async {
    print('updating...');
    print(newGameDetails);
    try {
      await _gameRef
          .child(newGameDetails['gameId'])
          .child('gameContent')
          .child('set${newGameDetails['setNum']}')
          .update({
        'question': newGameDetails['question'],
        'answer': newGameDetails['answer'],
        'options': newGameDetails['options']
      });
      print('Updated Succesfully');
      return 'Game Details Updated Successfully';
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }

  Future<String> updateGuessGameContent(Map newGameDetails) async {
    print('updating...');
    print(newGameDetails);
    try {
      if (newGameDetails.containsKey('imageUrl')) {
        await _gameRef
            .child(newGameDetails['gameId'])
            .child('gameContent')
            .child('set${newGameDetails['setNum']}')
            .update({
          'answer': newGameDetails['answer'],
          'hint': newGameDetails['hint'],
          'imageUrl': newGameDetails['imageUrl']
        });
      } else {
        await _gameRef
            .child(newGameDetails['gameId'])
            .child('gameContent')
            .child('set${newGameDetails['setNum']}')
            .update({
          'answer': newGameDetails['answer'],
          'hint': newGameDetails['hint'],
        });
      }

      print('Updated Succesfully');
      return 'Game Details Updated Successfully';
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }
}

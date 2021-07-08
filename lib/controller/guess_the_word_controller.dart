import 'package:fyp_app_design/model/game.dart';

class GuessTheWordController {

  GameModel _gameModel = GameModel();
  Map gameContentData = {};

  Future<Map> parseGameContentFromId(String gameId) async {
    gameContentData = await _gameModel.getGameById(gameId);
    return gameContentData;
  }
}
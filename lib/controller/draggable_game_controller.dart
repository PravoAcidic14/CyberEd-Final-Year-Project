import 'package:fyp_app_design/model/game.dart';

class DraggableGameController {
  Map gameContentData = {};
  GameModel _gameModel = GameModel();

  Future parseGameContentFromId(String gameId) async {
    gameContentData = await _gameModel.getGameById(gameId);
    return gameContentData;
  }

  List getOptionsListBySetNumber(int setNum, Map gameContentData) {
    var optionList = gameContentData['gameContent']['set$setNum']['options'];
    return optionList;
  }

  List<String> getQuestionBySetNumber(int setNum, Map gameContentData) {
    String question = gameContentData['gameContent']['set$setNum']['question'];
    return question.split('/target/');
  }

  String getAnswerBySetNumber(int setNum, Map gameContentData) {
    String answer = gameContentData['gameContent']['set$setNum']['answer'];
    return answer;
  }
}

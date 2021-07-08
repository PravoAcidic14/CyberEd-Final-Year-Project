import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';

class ActivityModel {
  final _activityRef = FirebaseDatabase.instance.reference().child('activity');

  Future<List> getModuleActivity(String moduleId, String level) async {
    List _activityMap = [];

    DataSnapshot _dataSnapshot =
        await _activityRef.child(moduleId).child(level).once();
    _activityMap = _dataSnapshot.value;
    return _activityMap;
  }

  Future createVideoActivity(
      Map videoDetails, int level, int activityCount, String moduleId) async {
    try {
      await _activityRef
          .child(moduleId)
          .child(level.toString())
          .child(activityCount.toString())
          .set({
        'activityTitle': videoDetails['activityTitle'],
        'activityPoints': videoDetails['activityPoints'],
        'activityType': 'video',
        'videoUrl': videoDetails['videoUrl'],
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future createSlidesActivity(
      Map slidesDetails, int level, int activityCount, String moduleId) async {
    try {
      print('level to be created' + level.toString());
      await _activityRef
          .child(moduleId)
          .child(level.toString())
          .child(activityCount.toString())
          .set({
        'activityTitle': slidesDetails['activityTitle'],
        'activityPoints': slidesDetails['activityPoints'],
        'activityType': 'slides',
        'slidesName': basenameWithoutExtension(slidesDetails['slidesPath']),
        'slidesUrl': slidesDetails['slidesUrl'],
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future createPosterActivity(
      Map posterDetails, int level, int activityCount, String moduleId) async {
    try {
      print('level to be created' + level.toString());
      await _activityRef
          .child(moduleId)
          .child(level.toString())
          .child(activityCount.toString())
          .set({
        'activityTitle': posterDetails['activityTitle'],
        'activityPoints': posterDetails['activityPoints'],
        'activityType': 'poster',
        'posterName': basenameWithoutExtension(posterDetails['posterPath']),
        'posterUrl': posterDetails['posterUrl'],
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future createDraggableGameActivity(Map gameActivityDetails, int level,
      int activityCount, String moduleId, String newGameId) async {
    try {
      await _activityRef
          .child(moduleId)
          .child(level.toString())
          .child(activityCount.toString())
          .set({
        'activityTitle': gameActivityDetails['activityTitle'],
        'activityPoints': gameActivityDetails['activityPoints'],
        'activityType': 'game',
        'gameId': newGameId,
        'gameType': 'draggable',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future createGuessGameActivity(Map gameActivityDetails, int level,
      int activityCount, String moduleId, String newGameId) async {
    try {
      await _activityRef
          .child(moduleId)
          .child(level.toString())
          .child(activityCount.toString())
          .set({
        'activityTitle': gameActivityDetails['activityTitle'],
        'activityPoints': gameActivityDetails['activityPoints'],
        'activityType': 'game',
        'gameId': newGameId,
        'gameType': 'guess',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future updateActivity(Map newActivityDetails) async {
    try {
      if (newActivityDetails.containsKey('pdfUrl')) {
        print('pdf is here');
        if (newActivityDetails['activityType'] == 'slides') {
          await _activityRef
              .child(newActivityDetails['moduleId'])
              .child(newActivityDetails['level'].toString())
              .child(newActivityDetails['activityId'].toString())
              .update({
            'activityTitle': newActivityDetails['activityTitle'],
            'activityPoints': newActivityDetails['activityPoints'],
            'slidesUrl': newActivityDetails['pdfUrl'],
            'slidesName': newActivityDetails['basenameWithoutExtension'],
          });
        } else {
          await _activityRef
              .child(newActivityDetails['moduleId'])
              .child(newActivityDetails['level'].toString())
              .child(newActivityDetails['activityId'].toString())
              .update({
            'activityTitle': newActivityDetails['activityTitle'],
            'activityPoints': newActivityDetails['activityPoints'],
            'posterUrl': newActivityDetails['pdfUrl'],
            'posterName': newActivityDetails['basenameWithoutExtension'],
          });
        }

        return Future.value("Activity details updated successfully");
      } else {
        print('no pdf here');
        await _activityRef
            .child(newActivityDetails['moduleId'])
            .child(newActivityDetails['level'].toString())
            .child(newActivityDetails['activityId'].toString())
            .update({
          'activityTitle': newActivityDetails['activityTitle'],
          'activityPoints': newActivityDetails['activityPoints'],
          'videoUrl': newActivityDetails['videoUrl'],
        });
        return Future.value("Activity details updated successfully");
      }
    } on FirebaseException catch (e) {
      return Future.error(e.message);
    }
  }
}

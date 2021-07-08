import 'package:firebase_database/firebase_database.dart';

class BadgeController {
  final _badgeRef = FirebaseDatabase.instance.reference().child('badges');

  Future<Map> getBadgeDetailsById(String badgeId) async {
    DataSnapshot snapshot = await _badgeRef.child(badgeId).once();
    return snapshot.value;
  }
}

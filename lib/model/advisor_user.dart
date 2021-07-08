import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdvisorUser {
  final _advisorRef =
      FirebaseDatabase.instance.reference().child('users').child('advisor');

  Future<bool> checkMatricsId(String matricsId) async {
    DataSnapshot snapshot = await _advisorRef.child(matricsId).once();

    if (snapshot.value == null) {
      return false;
    } else {
      return true;
    }
  }

  Future getAdvisorPassword(String matricsId) async {
    DataSnapshot snapshot =
        await _advisorRef.child(matricsId).child('password').once();
    return snapshot.value;
  }

  Future<Map> getAdvisorData(String matricsId) async {
    DataSnapshot snapshot = await _advisorRef.child(matricsId).once();
    return snapshot.value;
  }

  Future<String> updateAdvisor({Map userData, String matricsId}) async {
    try {
      if (userData['avatarUrl'] == "") {
        await _advisorRef.child(matricsId).update({
          'fName': userData['fName'],
          'lName': userData['lName'],
          'email': userData['email'],
          'password': userData['password']
        });
        return Future.value("Student Details updated successfully");
      } else {
        await _advisorRef.child(matricsId).update({
          'fName': userData['fName'],
          'lName': userData['lName'],
          'email': userData['email'],
          'avatarUrl': userData['avatarUrl'],
          'password': userData['password']
        });
        return Future.value("Student Details updated successfully");
      }
    } on FirebaseException {
      return Future.error("Student Details cannot be updated");
    }
  }

  Future<String> updateAdvisorWithoutImage(
      {Map userData, String matricsId}) async {
    try {
      await _advisorRef.child(matricsId).update({
        'fName': userData['fName'],
        'lName': userData['lName'],
        'email': userData['email'],
      });
      return "Student Details updated successfully";
    } on FirebaseException {
      return Future.error("Student Details cannot be updated");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_color/random_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _messaging = FirebaseMessaging();

class SignupLogic {
//Create Supervisor
  static void createSupervisor(FirebaseUser user, String _email,
      String _password, String _firstName, String _lastName) async {
    RandomColor _randomColor = RandomColor();
    String token = _messaging.getToken().toString();
    Firestore.instance.collection('users').document('${user.uid}').setData({
      'id': user.uid,
      'firstName': _firstName,
      'lastName': _lastName,
      'email': _email,
      'role': 'super',
      'token': token,
      'profileColor': _randomColor.randomColor().toString(),
    });
  }

//Create Parent
  static void createParent(FirebaseUser user, String _email, String _password,
      String _firstName, String _lastName) async {
    RandomColor _randomColor = RandomColor();
    String _token;
    _messaging.getToken().then((token) {
      Firestore.instance.collection('users').document('${user.uid}').setData({
        'id': user.uid,
        'firstName': _firstName,
        'lastName': _lastName,
        'email': _email,
        'role': 'parent',
        'token': token,
        'profileColor': _randomColor.randomColor().toString(),
      });
    });

    print(_token);
  }
}

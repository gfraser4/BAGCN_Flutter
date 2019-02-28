import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupLogic {

//Create Supervisor
static void createSupervisor(FirebaseUser user, String _email, String _password, String _firstName, String _lastName) async {
        Firestore.instance.collection('users').document('${user.uid}').setData({
          'id': user.uid,
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'role': 'super',
        });
}

//Create Parent
static void createParent(FirebaseUser user, String _email, String _password, String _firstName, String _lastName) async {
        Firestore.instance.collection('users').document('${user.uid}').setData({
          'id': user.uid,
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'role': 'parent',
        });
}

}




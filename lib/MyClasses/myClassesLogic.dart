
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/ClassesModel.dart';

class MyClassesLogic {

  static void notifyClick(
      FirebaseUser user, Classes classes) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(classes.reference);
      final fresh = Classes.fromSnapshot(freshSnapshot);
      if (fresh.notifyUsers.contains(user.uid) == false) {
        await transaction.update(classes.reference,
            {"notifyUsers": FieldValue.arrayUnion(userID)});
        print('added');
      } else {
        await transaction.update(classes.reference,
            {"notifyUsers": FieldValue.arrayRemove(userID)});
        print('removed');
      }
    });
  }


}
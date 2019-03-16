import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingLogic {

  static void muteNotification(FirebaseUser user, List<Classes> classes, bool isMute){
    List<String> userID = [user.uid];
      for(Classes cls in classes){
        Firestore.instance.runTransaction((transaction) async {
          final freshSnapshot = await transaction.get(cls.reference);
          final fresh = Classes.fromSnapshot(freshSnapshot);
          if (fresh.notifyUsers.contains(user.uid) == false||!isMute) {
            await transaction.update(
                cls.reference, {"notifyUsers": FieldValue.arrayUnion(userID)});
          } else if (fresh.notifyUsers.contains(user.uid) == true||isMute){
            await transaction.update(
                cls.reference, {"notifyUsers": FieldValue.arrayRemove(userID)});
          }
        });
      }
  }

  static Future<void> sendChangePasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

}
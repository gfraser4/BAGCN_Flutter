import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/ClassesModel.dart';

class ClassMGMTLogic {
  static addClass(BuildContext context, Classes classes, List<String> userID, FirebaseUser user) async {

    List<int> clsCode = [classes.code];
    Firestore db = Firestore.instance;
    try {
      await classes.reference.updateData({
        "pendingUsers": FieldValue.arrayUnion(userID),
      });
      
      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "enrolledPending": FieldValue.arrayUnion(clsCode),
        });
      });
      print(userID);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  
  static removeClass(
      BuildContext context, Classes classes, List<String> userID, FirebaseUser user) async {
    try {
     await classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayRemove(userID),
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  static openClass(BuildContext context, Classes classes, List<String> userID, String passCode) async {
    try {
      await classes.reference.updateData({
        "supervisors": FieldValue.arrayUnion(userID),
        "passcode" : passCode,
        "isActive": true
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  static closeClass(
      BuildContext context, Classes classes, List<String> userID) async {
    try {
      await classes.reference.updateData({
        "enrolledUsers": [],
        "supervisors": [],
        "passcode": "",
        "isActive": false
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

}

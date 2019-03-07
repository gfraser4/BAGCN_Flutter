import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/ClassesModel.dart';

class ClassMGMTLogic {
  static addClassPending(BuildContext context, Classes classes, List<String> userID, FirebaseUser user) async {

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

    static addClassEnrolled(BuildContext context, Classes classes, List<String> userID, FirebaseUser user) async {

    List<int> clsCode = [classes.code];
    Firestore db = Firestore.instance;
    try {
      await classes.reference.updateData({
        "pendingUsers": FieldValue.arrayRemove(userID),
        "enrolledUsers": FieldValue.arrayUnion(userID),
      });
      
      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "enrolledPending": FieldValue.arrayRemove(clsCode),
          "enrolledIn": FieldValue.arrayUnion(clsCode),
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
        Firestore db = Firestore.instance;
        List<int> clsCode = [classes.code];
    try {
     await classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayRemove(userID),
        "pendingUsers": FieldValue.arrayRemove(userID),
      });
      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "enrolledPending": FieldValue.arrayRemove(clsCode),
          "enrolledIn": FieldValue.arrayRemove(clsCode),
        });
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

//*
//  Closing a class should reset all class fields and delete any associated comments/announcements etc.
//*  
  static closeClass(
      BuildContext context, Classes classes, List<String> userID, FirebaseUser user) async {
        Firestore db = Firestore.instance;
        List<int> clsCode = [classes.code];
    try {
      await classes.reference.updateData({
        "enrolledUsers": [],
        "supervisors": [],
        "passcode": "",
        "isActive": false,
        "notifyUsers":[],

      });
      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "enrolledPending": FieldValue.arrayRemove(clsCode),
          "enrolledIn": FieldValue.arrayRemove(clsCode),
        });
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

}

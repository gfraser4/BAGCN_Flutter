import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// MODELS
import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Models/Children.dart';

class ClassMGMTLogic {
  // ADD USER TO PENDING STATUS - UPDATES CLASS AND USERS TABLES
  static addClassPending(BuildContext context, Classes classes,
      List<String> userID, FirebaseUser user) async {
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
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

// ADD USER TO ENROLLED STATUS - UPDATES CLASS AND USERS TABLES
  static addClassEnrolled(BuildContext context, Classes classes,
      List<String> userID, FirebaseUser user, String childName) async {
    List<int> clsCode = [classes.code];
    String childID;
    Firestore db = Firestore.instance;
    try {
      QuerySnapshot _queryChildren = await db
          .collection('children')
          .where('parentID', isEqualTo: user.uid)
          .where('Name', isEqualTo: childName)
          .getDocuments();
      _queryChildren.documents.forEach((doc) {
        childID = doc.documentID;
        db.collection('children').document(doc.documentID).updateData({
          "enrolledIn": FieldValue.arrayUnion(clsCode),
        });
      });

      await classes.reference.updateData({
        "pendingUsers": FieldValue.arrayRemove(userID),
        "enrolledUsers": FieldValue.arrayUnion(userID),
        "enrolledChildren": FieldValue.arrayUnion([childID]),
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
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

// REMOVES USER FROM A CLASS - UPDATES USERS AND CLASSES TABLES
  static removeClass(BuildContext context, Classes classes, List<String> userID,
      FirebaseUser user) async {
    Firestore db = Firestore.instance;
    List<int> clsCode = [classes.code];
    String childID;

    QuerySnapshot _queryChildren = await db
        .collection('children')
        .where('parentID', isEqualTo: user.uid)
        .where('enrolledIn', arrayContains: classes.code)
        .getDocuments();
    _queryChildren.documents.forEach((doc) {
      childID = doc.documentID;
      db.collection('children').document(doc.documentID).updateData({
        "enrolledIn": FieldValue.arrayRemove(clsCode),
      });
    });

    QuerySnapshot _query = await db
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .getDocuments();

    _query.documents.toList();
    final userToken = Users.fromSnapshot(_query.documents.first);
    List<String> token = [userToken.token];

    try {
      await classes.reference.updateData({
        "enrolledUsers": FieldValue.arrayRemove(userID),
        "pendingUsers": FieldValue.arrayRemove(userID),
        "notifyUsers": FieldValue.arrayRemove(token),
        "notifyList": FieldValue.arrayRemove(userID),
        "enrolledChildren": FieldValue.arrayRemove([childID]),
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

// REMOVES USER FROM A CLASS - UPDATES USERS AND CLASSES TABLES
  static removeChildFromAllClass(BuildContext context, List<String> userID,
      FirebaseUser user, Children children) async {
    Firestore db = Firestore.instance;
    try {
      db.collection('children').document(children.childID).setData({
        "enrolledIn": [],
        "childID" : children.childID,
        "parentID": user.uid,
        "name":children.name,
      });

      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();

      _query.documents.toList();
      final userToken = Users.fromSnapshot(_query.documents.first);
      List<String> token = [userToken.token];

      QuerySnapshot _queryClasses = await db
          .collection('class')
          .where('enrolledChildren', arrayContains: children.childID)
          .getDocuments();
      _queryClasses.documents.forEach((doc) {
        db.collection('class').document(doc.documentID).updateData({
          "enrolledUsers": FieldValue.arrayRemove(userID),
          "pendingUsers": FieldValue.arrayRemove(userID),
          "notifyUsers": FieldValue.arrayRemove(token),
          "notifyList": FieldValue.arrayRemove(userID),
          "enrolledChildren": FieldValue.arrayRemove([children.childID]),
        });
      });

      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

// OPENS A CLASS
  static openClass(BuildContext context, Classes classes, List<String> userID,
      String passCode) async {
    try {
      await classes.reference.updateData({
        "supervisors": FieldValue.arrayUnion(userID),
        "passcode": passCode,
        "isActive": true
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

//  CLOSING A CLASS - should reset all class fields and delete any associated comments/announcements etc.
  static closeClass(BuildContext context, Classes classes, List<String> userID,
      FirebaseUser user) async {
    Firestore db = Firestore.instance;
    List<int> clsCode = [classes.code];
    try {
      QuerySnapshot _query = await db
          .collection('users')
          .where('enrolledIn', arrayContains: classes.code)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          // "enrolledPending": FieldValue.arrayRemove(clsCode),
          "enrolledIn": FieldValue.arrayRemove(clsCode),
        });
      });

// So announcements are never deleted changes their code to 0 for history but they won't show back up if class is reopened.
      QuerySnapshot _announcementsQuery = await db
          .collection('announcements')
          .where('code', isEqualTo: classes.code)
          .getDocuments();
      _announcementsQuery.documents.forEach((doc) {
        db.collection('announcements').document(doc.documentID).updateData({
          "code": 0,
        });
      });

      await classes.reference.updateData({
        "enrolledUsers": [],
        "supervisors": [],
        "passcode": "",
        "isActive": false,
        "notifyUsers": [],
      });

      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }
}

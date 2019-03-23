import 'package:bagcndemo/Models/Children.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/AddClasses/joinClassesPage.dart';
import 'package:bagcndemo/Announcements/announcementPage.dart';
import 'package:bagcndemo/AddClasses/addClassesPage.dart';
import 'package:bagcndemo/Models/ClassesModel.dart';

class MyClassesLogic {
  // Notification Toggle for class
  static void notifyClick(FirebaseUser user, Classes classes) {
    List<String> userID = ['${user.uid}'];
    Firestore db = Firestore.instance;
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(classes.reference);
      final fresh = Classes.fromSnapshot(freshSnapshot);

      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();

      _query.documents.toList();

      // var test = db.collection('users').document(user.uid).get()
      // .updateData({
      // "enrolledPending": FieldValue.arrayRemove(clsCode),
      // "enrolledIn": FieldValue.arrayUnion(clsCode),

      //final freshSnap= await transaction.get(_query.reference);
      final classesx = Users.fromSnapshot(_query.documents.first);
      List<String> token = [classesx.token];
      // token.add(classesx.token);
      print(token);

      if (fresh.notifyUsers.contains(token) == false) {
        await transaction.update(
            classes.reference, {"notifyUsers": FieldValue.arrayUnion(token)});
        print('added');
      } else {
        await transaction.update(
            classes.reference, {"notifyUsers": FieldValue.arrayRemove(token)});
        print('removed');
      }
    });
  }

  // Navigation to add classes page for supervisors
  static void navToAddClasses(BuildContext context, FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClassesPage(user)),
    );
  }

  // Navigation to add classes page for parents
  static void navToJoinClasses(BuildContext context, FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinClassesPage(user)),
    );
  }

  // Navigation to AnnouncementsPage
  static void navToAnnouncements(
      BuildContext context, FirebaseUser user, Classes classes, bool isSuper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClassAnnouncementPage(classes.clsName, classes.code, user, isSuper,classes),
      ),
    );
  }

// RENDER DIRRENT NOTIFICATION ICON BASED ON WHETHER USER WANTS NOTIFICATIOSN OR NOT
  static Widget notifyButtonRender(FirebaseUser user, Classes classes) {
    if (classes.notifyUsers.contains(user.uid) == true) {
      return IconButton(
        icon: Icon(Icons.notifications_active),
        color: Color(0xFF1ca5e5),
        onPressed: () {
          MyClassesLogic.notifyClick(user, classes);
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.notifications_off),
        color: Colors.grey,
        onPressed: () {
          MyClassesLogic.notifyClick(user, classes);
        },
      );
    }
  }

// BUILDS STREAM DEPENDING ON SUPERVISOR OR ENROLLED USER
  static Stream buildStream(String userID, bool isSuper, FirebaseUser user, Children children) {
    if (isSuper == true) {
      return Firestore.instance
          .collection('class')
          .where('supervisors', arrayContains: user.uid)
          //.orderBy('clsName')
          .snapshots();
          
    } else {
      
      return Firestore.instance
          .collection('class')
          //.where('enrolledUsers', arrayContains: userID)
          .where('enrolledChildren', arrayContains: children.childID)
          //.orderBy('clsName')
          .snapshots();
    }
  }

  // BUILDS STREAM DEPENDING ON SUPERVISOR OR ENROLLED USER
  static Stream buildChildStream(FirebaseUser user) {
    return Firestore.instance
        .collection('children')
        .where('parentID', isEqualTo: user.uid)
        //.orderBy('clsName')
        .snapshots();
  }

  // ADD USER TO ENROLLED STATUS - UPDATES CLASS AND USERS TABLES
  static createChild(BuildContext context, List<String> userID,
      FirebaseUser user, String childName) async {
    Firestore db = Firestore.instance;
    String childID;
    try {
      Firestore.instance
          .collection('children')
          .document()
          .setData({'parentID': user.uid, 'Name': childName});
      QuerySnapshot _queryChildren = await db
          .collection('children')
          .where('parentID', isEqualTo: user.uid)
          .where('Name', isEqualTo: childName)
          .getDocuments();
      _queryChildren.documents.forEach((doc) {
        childID = doc.documentID;
        db.collection('children').document(doc.documentID).updateData({
          "childID": doc.documentID,
        });
      });

      // await Firestore.instance.collection('class').document('D64bbReCYndo789B8dbK').updateData({
      //   "enrolledUsers": FieldValue.arrayUnion([user.uid])
      // });

      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "children": FieldValue.arrayUnion([childID]),
        });
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  // DELETE CHILD AND CLASSES
  static removeChild(BuildContext context, List<String> userID,
      FirebaseUser user, Children children) async {
    Firestore db = Firestore.instance;

    try {

      // REMOVE CHILD FROM CLASS
      QuerySnapshot _queryChildren = await db
          .collection('class')
          .where('enrolledChildren', arrayContains: children.childID)
          .getDocuments();
      _queryChildren.documents.forEach((doc) {
        db.collection('class').document(doc.documentID).updateData({
          "enrolledChildren": FieldValue.arrayRemove([children.childID]),
          "enrolledUsers": FieldValue.arrayRemove([user.uid]),
        });
      });

      // await Firestore.instance.collection('class').document('D64bbReCYndo789B8dbK').updateData({
      //   "enrolledUsers": FieldValue.arrayUnion([user.uid])
      // });

      // REMOVE CHILD FROM PARENT
      QuerySnapshot _query = await db
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('users').document(user.uid).updateData({
          "children": FieldValue.arrayUnion([children.childID]),
        });
      });

      // DELETE CHILD
      await Firestore.instance
          .collection('children')
          .document(children.childID)
          .delete();

     Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }
}

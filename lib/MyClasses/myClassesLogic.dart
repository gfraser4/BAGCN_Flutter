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
            ClassAnnouncementPage(classes.clsName, classes.code, user, isSuper),
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
  static Stream buildStream(String userID, bool isSuper) {
    if (isSuper == true) {
      return Firestore.instance
          .collection('class')
          .where('supervisors', arrayContains: userID)
          //.orderBy('clsName')
          .snapshots();
    } else {
      return Firestore.instance
          .collection('class')
          .where('enrolledUsers', arrayContains: userID)
          //.orderBy('clsName')
          .snapshots();
    }
  }
}

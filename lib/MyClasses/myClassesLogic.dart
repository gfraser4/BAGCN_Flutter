import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Announcements/announcementPage.dart';
import 'package:bagcndemo/AddClasses/addClassesPage.dart';
import 'package:bagcndemo/Models/ClassesModel.dart';

class MyClassesLogic {
  // Notification Toggle for class
  static void notifyClick(FirebaseUser user, Classes classes) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(classes.reference);
      final fresh = Classes.fromSnapshot(freshSnapshot);
      if (fresh.notifyUsers.contains(user.uid) == false) {
        await transaction.update(
            classes.reference, {"notifyUsers": FieldValue.arrayUnion(userID)});
        print('added');
      } else {
        await transaction.update(
            classes.reference, {"notifyUsers": FieldValue.arrayRemove(userID)});
        print('removed');
      }
    });
  }

  // Nav to add classes page
  static void navToAddClasses(BuildContext context, FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClassesPage(user)),
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
      ), //ICON BUTTON NAVIGATES TO ANNOUNCEMENT PAGE AND PASSES THE CLASSNAME AND CODE
    );
  }

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
}

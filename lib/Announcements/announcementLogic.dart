import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';

class AnnouncementLogic {
//build announcement stream
  static Stream<QuerySnapshot> announcementStream(String title, int code) {
    return Firestore.instance
        .collection('announcements')
        .where('class', isEqualTo: title)
        .where('code', isEqualTo: code)
        .orderBy('created', descending: true)
        .snapshots();
  }

//Delete Announcement and any associated comments
  static deleteAnnouncement(String id) async {
    Firestore db = Firestore.instance;
    try {
      QuerySnapshot _query = await db
          .collection('comments')
          .where('announcementID', isEqualTo: id)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('comments').document(doc.documentID).delete();
      });

      await db.collection('announcements').document(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

// static Future<String> getSuper(String userID) async {
//     DocumentSnapshot snapshot = await Firestore.instance
//         .collection('users')
//         .document('$userID')
//         .get();
//         print('user doc read');
//         final superInfo = Users.fromSnapshot(snapshot);
//         return '${superInfo.firstName}'  ;
//   }

//add user to liked l ist and increase count like by one or decrease by one
  static void likeButtonClick(
      FirebaseUser user, Color likeButtonColor, Announcements announcements) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.likedUsers.contains(user.uid) == false) {
        likeButtonColor = Color(0xFF1ca5e5);
        await transaction.update(announcements.reference, {
          'likes': fresh.likes + 1,
          "likedUsers": FieldValue.arrayUnion(userID)
        });
      } else {
        await transaction.update(announcements.reference, {
          'likes': fresh.likes - 1,
          "likedUsers": FieldValue.arrayRemove(userID)
        });
        likeButtonColor = Colors.grey;
      }
    });
  }

  //keep track of who has subrscribed to announcement-comments notifications
  static void notifyClick(
      FirebaseUser user, Color notifyButtonColor, Announcements announcements) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.notifyUsers.contains(user.uid) == false) {
        notifyButtonColor = Color(0xFF1ca5e5);
        await transaction.update(announcements.reference,
            {"notifyUsers": FieldValue.arrayUnion(userID)});
        print('added');
      } else {
        await transaction.update(announcements.reference,
            {"notifyUsers": FieldValue.arrayRemove(userID)});
        notifyButtonColor = Colors.grey;
        print('removed');
      }
    });
  }

//Edit Comment
  static Future<void> editAnnouncement(BuildContext context, FirebaseUser user,
      String description, String announcementID) async {
    var editAnnouncement =
        Firestore.instance.collection('announcements').document(announcementID);
    editAnnouncement.updateData({
      'description': description,
    });
  }
}

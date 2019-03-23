import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// MODELS
import 'package:bagcndemo/Models/AnnouncementsModel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class AnnouncementLogic {

// BUILD ANNOUNCEMENT STREAM
  static Stream<QuerySnapshot> announcementStream(String title, int code) {
    return Firestore.instance
        .collection('announcements')
        .where('class', isEqualTo: title)
        .where('code', isEqualTo: code)
        .orderBy('created', descending: true)
        .snapshots();
  }

// DELETE ANNOUNCEMENTS AND CASCADE DELETE COMMENTS
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

// ADD OR REMOVE USER TO LIKED LIST AND INCREASE OR DECREASE LIKE COUNT 
  static void likeButtonClick(FirebaseUser user, Announcements announcements) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.likedUsers.contains(user.uid) == false) {
        await transaction.update(announcements.reference, {
          'likes': fresh.likes + 1,
          "likedUsers": FieldValue.arrayUnion(userID)
        });
      } else {
        await transaction.update(announcements.reference, {
          'likes': fresh.likes - 1,
          "likedUsers": FieldValue.arrayRemove(userID)
        });
      }
    });
  }

  // TRACK NOTIFIFICATION SUBSCRIPTIONS
  static void notifyClick(FirebaseUser user, Announcements announcements) {
    List<String> userID = ['${user.uid}'];
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.notifyUsers.contains(user.uid) == false) {
        await transaction.update(announcements.reference,
            {"notifyUsers": FieldValue.arrayUnion(userID)});
        print('added');
      } else {
        await transaction.update(announcements.reference,
            {"notifyUsers": FieldValue.arrayRemove(userID)});
        print('removed');
      }
    });
  }

// EDIT ANNOUNCEMENT
  static Future<void> editAnnouncement(FirebaseUser user, String title,
      String description, String announcementID) async {
    var editAnnouncement =
        Firestore.instance.collection('announcements').document(announcementID);
    try {
      editAnnouncement.updateData({
        'title': title,
        'description': description,
      });
    } catch (e) {
      print(e.toString());
    }
  }

// REMOVE USER FROM CLASS
  static removeEnrolledUser(int code, String userId) async {
    List<String> userID = [userId];
    Firestore db = Firestore.instance;
    try {
      QuerySnapshot _query = await db
          .collection('class')
          .where('code', isEqualTo: code)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('class').document(doc.documentID).updateData({
          "enrolledUsers": FieldValue.arrayRemove(userID),
        });
      });
      print(userID);
    } catch (e) {
      print(e.toString());
    }
  }

  // ADD USER TO CLASS
  static addUserToClass(int code, String userId) async {
    List<String> userID = [userId];
    Firestore db = Firestore.instance;
    try {
      QuerySnapshot _query = await db
          .collection('class')
          .where('code', isEqualTo: code)
          .getDocuments();
      _query.documents.forEach((doc) {
        db.collection('class').document(doc.documentID).updateData({
          "enrolledUsers": FieldValue.arrayUnion(userID),
          "pendingUsers": FieldValue.arrayRemove(userID),
        });
      });
      print(userID);
    } catch (e) {
      print(e.toString());
    }
  }

  static void sendPasscode(String className,String email,String passcode) {
      String _username = "bagcn2019@gmail.com";
      String _password = "boysandgirls2019";

      final smtpServer = gmail(_username, _password);
      
      // Create our message.
      final message = new Message()
        ..from = new Address(_username, 'Boys and Girls Club in Niagara')
        ..recipients.add(email)
        ..subject = 'Verify to access the class '+className+' :: ${new DateTime.now()}'
        ..text = 'Your passcode: '+passcode;
    
      send(message, smtpServer).then((message) => print('Email sent!'))
      .catchError((e) => print('Error occurred: $e'));
    }
}

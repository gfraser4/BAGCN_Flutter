import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Comments/editReply.dart';
import 'package:bagcndemo/Comments/editComment.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';
import 'package:bagcndemo/Models/Comments.dart';
import 'package:bagcndemo/Models/Replies.dart';

import 'package:bagcndemo/Comments/CommentsPage.dart';

//Create Comment
Future<void> createComment(BuildContext context, FirebaseUser user,
    String content, String announcementID) async {
  DateTime nowTime = new DateTime.now().toUtc();
  DocumentSnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('${user.uid}')
      .get();
  final userInfo = Users.fromSnapshot(snapshot);
  var newComment = Firestore.instance.collection('comments').document();
  newComment.setData({
    'userID': user.uid,
    'commentID': newComment.documentID,
    'announcementID': announcementID,
    'content': content,
    'firstName': userInfo.firstName,
    'lastName': userInfo.lastName,
    'created': nowTime,
    'visible': true,
    'profileColor' : userInfo.profileColor, 
  });

  DocumentSnapshot announcementSnapshot = await Firestore.instance
      .collection('announcements')
      .document(announcementID)
      .get();

//Increases comment count by one for specific announcement
  Firestore.instance.runTransaction((transaction) async {
    final freshSnapshot = await transaction.get(announcementSnapshot.reference);
    final fresh = Announcements.fromSnapshot(freshSnapshot);

    await transaction.update(announcementSnapshot.reference, {
      'commentCount': fresh.commentCount + 1,
    });
  });
}

//Create Reply
Future<void> createReply(BuildContext context, FirebaseUser user,
    String content, String commentID, String announcementID) async {
  DateTime nowTime = new DateTime.now().toUtc();
  DocumentSnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('${user.uid}')
      .get();
  final userInfo = Users.fromSnapshot(snapshot);
  var newReply = Firestore.instance.collection('replies').document();
  newReply.setData({
    'userID': user.uid,
    'replyID': newReply.documentID,
    'parentCommentID': commentID,
    'content': content,
    'firstName': userInfo.firstName,
    'lastName': userInfo.lastName,
    'created': nowTime,
    'visible': true,
    'profileColor' : userInfo.profileColor,
  });

  DocumentSnapshot announcementSnapshot = await Firestore.instance
      .collection('announcements')
      .document(announcementID)
      .get();

  //Increases comment count by one for specific announcement
  Firestore.instance.runTransaction((transaction) async {
    final freshSnapshot = await transaction.get(announcementSnapshot.reference);
    final fresh = Announcements.fromSnapshot(freshSnapshot);

    await transaction.update(announcementSnapshot.reference, {
      'commentCount': fresh.commentCount + 1,
    });
  });
}

//Edit Comment
Future<void> editComment(BuildContext context, FirebaseUser user,
    String content, String commentID) async {
  var editComment =
      Firestore.instance.collection('comments').document(commentID);
  editComment.updateData({
    'content': content,
  });
}

//Edit Reply
Future<void> editReply(BuildContext context, FirebaseUser user, String content,
    String replyID) async {
  var editComment = Firestore.instance.collection('replies').document(replyID);
  editComment.updateData({
    'content': content,
  });
}

//Comment Visibility
void toggleVisibility(DocumentSnapshot data, String commentID) {
  final comment = Comments.fromSnapshot(data);
  if (comment.visible == true) {
    visible = true;
    data.reference.updateData({'visible': false});
  } else {
    visible = false;
    data.reference.updateData({'visible': true});
  }
}

//Reply Visibility
void toggleReplyVisibility(DocumentSnapshot data, String replyID) {
  final reply = Replies.fromSnapshot(data);
  if (reply.visible == true) {
    visible = true;
    data.reference.updateData({'visible': false});
  } else {
    visible = false;
    data.reference.updateData({'visible': true});
  }
}

//Verify if user made comment: if did then allow edit button
Widget canEditComment(
    BuildContext context, Comments comments, FirebaseUser user) {
  final _editCommentController = new TextEditingController();
  _editCommentController.text = comments.content;
  if (user.uid == comments.userID) {
    return FlatButton(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.edit,
              color: Color(0xFF1ca5e5),
            ),
            Text(
              'Edit',
              style: TextStyle(color: Color(0xFF1ca5e5)),
            )
          ],
        ),
        onPressed: () {
          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditCommentPage(comments, user)),
                          );
        });
  } else {
    return Expanded(
      child: Container(),
    );
  }
}

Widget canEditReply(BuildContext context, Replies replies, FirebaseUser user) {
  final _editReplyController = new TextEditingController();
  _editReplyController.text = replies.content;
  if (user.uid == replies.userID) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.edit,
            color: Color(0xFF1ca5e5),
          ),
          Text(
            'Edit',
            style: TextStyle(color: Color(0xFF1ca5e5)),
          )
        ],
      ),
      onPressed: () {
        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditReplyPage(replies, user)),
                          );
      },
    );
  } else {
    return Container();
  }
}

//Get Profile color
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(10, 16), radix: 16) + 0xFF000000);
}

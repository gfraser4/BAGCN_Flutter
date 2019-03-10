import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// LOGIC
import 'package:bagcndemo/Comments/commentsLogic.dart';

// MODELS
import 'package:bagcndemo/Models/Comments.dart';
import 'package:bagcndemo/Models/Replies.dart';
//PAGES
import 'package:bagcndemo/Comments/CommentsPage.dart';

// ***BUILD REPLIES*** \\

// QUERY REPLIES BASED ON ANNOUNCEMENT ID and COMMENT ID
Widget buildRepliesBody(
    BuildContext context, Comments comment, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('replies')
        .where('parentCommentID', isEqualTo: comment.commentID)
        //.where('visible', isEqualTo: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildRepliesList(context, snapshot.data.documents, user);
    },
  );
}

// BUILD LIST OF REPLIES
Widget _buildRepliesList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Column(
    children: snapshot
        .map((data) => _buildRepliesListItem(context, data, user))
        .toList(),
  );
}

// BUILD REPLY CARD
Widget _buildRepliesListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final replies = Replies.fromSnapshot(data);
  var formatter = new DateFormat.yMd().add_jm();
  String formattedDate = formatter.format(replies.created);

  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: new ReplyCard(
        replies: replies, formattedDate: formattedDate, data: data, user: user),
  );
}

// REPLY CARD
class ReplyCard extends StatelessWidget {
  const ReplyCard({
    Key key,
    @required this.replies,
    @required this.formattedDate,
    @required this.data,
    @required this.user,
  }) : super(key: key);

  final Replies replies;
  final String formattedDate;
  final DocumentSnapshot data;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    // check if reply is visible and set icon accordingly
    if (replies.visible == true) {
      visibleIcon = notHiddenIcon;
    } else {
      visibleIcon = hiddenIcon;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: Row(
              children: <Widget>[
                replies.visible
                    ? Chip(
                        //padding must be 0 or two letters can be too big
                        padding: EdgeInsets.all(0),
                        avatar: CircleAvatar(
                            backgroundColor: hexToColor(replies.profileColor),
                            child: Text(
                                '${replies.firstName[0]}${replies.lastName[0]}',
                                style: TextStyle(color: Colors.white))),
                        label: Text(
                          '${replies.firstName} ${replies.lastName}\n$formattedDate',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Colors.white,
                      )
                    : Text(
                        'Hidden',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                Expanded(
                  child: Container(),
                ),
                role == true
                    ? IconButton(
                        icon: visibleIcon,
                        onPressed: () {
                          toggleReplyVisibility(data, replies.replyID);
                        },
                      )
                    : Text(''),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: replies.visible == true
                ? Text(
                    '${replies.content}',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  )
                : Text('This comment has been hidden by a moderator.',
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    replies.visible == true
                        ? canEditReply(context, replies, user)
                        : Text(''),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}
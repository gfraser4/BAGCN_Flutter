import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Models/AnnouncementsModel.dart';
import 'Models/Users.dart';
import 'Models/Comments.dart';
import 'Models/Replies.dart';

class ParentsCommentsPage extends StatefulWidget {
  final FirebaseUser user;
  final Announcements announcement;
  ParentsCommentsPage(this.announcement, this.user);
  @override
  _ParentsCommentsPage createState() {
    return _ParentsCommentsPage();
  }
}

class _ParentsCommentsPage extends State<ParentsCommentsPage> {
  final _commentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(widget.announcement.title),
      ),
      body: _buildCommentsBody(context, widget.announcement, widget.user), 
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.comment),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Comment on ${widget.announcement.title}'),
                content: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  autofocus: false,
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Leave comment...',
                    filled: true,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Comment"),
                    onPressed: () {
                      createComment(context, widget.user,
                          _commentController.text, widget.announcement.id);
                      _commentController.text = "";
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.lightGreen[50],
      //   margin: EdgeInsets.all(10),
      //   child: TextFormField(
      //     autofocus: false,
      //     controller: _commentController,
      //     decoration: InputDecoration(
      //       hintText: 'New Message...',
      //       filled: true,
      //       suffixIcon: IconButton(
      //           icon: Icon(
      //             Icons.send,
      //             color: Colors.lightGreen,
      //           ),
      //           onPressed: () {
      //             createComment(context, widget.user, _commentController.text,
      //                 widget.announcement.id);
      //             _commentController.text = "";
      //           }),
      //     ),
      //   ),
      // ),
    );
  }
}

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
    'commentID': newComment.documentID,
    'announcementID': announcementID,
    'content': content,
    'firstName': userInfo.firstName,
    'lastName': userInfo.lastName,
    'created': nowTime,
    'visible': true,
  });
}

Future<void> createReply(BuildContext context, FirebaseUser user,
    String content, String commentID) async {
  DateTime nowTime = new DateTime.now().toUtc();
  DocumentSnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('${user.uid}')
      .get();
  final userInfo = Users.fromSnapshot(snapshot);
  var newReply = Firestore.instance.collection('replies').document();
  newReply.setData({
    'replyID': newReply.documentID,
    'parentCommentID': commentID,
    'content': content,
    'firstName': userInfo.firstName,
    'lastName': userInfo.lastName,
    'created': nowTime,
    'visible': true,
  });
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildCommentsBody(
    BuildContext context, Announcements announcement, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('comments')
        .where('announcementID', isEqualTo: announcement.id)
        .where('visible', isEqualTo: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildCommentsList(context, snapshot.data.documents, user);
    },
  );
}

//widget to build list of announcements based on class and class code
Widget _buildCommentsList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0,),
    children: snapshot
        .map((data) => _buildCommentsListItem(context, data, user))
        .toList(),
  );
}

//widget to build individual card item for each announcement from original query
Widget _buildCommentsListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final _replyController = new TextEditingController();
  final comments = Comments.fromSnapshot(data);
  return Padding(
    key: ValueKey(comments.announcementID),
    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
    child: Card(
      elevation: 5.0,
      color: Colors.lightBlue[100],
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0,),
              title: Text(
                '${comments.firstName} ${comments.lastName}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${comments.content}'),
            ),
            Divider(color: Color(0xFF1ca5e5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Text('${comments.created}'),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.reply),
                  color: Color(0xFF1ca5e5),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Reply to ${comments.firstName} ${comments.lastName}'),
                          content: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            autofocus: false,
                            controller: _replyController,
                            decoration: InputDecoration(
                              hintText: 'Leave reply...',
                              filled: true,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Reply"),
                              onPressed: () {
                                createReply(context, user,
                                    _replyController.text, comments.commentID);
                                _replyController.text = "";
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Divider(color: Color(0xFF1ca5e5)),
                _buildRepliesBody(context, comments, user),
          ],
        ),
      ),
    ),
  );
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildRepliesBody(
    BuildContext context, Comments comment, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('replies')
        .where('parentCommentID', isEqualTo: comment.commentID)
        .where('visible', isEqualTo: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildRepliesList(context, snapshot.data.documents, user);
    },
  );
}

//widget to build list of announcements based on class and class code
Widget _buildRepliesList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return Column(
    children: snapshot
        .map((data) => _buildRepliesListItem(context, data, user))
        .toList(),
  );
}

//widget to build individual card item for each announcement from original query
Widget _buildRepliesListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final replies = Replies.fromSnapshot(data);
  return Padding(
    //key: ValueKey(replies.parentCommentID),
    padding: const EdgeInsets.only(left: 20.0),
    child: Card(
      elevation: 5.0,
      color: Colors.lightBlue[50],
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              title: Text(
                '${replies.firstName} ${replies.lastName}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${replies.content}'),
            ),
            Divider(color: Color(0xFF1ca5e5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Text('${replies.created}'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

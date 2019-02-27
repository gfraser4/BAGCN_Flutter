import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


import 'package:bagcndemo/Controllers/CommentLogic/commentsLogic.dart';
import 'Models/AnnouncementsModel.dart';
import 'Models/Comments.dart';
import 'Models/Replies.dart';

//visible icon

bool visible = true;
Icon visibleIcon;
Icon notHiddenIcon =
    Icon(Icons.visibility, color: Color.fromRGBO(28, 165, 229, 1));
Icon hiddenIcon = Icon(Icons.visibility_off, color: Colors.grey);

class SuperCommentsPage extends StatefulWidget {
  final FirebaseUser user;
  final Announcements announcement;
  SuperCommentsPage(this.announcement, this.user);
  @override
  _SuperCommentsPage createState() {
    return _SuperCommentsPage();
  }
}

class _SuperCommentsPage extends State<SuperCommentsPage> {
  final _commentController = new TextEditingController();

  @override
  void initState() {
    visibleIcon = notHiddenIcon;
  }

  @override
  void setState(fn) {
    if (visible == true)
    visibleIcon = notHiddenIcon;
    else
    visibleIcon = hiddenIcon;
  }

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

// ? /////////////////////////////////////////////////////
              // ***BUILD Comments*** \\
// ? ////////////////////////////////////////////////////

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildCommentsBody(
    BuildContext context, Announcements announcement, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('comments')
        .where('announcementID', isEqualTo: announcement.id)
        //.where('visible', isEqualTo: true)
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
    padding: const EdgeInsets.only(
      top: 8.0,
    ),
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
  var formatter = new DateFormat.yMd().add_jm();
  String formattedDate = formatter.format(comments.created);


//check if comment is toggled visible or not and set color accordingly
  if (comments.visible == true) {
    visibleIcon = notHiddenIcon;
  } else {
    visibleIcon = hiddenIcon;
  }

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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              title: Text(
                '${comments.firstName} ${comments.lastName}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('${comments.content}'),
              trailing: IconButton(
                  //color: Colors.red,
                  icon: visibleIcon,
                  onPressed: () {
                    toggleVisibility(data, comments.commentID);
                  }),
            ),
            Divider(color: Color(0xFF1ca5e5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Text('$formattedDate'),
                    ],
                  ),
                ),
                Expanded(child: Container(),),
                canEditComment(context, comments, user),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.reply,
                        color: Color(0xFF1ca5e5),
                      ),
                      Text(
                        'Reply',
                        style: TextStyle(color: Color(0xFF1ca5e5)),
                      )
                    ],
                  ),
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
                                createReply(
                                    context,
                                    user,
                                    _replyController.text,
                                    comments.commentID,
                                    comments.announcementID);
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

// ? /////////////////////////////////////////////////////
// ***BUILD REPLIES*** \\
// ? ////////////////////////////////////////////////////

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildRepliesBody(
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
  var formatter = new DateFormat.yMd().add_jm();
  String formattedDate = formatter.format(replies.created);

//check if reply is toggled visible or not and set color accordingly
 if (replies.visible == true) {
    visibleIcon = notHiddenIcon;
  } else {
    visibleIcon = hiddenIcon;
  }


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
              trailing: IconButton(
                  //color: Colors.red,
                  icon: visibleIcon,
                  onPressed: () {
                    toggleReplyVisibility(data, replies.replyID);
                  }),
            ),
            Divider(color: Color(0xFF1ca5e5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text('$formattedDate'),
                      canEditReply(context, replies, user),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:bagcndemo/Comments/commentReply.dart';
import 'package:bagcndemo/Comments/commentsLogic.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';
import 'package:bagcndemo/Models/Comments.dart';
import 'package:bagcndemo/Models/Replies.dart';

//visible icon
bool role;
bool visible = true;
Icon visibleIcon;
Icon notHiddenIcon =
    Icon(Icons.visibility, color: Color.fromRGBO(28, 165, 229, 1));
Icon hiddenIcon = Icon(Icons.visibility_off, color: Colors.grey);
ScrollController _scrollController = new ScrollController();

class CommentsPage extends StatefulWidget {
  final FirebaseUser user;
  final Announcements announcement;
  final bool isSuper;
  CommentsPage(this.announcement, this.user, this.isSuper);
  @override
  _CommentsPage createState() {
    return _CommentsPage();
  }
}

class _CommentsPage extends State<CommentsPage> {

  final _commentController = new TextEditingController();

  @override
  void initState() {
    visibleIcon = notHiddenIcon;

    super.initState();
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
    role = widget.isSuper;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.announcement.title),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: _buildCommentsBody(context, widget.announcement, widget.user),
        ),
        Form(
          child: Container(
            color: Color.fromRGBO(28, 165, 229, 1),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextFormField(
              validator: (input) {
                if (input.isEmpty)
                  return 'Please enter a title for the announcement.';
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (input) => _commentController.text = input,
              textInputAction: TextInputAction.done,
              autofocus: false,
              controller: _commentController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  color: Color.fromRGBO(123, 193, 67, 1),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      createComment(
                          context,
                          widget.user,
                          _commentController.text.trim(),
                          widget.announcement.id);
                      _commentController.text = "";
                      FocusScope.of(context).requestFocus(new FocusNode());

                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );

                      print('Send');
                    }
                  },
                ),
                labelText: 'Type a message...',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(123, 193, 67, 1),
                      width: 2,
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
          ),
        ),
      ]),
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
    controller: _scrollController,
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
              title: comments.visible
                  ? Text(
                      '${comments.firstName} ${comments.lastName}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  : Text(
                      'Hidden',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
              subtitle: comments.visible == true
                  ? Text('${comments.content}')
                  : Text('This comment has been hidden by a moderator.'),
              trailing: role == true
                  ? IconButton(
                      //color: Colors.red,
                      icon: visibleIcon,
                      onPressed: () {
                        toggleVisibility(data, comments.commentID);
                      },
                    )
                  : null,
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
                Expanded(
                  child: Container(),
                ),
                comments.visible == true
                    ? canEditComment(context, comments, user)
                    : Text(''),
                comments.visible == true
                    ? FlatButton(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReplyPage(comments, user)),
                          );
                        },
                      )
                    : Text(''),
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
              title: replies.visible
                  ? Text(
                      '${replies.firstName} ${replies.lastName}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  : Text(
                      'Hidden',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
              subtitle: replies.visible == true
                  ? Text('${replies.content}')
                  : Text('This reply has been hidden by a moderator.'),
              trailing: role == true
                  ? IconButton(
                      //color: Colors.red,
                      icon: visibleIcon,
                      onPressed: () {
                        toggleReplyVisibility(data, replies.replyID);
                      })
                  : null,
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
                      replies.visible == true ? canEditReply(context, replies, user) :Text(''),
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

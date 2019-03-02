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
          child: new MessageInputBar(
            commentController: _commentController,
            widget: widget,
          ),
        ),
      ]),
    );
  }
}

//Message Input Bar
class MessageInputBar extends StatelessWidget {
  const MessageInputBar({
    Key key,
    @required TextEditingController commentController,
    @required this.widget,
  })  : _commentController = commentController,
        super(key: key);

  final TextEditingController _commentController;
  final CommentsPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                createComment(context, widget.user,
                    _commentController.text.trim(), widget.announcement.id);
                _commentController.text = "";
                //takes focus off of search area after submitting comment
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
        ),
      ),
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
  return Padding(
    key: ValueKey(comments.announcementID),
    padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
    child: new CommentCard(
        comments: comments,
        formattedDate: formattedDate,
        data: data,
        user: user),
  );
}

//Comment Area Widget - Contains Top comment area and bottom comment ares widgets
class CommentCard extends StatelessWidget {
  const CommentCard({
    Key key,
    @required this.comments,
    @required this.formattedDate,
    @required this.data,
    @required this.user,
  }) : super(key: key);

  final Comments comments;
  final String formattedDate;
  final DocumentSnapshot data;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),),
      elevation: 5.0,
      color: Colors.lightBlue[100],
      child: Container(
        child: Column(
          children: <Widget>[
            new TopCommentArea(comments: comments, data: data, user: user, formattedDate: formattedDate,),
            //Divider(color: Color(0xFF1ca5e5)),
            new BottomCommentArea(
                formattedDate: formattedDate, comments: comments, user: user),
            //Divider(color: Color(0xFF1ca5e5), height: 1,),
            _buildRepliesBody(context, comments, user),
          ],
        ),
      ),
    );
  }
}

//Bottom Area Widget - Date/Reply/Edit
class BottomCommentArea extends StatelessWidget {
  const BottomCommentArea({
    Key key,
    @required this.formattedDate,
    @required this.comments,
    @required this.user,
  }) : super(key: key);

  final String formattedDate;
  final Comments comments;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
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
                        builder: (context) => ReplyPage(comments, user)),
                  );
                },
              )
            : Text(''),
      ],
    );
  }
}

//Top Area of Comment - Name/Content/Visible Icon (for supervisors)
class TopCommentArea extends StatelessWidget {
  const TopCommentArea({
    Key key,
    @required this.formattedDate,
    @required this.comments,
    @required this.data,
    @required this.user,
  }) : super(key: key);

  final Comments comments;
  final DocumentSnapshot data;
  final FirebaseUser user;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    //RandomColor _randomColor = RandomColor();
    // checkif comment is visible and set icon accordingly
    if (comments.visible == true) {
      visibleIcon = notHiddenIcon;
    } else {
      visibleIcon = hiddenIcon;
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      title: comments.visible
          ? Row(
              children: <Widget>[
                Chip(
                  //padding must be 0 or two letters can be too big
                  padding: EdgeInsets.all(0),
                  avatar: CircleAvatar(
                      backgroundColor: hexToColor(comments.profileColor),
                      child: Text(
                          '${comments.firstName[0]}${comments.lastName[0]}',
                          style: TextStyle(color: Colors.white))),
                  label: Text(
                    '${comments.firstName} ${comments.lastName} - $formattedDate',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Colors.lightBlue[100],
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            )
          : Text(
              'Hidden',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
      subtitle: comments.visible == true
          ? Text('${comments.content}')
          : Text('This comment has been hidden by a moderator.'),
      trailing: role == true
          ? 
          IconButton(
              //color: Colors.red,
              icon: visibleIcon,
              onPressed: () {
                toggleVisibility(data, comments.commentID);
              },
            )
          : null,
          
    );
  }
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

  return Padding(
    //key: ValueKey(replies.parentCommentID),
    padding: const EdgeInsets.only(left: 20.0),
    child: new ReplyCard(
        replies: replies, formattedDate: formattedDate, data: data, user: user),
  );
}

//Reply Card Area
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
                borderRadius: BorderRadius.circular(20.0),),
      elevation: 5.0,
      color: Colors.lightBlue[50],
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              title: replies.visible
                  ? Row(
              children: <Widget>[
                Chip(
                  //padding must be 0 or two letters can be too big
                  padding: EdgeInsets.all(0),
                  avatar: CircleAvatar(
                      backgroundColor: hexToColor(replies.profileColor),
                      child: Text(
                          '${replies.firstName[0]}${replies.lastName[0]}',
                          style: TextStyle(color: Colors.white))),
                  label: Text(
                    '${replies.firstName} ${replies.lastName} - $formattedDate',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Colors.lightBlue[50],
                ),
                Expanded(
                  child: Container(),
                )
              ],
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
            // Divider(color: Color(0xFF1ca5e5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      // Text('$formattedDate'),
                      replies.visible == true
                          ? canEditReply(context, replies, user)
                          : Text(''),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

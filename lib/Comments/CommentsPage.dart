import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


// LOGIC
import 'package:bagcndemo/Comments/commentsLogic.dart';

// MODELS
import 'package:bagcndemo/Models/AnnouncementsModel.dart';

import 'package:bagcndemo/Comments/BuildCommentsReplies/buildCommentsBody.dart';
import 'package:bagcndemo/Style/customColors.dart';



bool role;
bool visible = true;
Icon visibleIcon;
Icon notHiddenIcon =
    Icon(Icons.visibility, color: Color.fromRGBO(28, 165, 229, 1));
Icon hiddenIcon = Icon(Icons.visibility_off, color: Colors.grey);
ScrollController scrollController = new ScrollController();

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
    // PAGE SCAFFOLD \\
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.announcement.title),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: buildCommentsBody(context, widget.announcement, widget.user),
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

// MESSAGE INPUT BAR
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
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onSaved: (input) => _commentController.text = input,
        autofocus: false,
        controller: _commentController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            color: CustomColors.bagcGreen,
            onPressed: () {
              if (_commentController.text.trim().isNotEmpty) {
                createComment(context, widget.user,
                    _commentController.text.trim(), widget.announcement.id);
                _commentController.text = "";
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
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

// // ***BUILD Comments*** \\

// //QUERY COMMENTS BASED ON ANNOUNCEMENT ID
// Widget _buildCommentsBody(
//     BuildContext context, Announcements announcement, FirebaseUser user) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: Firestore.instance
//         .collection('comments')
//         .where('announcementID', isEqualTo: announcement.id)
//         //.where('visible', isEqualTo: true)
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) return LinearProgressIndicator();

//       return _buildCommentsList(context, snapshot.data.documents, user);
//     },
//   );
// }

// //BUILD COMMENTS LIST
// Widget _buildCommentsList(
//     BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
//   return ListView(
//     controller: _scrollController,
//     padding: const EdgeInsets.only(
//       top: 8.0,
//     ),
//     children: snapshot
//         .map((data) => _buildCommentsListItem(context, data, user))
//         .toList(),
//   );
// }

// // BUILD COMMENT CARD
// Widget _buildCommentsListItem(
//     BuildContext context, DocumentSnapshot data, FirebaseUser user) {
//   final comments = Comments.fromSnapshot(data);
//   var formatter = new DateFormat.yMd().add_jm();
//   String formattedDate = formatter.format(comments.created);
//   return Padding(
//     key: ValueKey(comments.announcementID),
//     padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
//     child: new CommentCard(
//         comments: comments,
//         formattedDate: formattedDate,
//         data: data,
//         user: user),
//   );
// }

// // COMMENT CARD - Contains TOP COMMENT AREA and BOTTOM COMMENT AREA widgets
// class CommentCard extends StatelessWidget {
//   const CommentCard({
//     Key key,
//     @required this.comments,
//     @required this.formattedDate,
//     @required this.data,
//     @required this.user,
//   }) : super(key: key);

//   final Comments comments;
//   final String formattedDate;
//   final DocumentSnapshot data;
//   final FirebaseUser user;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       elevation: 5.0,
//       color: Colors.white,
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             new TopCommentArea(
//               comments: comments,
//               data: data,
//               user: user,
//               formattedDate: formattedDate,
//             ),
//             new BottomCommentArea(
//                 formattedDate: formattedDate, comments: comments, user: user),
//             Container(
//                 color: Color.fromRGBO(41, 60, 62, 0.15),
//                 child: buildRepliesBody(context, comments, user),
//                 padding: EdgeInsets.only(bottom: 15)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // BOTTOM COMMENT AREA - CONTAINS Reply/Edit BUTTONS
// class BottomCommentArea extends StatelessWidget {
//   const BottomCommentArea({
//     Key key,
//     @required this.formattedDate,
//     @required this.comments,
//     @required this.user,
//   }) : super(key: key);

//   final String formattedDate;
//   final Comments comments;
//   final FirebaseUser user;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color.fromRGBO(41, 60, 62, 0.15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Expanded(
//             child: Container(),
//           ),
//           comments.visible == true
//               ? canEditComment(context, comments, user)
//               : Text(''),
//           comments.visible == true
//               ? FlatButton(
//                   child: Row(
//                     children: <Widget>[
//                       Icon(
//                         Icons.reply,
//                         color: Color(0xFF1ca5e5),
//                       ),
//                       Text(
//                         'Reply',
//                         style: TextStyle(color: Color(0xFF1ca5e5)),
//                       )
//                     ],
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ReplyPage(comments, user)),
//                     );
//                   },
//                 )
//               : Text(''),
//         ],
//       ),
//     );
//   }
// }

// // TOP COMMENT AREA - CONTAINS Name/Content/Visible Icon
// class TopCommentArea extends StatelessWidget {
//   const TopCommentArea({
//     Key key,
//     @required this.formattedDate,
//     @required this.comments,
//     @required this.data,
//     @required this.user,
//   }) : super(key: key);

//   final Comments comments;
//   final DocumentSnapshot data;
//   final FirebaseUser user;
//   final String formattedDate;

//   @override
//   Widget build(BuildContext context) {
//     if (comments.visible == true) {
//       visibleIcon = notHiddenIcon;
//     } else {
//       visibleIcon = hiddenIcon;
//     }
//     return Column(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
//           child: Row(
//             children: <Widget>[
//               comments.visible
//                   ? Chip(
//                       //padding must be 0 or two letters can be too big
//                       padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
//                       avatar: CircleAvatar(
//                           backgroundColor: hexToColor(comments.profileColor),
//                           child: Text(
//                               '${comments.firstName[0]}${comments.lastName[0]}',
//                               style: TextStyle(color: Colors.white))),
//                       label: Text(
//                         '${comments.firstName} ${comments.lastName}\n$formattedDate',
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white),
//                       ),
//                       backgroundColor: CustomColors.bagcBlue,
//                     )
//                   : Text(
//                       'Hidden',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600, color: Colors.black54),
//                     ),
//               Expanded(
//                 child: Container(),
//               ),
//               role == true
//                   ? IconButton(
//                       icon: visibleIcon,
//                       onPressed: () {
//                         toggleVisibility(data, comments.commentID);
//                       },
//                     )
//                   : Text(''),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
//           child: comments.visible == true
//               ? Text('${comments.content}',
//                   style: TextStyle(color: Colors.black54, fontSize: 14))
//               : Text('This comment has been hidden by a moderator.',
//                   style: TextStyle(color: Colors.black54, fontSize: 14)),
//         )
//       ],
//     );
//   }
// }


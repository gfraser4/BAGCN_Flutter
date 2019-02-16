import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Models/AnnouncementsModel.dart';
import 'Models/Users.dart';
import 'Models/Comments.dart';

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
        backgroundColor: Colors.transparent,
        //title: Text('John Smith'),
      ),
      body: 
      _buildCommentsBody(context, widget.announcement),
      // ListView(
      //   padding: EdgeInsets.zero,
      //   children: <Widget>[
      //     Card(
      //       color: Colors.lightGreen[100],
      //       margin: EdgeInsets.only(top: 0.0, right: 1.0, left: 1.0),
      //       child: ListTile(
      //         title: Text(
      //           '${widget.announcement.title}',
      //           textAlign: TextAlign.left,
      //           style: TextStyle(fontSize: 12.0),
      //         ),
      //         subtitle: Text('${widget.announcement.description}'),
      //         onTap: () {},
      //       ),
      //     ),
          // Container(
          //   color: Colors.lightGreen[50],
          //   margin: EdgeInsets.all(10),
          //   child: TextFormField(
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
          //             createComment(
          //                 context, widget.user, _commentController.text, widget.announcement.id);
          //                 _commentController.text = "";
          //           }),
          //     ),
          //   ),
          // ),
          
        // ],
      //),
    bottomNavigationBar: Container(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.all(10),
            child: TextFormField(
              autofocus: false,
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'New Message...',
                filled: true,
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.lightGreen,
                    ),
                    onPressed: () {
                      createComment(
                          context, widget.user, _commentController.text, widget.announcement.id);
                          _commentController.text = "";
                    }),
              ),
            ),
          ),
    );

  }
}

Future<void> createComment(
    BuildContext context, FirebaseUser user, String content, String announcementID) async {
  DateTime nowTime = new DateTime.now().toUtc();
  DocumentSnapshot snapshot = await Firestore.instance
      .collection('users')
      .document('${user.uid}')
      .get();
  final userInfo = Users.fromSnapshot(snapshot);

  Firestore.instance.collection('comments').document().setData({
    'announcementID': announcementID,
    'content': content,
    'firstName': userInfo.firstName,
    'lastName': userInfo.lastName,
    'created': nowTime,
    'visible' : false
  });
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildCommentsBody(BuildContext context, Announcements announcement) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('comments')
        .where('announcementID', isEqualTo: announcement.id)
        .where('visible', isEqualTo: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildCommentsList(context, snapshot.data.documents);
    },
  );
}

//widget to build list of announcements based on class and class code
Widget _buildCommentsList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot.map((data) => _buildCommentsListItem(context, data)).toList(),
  );
}

//widget to build individual card item for each announcement from original query
Widget _buildCommentsListItem(BuildContext context, DocumentSnapshot data) {
  final comments = Comments.fromSnapshot(data);
  return Padding(
    key: ValueKey(comments.announcementID),
    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
    child:  
    Card(
      elevation: 5.0,
      color: Colors.lightBlue[100],
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                '${comments.firstName} ${comments.lastName}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                  '${comments.content}'),
            ),
            
          ],
        ),
      ),
    ),
  );
}





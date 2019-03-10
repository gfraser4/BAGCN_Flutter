import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Comments/commentsLogic.dart';

// SEE PENDING USERS PAGE
class PendingUsersPage extends StatefulWidget {
  const PendingUsersPage(this.user, this.code);
  final FirebaseUser user;
  final int code;

  @override
  _PendingUsersPage createState() {
    return _PendingUsersPage();
  }
}

class _PendingUsersPage extends State<PendingUsersPage> {

  @override
  Widget build(BuildContext context) {
    //*********** PAGE SCAFFOLD *****************\\
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: null,
      body: _buildEnrolledBody(
        context,
        widget.user,
        widget.code
      ),
    );
  }

// Search query for pending users
  Widget _buildEnrolledBody(BuildContext context, FirebaseUser user, int code) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .where("enrolledPending", arrayContains: widget.code)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildEnrolledList(context, snapshot.data.documents, user, code);
      },
    );
  }

// Build ListView
  Widget _buildEnrolledList(BuildContext context,
      List<DocumentSnapshot> snapshot, FirebaseUser user, int code) {
    return ListView(
      children: snapshot
          .map((data) => _buildEnrolledListItem(context, data, user, code))
          .toList(),
    );
  }

// BUILD EACH PENDING USER
  Widget _buildEnrolledListItem(
      BuildContext context, DocumentSnapshot data, FirebaseUser user, int code) {
    final users = Users.fromSnapshot(data);
    List<String> userID = ['${user.uid}'];
    return Padding(
        key: ValueKey(users.id),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UserCard(users: users, userID: userID, user: user, code: code));
  }
}

// PENDING USER CARD
class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.users,
    @required this.userID,
    @required this.user,
     @required this.code,
  }) : super(key: key);

  final FirebaseUser user;
  final Users users;
  final List<String> userID;
  final int code;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Chip(
              //padding must be 0 or two letters can be too big
              padding: EdgeInsets.all(0),
              avatar: CircleAvatar(
                  backgroundColor: hexToColor(users.profileColor),
                  child: Text('${users.firstName[0]}${users.lastName[0]}',
                      style: TextStyle(color: Colors.white))),
              label: Text(
                '${users.firstName} ${users.lastName}\n${users.email}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.transparent,
            ),
            AllowButton(users: users, userID: userID, code: code),
          ],
        ),
      ),
    );
  }
}

// ADD TO ENROLLMENT BUTTON
class AllowButton extends StatelessWidget {
  const AllowButton({
    Key key,
    @required this.users,
    @required this.userID,
    @required this.code,
  }) : super(key: key);

  final Users users;
  final List<String> userID;
  final int code;
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color.fromRGBO(123, 193, 67, 1),
      child: Text(
        'ALLOW',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Give Access?',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                  color: Color.fromRGBO(0, 162, 162, 1),
                ),
              ),
              content: Text(
                  'Do you want to send ${users.firstName} ${users.lastName} the passcode and allow access to your class?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {

                    // SEND EMAIL WITH PASSCODE \\

                    // users.reference.updateData({
                    //   "enrolledPending": FieldValue.arrayRemove(codeList),
                    // });
                    // users.reference.updateData({
                    //   "enrolledIn": FieldValue.arrayUnion(codeList),
                    // });
                    //AnnouncementLogic.addUserToClass(code, users.id);
                     Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// LOGIC
import 'package:bagcndemo/Comments/commentsLogic.dart';
import 'package:bagcndemo/Announcements/announcementLogic.dart';
// MODELS
import 'package:bagcndemo/Models/Users.dart';

// SEE ENROLLED USERS PAGE
class EnrolledUsersPage extends StatefulWidget {
  const EnrolledUsersPage(this.user, this.code);
  final FirebaseUser user;
  final int code;

  @override
  _EnrolledUsersPage createState() {
    return _EnrolledUsersPage();
  }
}

class _EnrolledUsersPage extends State<EnrolledUsersPage> {
  @override
  Widget build(BuildContext context) {
    //*********** PAGE SCAFFOLD *****************\\
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: null,
      body: _buildEnrolledBody(context, widget.user, widget.code),
    );
  }

// QUERY FRO ENROLLED USERS
  Widget _buildEnrolledBody(BuildContext context, FirebaseUser user, int code) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .where("enrolledIn", arrayContains: widget.code)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildEnrolledList(context, snapshot.data.documents, user, code);
      },
    );
  }

// Build ListView for queried users
  Widget _buildEnrolledList(BuildContext context,
      List<DocumentSnapshot> snapshot, FirebaseUser user, int code) {
    return ListView(
      children: snapshot
          .map((data) => _buildEnrolledListItem(context, data, user, code))
          .toList(),
    );
  }

// WIDGET TO BUILD EACH USER ITEM
  Widget _buildEnrolledListItem(BuildContext context, DocumentSnapshot data,
      FirebaseUser user, int code) {
    final users = Users.fromSnapshot(data);
    List<String> userID = ['${user.uid}'];
    return Padding(
        key: ValueKey(users.id),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: UserCard(users: users, userID: userID, user: user, code: code));
  }
}

// USER CARD
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
                  child: Text(
                      '${users.firstName[0].toUpperCase()}${users.lastName[0].toUpperCase()}',
                      style: TextStyle(color: Colors.white))),
              label: Text(
                '${users.firstName} ${users.lastName}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.transparent,
            ),
            RemoveButton(users: users, userID: userID, code: code),
          ],
        ),
      ),
    );
  }
}

// REMOVE BUTTON - REMOVES USER FROM CLASS
class RemoveButton extends StatelessWidget {
  const RemoveButton({
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
    List<int> codeList = [code];
    return RaisedButton(
      color: Colors.redAccent,
      child: Text(
        'REMOVE',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Close Class?',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                  color: Color.fromRGBO(0, 162, 162, 1),
                ),
              ),
              content: Text(
                  'Are you sure you want to remove ${users.firstName} - ${users.lastName} from your class list?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Remove"),
                  onPressed: () {
                    users.reference.updateData({
                      "enrolledIn": FieldValue.arrayRemove(codeList),
                    });
                    AnnouncementLogic.removeEnrolledUser(code, users.id);
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

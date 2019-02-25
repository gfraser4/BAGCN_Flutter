import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import './parentCommentsPage.dart';
import 'Models/AnnouncementsModel.dart';



Color likeButtonColor = Colors.grey;
Color notifyButtonColor = Colors.grey;

//ParentClassAnnouncementPage WIDGET - SHOWS ANNOUNCEMENTS FOR SPECIFIC CLASS --> REQUIRES A title AND code ARGURMENT PASSED TO IT
class ParentClassAnnouncementPage extends StatefulWidget {
  final FirebaseUser user;
  final String title;
  final int code;
  ParentClassAnnouncementPage(this.title, this.code, this.user);
  @override
  _ParentClassAnnouncementPage createState() {
    return _ParentClassAnnouncementPage();
  }
}

//HOW PAGE IS BUILT
class _ParentClassAnnouncementPage extends State<ParentClassAnnouncementPage> {

@override
  void initState() {
likeButtonColor = likeButtonColor;
notifyButtonColor = notifyButtonColor;
  }

@override
  void setState(fn) {
    likeButtonColor = likeButtonColor;
    notifyButtonColor = notifyButtonColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
            widget.title), //PAGE TITLE BASED ON title THAT WAS PASSED TO PAGE
      ),
      body: _buildBody(
        context,
        widget.title,
        widget.code,
        widget.user,
      ), //HOW BODY IS BUILT PASSING CLASS title AND CLASS code to _buildBody() WIDGET FOR QUERY
    );
  }
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildBody(
    BuildContext context, String title, int code, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('announcements')
        .where('class', isEqualTo: title)
        .where('code', isEqualTo: code)
        //.orderBy('created', descending: true )
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user);
    },
  );
}

//widget to build list of announcements based on class and class code
Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children:
        snapshot.map((data) => _buildListItem(context, data, user)).toList(),
  );
}

//widget to build individual card item for each announcement from original query
Widget _buildListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  List<String> userID = ['${user.uid}'];
  final announcements = Announcements.fromSnapshot(data);
var formatter = new DateFormat.yMd().add_jm();
  String formattedDate = formatter.format(announcements.created);
  //Check if user has liked the announcement already and set color of button accordingly
  if (announcements.likedUsers.contains(user.uid) == true){
    likeButtonColor = Color(0xFF1ca5e5);
  }
  else{
    likeButtonColor = Colors.grey;
  }

//check if users has subscribed to notifications and set button color accordingly
  if (announcements.notifyUsers.contains(user.uid) == true){
    notifyButtonColor = Color(0xFF1ca5e5);
  }
  else{
    notifyButtonColor = Colors.grey;
  }

//add user to liked l ist and increase count like by one or decrease by one
  void _likeButtonClick() {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.likedUsers.contains(user.uid) == false) {
        likeButtonColor = Color(0xFF1ca5e5);
        await transaction.update(announcements.reference, {
          'likes': fresh.likes + 1,
          "likedUsers": FieldValue.arrayUnion(userID)
        });
      } else {
        await transaction.update(announcements.reference, {
          'likes': fresh.likes - 1,
          "likedUsers": FieldValue.arrayRemove(userID)
        });
        likeButtonColor = Colors.grey;
      }
    });
  }


  //keep track of who has subrscribed to announcement-comments notifications
  void _notifyClick() {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.notifyUsers.contains(user.uid) == false) {
        notifyButtonColor = Color(0xFF1ca5e5);
        await transaction.update(announcements.reference, {
          "notifyUsers": FieldValue.arrayUnion(userID)
        });
        print('added');
      } else {
        await transaction.update(announcements.reference, {
          "notifyUsers": FieldValue.arrayRemove(userID)
        });
        notifyButtonColor = Colors.grey;
        print('removed');
      }
    });
  }

  return Padding(
    key: ValueKey(announcements.clsName),
    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
    child: Card(
      elevation: 5.0,
      color: Colors.lightBlue[100],
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                announcements.title,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                  'Posted to: ${announcements.clsName}\nPosted on: $formattedDate\n\n${announcements.description}'),
            ),
            Divider(
              color: Color(0xFF1ca5e5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: likeButtonColor,
                        onPressed: () {
                          _likeButtonClick();
                        },
                      ),
                      Text(announcements.likes.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: likeButtonColor,
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.forum),
                        color: Color(0xFF1ca5e5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ParentsCommentsPage(announcements, user)),
                          );
                        },
                      ),
                      Text(announcements.commentCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1ca5e5),
                          )),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.notifications_active),
                  color: notifyButtonColor,
                  onPressed: () {
                    _notifyClick();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

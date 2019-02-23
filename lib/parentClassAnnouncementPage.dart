import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './parentCommentsPage.dart';
import 'Models/AnnouncementsModel.dart';

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
  Color _likeButtonColor = Color(0xFF1ca5e5);
  final announcements = Announcements.fromSnapshot(data);
  
  
  void _likeButtonClick() {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(announcements.reference);
      final fresh = Announcements.fromSnapshot(freshSnapshot);
      if (fresh.likedUsers.contains(user.uid) == false) {
          //_likeButtonColor = Colors.yellow;
        print(_likeButtonColor);
        await transaction.update(announcements.reference, {
          'likes': fresh.likes + 1,
          "likedUsers": FieldValue.arrayUnion(userID)
        });
        
      } else {
        await transaction.update(announcements.reference, {
          'likes': fresh.likes - 1,
          "likedUsers": FieldValue.arrayRemove(userID)
        });
        print(_likeButtonColor);

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
                  'Posted to: ${announcements.clsName}\nPosted on: ${announcements.created}\n\n${announcements.description}'),
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
                          color: _likeButtonColor,
                          onPressed: () {
                            _likeButtonClick();
                          },),
                      Text(announcements.likes.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1ca5e5),
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
                      Text('0',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1ca5e5),
                          )),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Color(0xFF1ca5e5),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

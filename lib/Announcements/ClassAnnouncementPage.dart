import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/CreateAnnouncement/createAnnouncement.dart';
import 'package:bagcndemo/Comments/CommentsPage.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';

Color likeButtonColor = Colors.grey;
Color notifyButtonColor = Colors.grey;
bool role;

//ParentClassAnnouncementPage WIDGET - SHOWS ANNOUNCEMENTS FOR SPECIFIC CLASS --> REQUIRES A title AND code ARGURMENT PASSED TO IT
class ClassAnnouncementPage extends StatefulWidget {
  final FirebaseUser user;
  final String title;
  final int code;
  final bool isSuper;
  ClassAnnouncementPage(this.title, this.code, this.user, this.isSuper);
  @override
  _ClassAnnouncementPage createState() {
    return _ClassAnnouncementPage();
  }
}

//HOW PAGE IS BUILT
class _ClassAnnouncementPage extends State<ClassAnnouncementPage> {
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
    role = widget.isSuper;
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
        ),
        floatingActionButton: role == true
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnnouncementPage(
                            widget.title,
                            widget
                                .code)), //NAVIGATION TO CREATE ANNOUNCEMENT --> AGAIN PASSING title AND code SO ANNOUNCEMENT IS MADE FOR SPECIFIC CLASS
                  );
                },
              )
            : null //HOW BODY IS BUILT PASSING CLASS title AND CLASS code to _buildBody() WIDGET FOR QUERY
        );
  }
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildBody(
    BuildContext context, String title, int code, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: AnnouncementLogic.announcementStream(title, code),
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
  if (announcements.likedUsers.contains(user.uid) == true) {
    likeButtonColor = Color(0xFF1ca5e5);
  } else {
    likeButtonColor = Colors.grey;
  }

//check if users has subscribed to notifications and set button color accordingly
  if (announcements.notifyUsers.contains(user.uid) == true) {
    notifyButtonColor = Color(0xFF1ca5e5);
  } else {
    notifyButtonColor = Colors.grey;
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
                          AnnouncementLogic.likeButtonClick(user, likeButtonColor, announcements);
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
                                    CommentsPage(announcements, user, role)),
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
                role == true
                    ? IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: notifyButtonColor,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actions: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.edit,
                                              color: Color(0xFF1ca5e5),
                                            ),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Color(0xFF1ca5e5)),
                                            )
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                      FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.notifications_active,
                                              color: Color(0xFF1ca5e5),
                                            ),
                                            Text(
                                              'Alerts',
                                              style: TextStyle(
                                                  color: Color(0xFF1ca5e5)),
                                            )
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                      
                                      FlatButton(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.delete,
                                              color: Color(0xFF1ca5e5),
                                            ),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Color(0xFF1ca5e5)),
                                            )
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.notifications_active),
                        color: notifyButtonColor,
                        onPressed: () {
                         AnnouncementLogic.notifyClick(user, notifyButtonColor, announcements);
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/Announcements/editAnnouncementPage.dart';
import 'package:bagcndemo/CreateAnnouncement/createAnnouncement.dart';
import 'package:bagcndemo/Comments/CommentsPage.dart';
import 'package:bagcndemo/Models/AnnouncementsModel.dart';

// import 'package:bagcndemo/Models/Users.dart';

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
                              widget.code,
                              widget.user,
                            )), //NAVIGATION TO CREATE ANNOUNCEMENT --> AGAIN PASSING title AND code SO ANNOUNCEMENT IS MADE FOR SPECIFIC CLASS
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

// var name =
//   Firestore.instance.collection('users').document(announcements.postedBy).get().then(
//       (DocumentSnapshot doc) => print(doc.data['firstName'].toString()));
// print(name);

  Widget announcementEdit(
      BuildContext context, Announcements announcements, FirebaseUser user) {
    final _editAnnouncemntController = new TextEditingController();
    _editAnnouncemntController.text = announcements.description;
    if (user.uid == announcements.postedBy) {
      return AlertDialog(
        title: Text('Edit announcement...'),
        content: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          autofocus: false,
          controller: _editAnnouncemntController,
          decoration: InputDecoration(
            hintText: announcements.description,
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
            child: Text("Edit"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditAnnouncementPage(announcements, user)),
              );
            },
          ),
        ],
      );
    } else {
      return Expanded(
        child: Container(),
      );
    }
  }

//supervisor Popup menu
  final supervisorMenu = AlertDialog(
    content: Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  style: TextStyle(color: Color(0xFF1ca5e5)),
                )
              ],
            ),
            onPressed: () {
              if (user.uid == announcements.postedBy) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditAnnouncementPage(announcements, user)),
                );
              }
            },
          ),
         announcements.notifyUsers.contains(user.uid) == true ? FlatButton(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.notifications_active,
                  color: Color(0xFF1ca5e5),
                ),
                Text(
                  'Alerts',
                  style: TextStyle(color: Color(0xFF1ca5e5)),
                )
              ],
            ),
            onPressed: () {
              AnnouncementLogic.notifyClick(
                  user, announcements);
            },
          ) : FlatButton(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.notifications_off,
                  color: Colors.grey,
                ),
                Text(
                  'Alerts',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            onPressed: () {
              AnnouncementLogic.notifyClick(
                  user, announcements);
            },
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
                      'Delete Announcement?',
                      style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 162, 162, 1)),
                    ),
                    content: Text(
                        'Are you sure you want to delete this announcement? This will permanently remove all associated comments.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Delete"),
                        onPressed: () {
                          AnnouncementLogic.deleteAnnouncement(
                              announcements.id);
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
    ),
  );

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
                  'Posted on: ${announcements.clsName} \nPosted on: $formattedDate\n\n${announcements.description}'),
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
                      announcements.likedUsers.contains(user.uid) == true ? IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: Color(0xFF1ca5e5),
                        onPressed: () {
                          AnnouncementLogic.likeButtonClick(
                              user, announcements);
                        },
                      ) : IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: Colors.grey,
                        onPressed: () {
                          AnnouncementLogic.likeButtonClick(
                              user, announcements);
                        },
                      ),
                      announcements.likedUsers.contains(user.uid) == true ? Text(announcements.likes.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1ca5e5),
                          ),) : Text(announcements.likes.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          )) 
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
                        color: Color(0xFF1ca5e5),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return supervisorMenu;
                              });
                        },
                      )
                    : announcements.notifyUsers.contains(user.uid) == true ? IconButton(
                        icon: Icon(Icons.notifications_active),
                        color: Color(0xFF1ca5e5),
                        onPressed: () {
                          AnnouncementLogic.notifyClick(
                              user, announcements);
                        },
                      ) : IconButton(
                        icon: Icon(Icons.notifications_off),
                        color: Colors.grey,
                        onPressed: () {
                          AnnouncementLogic.notifyClick(
                              user, announcements);
                        },
                      )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

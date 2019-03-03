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
bool _isSearch;
TextEditingController searchValueController = new TextEditingController();
String searchString = '';

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
    void initState(){
      super.initState();
      _isSearch = false;
    }

  @override
  Widget build(BuildContext context) {
    role = widget.isSuper;
    return Scaffold(
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: _isSearch? searchArea():Text(widget.title), //PAGE TITLE BASED ON title THAT WAS PASSED TO PAGE
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
              onPressed: (){_search();}
          )
        ],
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
                  _isSearch = false;
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

  //SEARCH METHOD
  void _search(){
      if(!_isSearch)
        setState(() {
          _isSearch = true;
        });
      else{
        searchString = searchValueController.text;
        setState(() {
          _isSearch = false;
        });
      }
    }
    //SEARCH TEXT AREA
    Container searchArea(){
      return Container(
        margin: const EdgeInsets.only(top:4),
        child:TextField(
        controller:searchValueController,
        decoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        autofocus: true,
        ),
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

//filter body content by search string
  // if(!(announcements.title.contains(searchString)||announcements.description.contains(searchString)))
  //   return null;

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
          // Notifications on or off
          announcements.notifyUsers.contains(user.uid) == true
              ? FlatButton(
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
                    AnnouncementLogic.notifyClick(user, announcements);
                  },
                )
              : FlatButton(
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
                    AnnouncementLogic.notifyClick(user, announcements);
                  },
                ),
          new DeleteButton(announcements: announcements),
        ],
      ),
    ),
  );

// Announcement Card
  return Padding(
    key: ValueKey(announcements.clsName),
    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
    child: Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 5.0,
      color: Colors.white,
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                announcements.title,
                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black87),
              ),
              subtitle: RichText(
                  text: new TextSpan(style: TextStyle(color: Colors.black54),
                  children: <TextSpan>[
                    new TextSpan(
                      text: '${announcements.clsName}',
                      style: TextStyle(),
                    ),
                    new TextSpan(
                      text: '\n$formattedDate',
                      style: TextStyle(),
                    ),
                    new TextSpan(
                      text: '\n\n${announcements.description}',
                      style: TextStyle(),
                    ),
                  ]
                  )
                  ),
            ),
            SizedBox(height: 16,),
            Container(
            color: Color.fromRGBO(41, 60, 62, 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new LikeButton(announcements: announcements, user: user),
                new CommentsButton(announcements: announcements, user: user),
                //Popup for supervisors or notification for parents
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
                    : announcements.notifyUsers.contains(user.uid) == true
                        ? IconButton(
                            icon: Icon(Icons.notifications_active),
                            color: Color(0xFF1ca5e5),
                            onPressed: () {
                              AnnouncementLogic.notifyClick(
                                  user, announcements);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.notifications_off),
                            color: Colors.grey,
                            onPressed: () {
                              AnnouncementLogic.notifyClick(
                                  user, announcements);
                            },
                          ),
              ],
            )
            ),
          ],
        ),
      ),
    ),
  );
}

//Delete Button
class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key key,
    @required this.announcements,
  }) : super(key: key);

  final Announcements announcements;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
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
                    AnnouncementLogic.deleteAnnouncement(announcements.id);
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

//Comments Button
class CommentsButton extends StatelessWidget {
  const CommentsButton({
    Key key,
    @required this.announcements,
    @required this.user,
  }) : super(key: key);

  final Announcements announcements;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.forum),
            color: Color(0xFF1ca5e5),
            onPressed: () {
              _isSearch = false;
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
    );
  }
}

//Like Button
class LikeButton extends StatelessWidget {
  const LikeButton({
    Key key,
    @required this.announcements,
    @required this.user,
  }) : super(key: key);

  final Announcements announcements;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          announcements.likedUsers.contains(user.uid) == true
              ? IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: Color(0xFF1ca5e5),
                  onPressed: () {
                    AnnouncementLogic.likeButtonClick(user, announcements);
                  },
                )
              : IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: Colors.grey,
                  onPressed: () {
                    AnnouncementLogic.likeButtonClick(user, announcements);
                  },
                ),
          announcements.likedUsers.contains(user.uid) == true
              ? Text(
                  announcements.likes.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1ca5e5),
                  ),
                )
              : Text(announcements.likes.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ))
        ],
      ),
    );
  }
}

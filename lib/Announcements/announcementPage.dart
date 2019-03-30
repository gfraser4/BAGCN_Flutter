import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
// LOGIC
import 'package:bagcndemo/Announcements/announcementLogic.dart';
// MODELS
import 'package:bagcndemo/Models/AnnouncementsModel.dart';
// PAGES
import 'package:bagcndemo/Announcements/deleteButton.dart';
import 'package:bagcndemo/Announcements/likeButton.dart';
import 'package:bagcndemo/Announcements/EditAnnouncement/editAnnouncementPage.dart';
import 'package:bagcndemo/Announcements/CreateAnnouncement/createAnnouncement.dart';
import 'package:bagcndemo/Comments/CommentsPage.dart';
import 'package:bagcndemo/Announcements/UserManagement/enrolledUsersPage.dart';
import 'package:bagcndemo/Announcements/UserManagement/pendingEnrollmentUsers.dart';

int enrolledCount;
int pendingCount;
bool role;
// bool _isSearch;
TextEditingController searchValueController = new TextEditingController();
String searchString = '';

// ANNOUNCEMENT PAGE - SHOWS ANNOUNCEMENTS FOR SPECIFIC CLASS
class ClassAnnouncementPage extends StatefulWidget {
  final FirebaseUser user;
  final String title;
  final int code;
  final bool isSuper;
  final Classes classes;
  ClassAnnouncementPage(
      this.title, this.code, this.user, this.isSuper, this.classes);
  @override
  _ClassAnnouncementPage createState() {
    return _ClassAnnouncementPage();
  }
}

class _ClassAnnouncementPage extends State<ClassAnnouncementPage> {
  enrolledUserCount(int code) {
    countEnrolledFuture(code).then((x) {
      if (mounted) {
        setState(() {
          enrolledCount = x;
        });
      }
    });
  }

  Future<int> countEnrolledFuture(int code) async {
    Firestore db = Firestore.instance;
    int n;
    QuerySnapshot _queryClasses = await db
        .collection('class')
        .where('code', isEqualTo: code)
        .getDocuments();
    _queryClasses.documents.toList();
    final users = Classes.fromSnapshot(_queryClasses.documents.first);
    n = users.enrolledUsers.length;
    return n;
  }

  pendingUserCount(int code) {
    countPendingFuture(code).then((x) {
      if (mounted) {
        setState(() {
          pendingCount = x;
        });
      }
    });
  }

  Future<int> countPendingFuture(int code) async {
    Firestore db = Firestore.instance;
    int n;
    QuerySnapshot _queryClasses = await db
        .collection('class')
        .where('code', isEqualTo: code)
        .getDocuments();
    _queryClasses.documents.toList();
    final users = Classes.fromSnapshot(_queryClasses.documents.first);
    n = users.pendingUsers.length;
    return n;
  }

// @override
//   void setState(fn) {
//     if (mounted) {
//     enrolledUserCount(widget.code);
//     pendingUserCount(widget.code);
//     super.setState(fn);
//     }
//   }

// @override
//   void initState() {
//     enrolledUserCount(widget.code);
//     pendingUserCount(widget.code);
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    role = widget.isSuper;
    //get enrolled user count
enrolledUserCount(widget.code);
    pendingUserCount(widget.code);

    return buildScaffold(
        context, widget.title, widget.code, widget.user, widget.isSuper);
  }

  // SCAFFOLD DEPENDING ON PARENT OR SUPERVISOR
  Widget buildScaffold(
    BuildContext context,
    String title,
    int code,
    FirebaseUser user,
    bool isSuper,
  ) {
    // PARENT SCAFFOLD
    if (!isSuper) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            // SEARCH ANNOUNCEMENTS ICON
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {
            //     _search();
            //   },
            // ),
          ],
        ),
        body: buildAnnouncementBody(
          context,
          title,
          code,
          user,
        ),
      );
    }
    // SUPERVISOR SCAFFOLD \\
    else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.announcement)),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.group),
                      Container(
                        child: Text(
                          '$enrolledCount',
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.group_add),
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          '$pendingCount',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            title:
                //  _isSearch
                //     ? searchArea() :
                Text(widget.title),
            actions: <Widget>[
              // SEARCH ANNOUNCEMENTS ICON
              // IconButton(
              //   icon: Icon(Icons.search),
              //   onPressed: () {
              //     _search();
              //   },
              // ),
            ],
          ),
          // TABS
          body: TabBarView(
            children: <Widget>[
              buildAnnouncementBody(
                context,
                widget.title,
                widget.code,
                widget.user,
              ),
              EnrolledUsersPage(widget.user, widget.code),
              PendingUsersPage(widget.user, widget.code, widget.classes),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            onPressed: () {
              // _isSearch = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementPage(
                        widget.title,
                        widget.code,
                        widget.user,
                      ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  // SEARCH METHOD
  // void _search() {
  //   if (!_isSearch)
  //     setState(() {
  //       _isSearch = true;
  //     });
  //   else {
  //     searchString = searchValueController.text;
  //     setState(() {
  //       _isSearch = false;
  //     });
  //   }
  // }

  //SEARCH TEXT AREA
  Container searchArea() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: TextField(
        controller: searchValueController,
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
Widget buildAnnouncementBody(
    BuildContext context, String title, int code, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: AnnouncementLogic.announcementStream(title, code),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user, code);
    },
  );
}

// widget to build list of announcements based on class and class code
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, int code) {
  // return horizaontal scroll for homepage else return vertical scroll
  return code != 0
      ? ListView(
          padding: const EdgeInsets.only(top: 8.0),
          children: snapshot
              .map((data) => _buildListItem(context, data, user))
              .toList(),
        )
      : ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 8.0),
          children: snapshot
              .map((data) => _buildListItem(context, data, user))
              .toList(),
        );
}

// widget to build individual card item for each announcement from original query
Widget _buildListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  MediaQueryData queryData;

  queryData = MediaQuery.of(context);
  final announcements = Announcements.fromSnapshot(data);
  var formatter = new DateFormat.yMd().add_jm();
  String formattedDate = formatter.format(announcements.created);

// SUPERVISOR POP UP MENU
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
        width: announcements.clsName == 'Boys and Girls Club Niagara'
            ? queryData.size.width - 20
            : null,
        child: Column(
          children: <Widget>[
            new AnouncementText(
                announcements: announcements, formattedDate: formattedDate),
            SizedBox(
              height: 16,
            ),
            announcements.clsName == 'Boys and Girls Club Niagara'
                ? Expanded(
                    child: Container(),
                  )
                : Text(''),
            Container(
              color: Color.fromRGBO(41, 60, 62, 0.15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new LikeButton(announcements: announcements, user: user),
                  new CommentsButton(announcements: announcements, user: user),
                  // POP UP FOR SUPERVISORS OR NOTIFICATION BUTTON FOR PARENTS
                  announcements.clsName == 'Boys and Girls Club Niagara'
                      ? Expanded(
                          child: Container(),
                        )
                      : role == true
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
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ANNOUNCEMENT LAYOUT FOR TITLE/DATE/DESCRIPTION
class AnouncementText extends StatelessWidget {
  const AnouncementText({
    Key key,
    @required this.announcements,
    @required this.formattedDate,
  }) : super(key: key);

  final Announcements announcements;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(
        announcements.title,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: RichText(
        maxLines: 20,
        overflow: TextOverflow.ellipsis,
        text: new TextSpan(
          style: TextStyle(color: Colors.black54),
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
          ],
        ),
      ),
    );
  }
}

// COMMENTS BUTTON
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
              // _isSearch = false;
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

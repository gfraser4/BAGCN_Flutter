//STANDARD MATERIAL LIBRARY AND FIRESTORE LIBRARY
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//IMPORT OTHER PAGES SO CAN BE NAVIGATED TO
import './aboutPage.dart';
import './addClassesPage.dart';
import './messagesPage.dart';
import './settingsPage.dart';
import './classAnnouncementPage.dart';
import './loginPage.dart';
import './signupPage.dart';
import './parentClassAnnouncementPage.dart';

//Imported Models
import 'Models/ClassesModel.dart';

///////////////////////////////////////////////////////////
//**MAIN FUNCTION TO LAUNCH APP --> CALLS MyApp() WIDGET**\\
///////////////////////////////////////////////////////////

void main() => runApp(MyApp());

//MyApp WIDGET - OVERALL APP STYLING AND ROUTES
class MyApp extends StatelessWidget {
  final appTitle = 'BAGC Niagara';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Page routes --> defaults at login for now
      initialRoute: '/',
      routes: {
        //'/main': (context) => MyClassList(),
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
      //Theme data for app *FONT NOT CURRENTLY WORKING*
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.bagcGreen,
        accentColor: Colors.bagcLightBlue,
        hintColor: Colors.bagcDarkBlue.withOpacity(0.7),
        errorColor: Colors.bagcRed,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0),
        ),
      ),
      title: appTitle,
    );
  }
}

//STATELESS WIDGET --> CONTENT STAYS THE SAME, DON't NEED TO REBUILD
//STATEFUL WIDGET --> CONTENT CHANGING, PAGE WILL REBUILD

////////////////////////////////////////////////////////////////////////////////////////////
//**MyClassList WIDGET - MY CLASSES PAGE CLASS -- HOW THE MAIN PAGE LOADS AND ITS CONTENT**\\
////////////////////////////////////////////////////////////////////////////////////////////

class MyClassList extends StatefulWidget {
  const MyClassList(this.user);
  final FirebaseUser user;

  @override
  _MyClassList createState() {
    return _MyClassList();
  }
}

//LAYOUT OF MY CLASSES PAGE --> CALLS WIDGETS BELOW IT
class _MyClassList extends State<MyClassList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], //PAGE BACKGROUND COLOUR
      appBar: AppBar(
          title:
              Text('My Classes ${widget.user.email}')), //PAGE APP BAR AND TITLE
      body: _buildBody(
          context, widget.user), //PAGE CONTENT --> CALLING _buildBody WIDGET
      floatingActionButton: FloatingActionButton(
        //FLOATING ACTION BUTTON TO ADD CLASSES
        child: Icon(Icons.add),
        onPressed: () {
          //BUTTON PRESSED EVENT --> NAVIGATES TO AddClassesPAGE()
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddClassesPage(widget.user)),
          );
        },
      ),
      drawer: _navDrawer(context,
          widget.user), //BUILDS MENU DRAWER BY CALLING _navDrawer WIDGET
    );
  }
}
///////////////////////////////////
//**HAMBURGER DRAWER MENU WIDGET**\\
////////////////////////////////////

Widget _navDrawer(BuildContext context, FirebaseUser user) {
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
          child: Image.asset(
            'assets/BGC_Niagara_logo.png',
          ),
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0, // has the effect of softening the shadow
                spreadRadius: 0.7, // has the effect of extending the shadow
                offset: Offset(
                  -1.0, // horizontal, move right 10
                  1.0, // vertical, move down 10
                ),
              ),
            ],
            color: Colors.lightGreen[100],
          ),
        ),
        ListTile(
          trailing: Icon(
            Icons.announcement,
            color: Color(0xFF1ca5e5),
          ),
          title: Text('Messages'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagesPage()),
            );
          },
        ),
        Divider(
          color: Color(0xFF1ca5e5),
        ),
        ListTile(
          title: Text('Manage Classes'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddClassesPage(user)),
            );
          },
        ),
        Divider(
          color: Color(0xFF1ca5e5),
        ),
        ListTile(
          title: Text('Profile Settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        Divider(
          color: Color(0xFF1ca5e5),
        ),
        ListTile(
          title: Text('About'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
        ),
        Divider(
          color: Color(0xFF1ca5e5),
        ),
        ListTile(
          title: Text('Sign Out'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
          },
        ),
        Divider(
          color: Color(0xFF1ca5e5),
        ),
      ],
    ),
  );
}

//////////////////////////////////////////////
/*MAIN PAGE BUSINESS LOGIC */
/////////////////////////////////////////////

//QUERY FIRESTORE FOR ALL CLASSES FOR A USER --> currently using hardcoded userid 'lj@gmail.com' in where clause, this will need to be dynamic for userid
Widget _buildBody(BuildContext context, FirebaseUser user) {
  String userID = user.uid;
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('class')
        .where('enrolledUsers', arrayContains: userID)
        //.orderBy('clsName')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      //call to build map of database query --> see next widget
      return _buildList(context, snapshot.data.documents, user);
    },
  );
}

//widget to build list of classes for user based on previous widget query
Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children:
        snapshot.map((data) => _buildListItem(context, data, user)).toList(),
  );
}

//widget to build individual item for each class from original query
Widget _buildListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final classes = Classes.fromSnapshot(data);
  List<String> userID = ['${user.uid}'];
  return Column(
    children: <Widget>[
      Container(
        decoration: new BoxDecoration(color: Colors.lightBlue[50]),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 3.0, vertical: 8.0),
            title: Text('${classes.clsName} - ${classes.code}',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
                '\nDates: ${classes.dates}\nTimes: ${classes.times}\nLocation: ${classes.location}'),
            leading: IconButton(
              icon: Icon(Icons.settings),
              color: Colors.grey,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Remove Class?'),
                      content: Text(
                          'Are you sure you want to remove ${classes.clsName} - ${classes.code} from your class list?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("Accept"),
                          onPressed: () {
                            classes.reference.updateData({
                              "enrolledUsers": FieldValue.arrayRemove(userID)
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              color: Color(0xFF1ca5e5),
              onPressed: () {
                checkRole(context, user, classes.code, classes.clsName);
              },
            ),
            onTap: () {
              checkRole(context, user, classes.code, classes.clsName);
            }),
      ),
      Divider(
        color: Colors.lightBlue,
      ),
    ],
    key: ValueKey(classes.clsName),
    // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
}

////////////////////////
//**CHECK ROLE METHOD**\\
////////////////////////

//future waiting for database response --> check role and send to right page depending on it
Future<void> checkRole(BuildContext context, FirebaseUser user, int classCode, String className) async {
DocumentSnapshot snapshot = await Firestore.instance.collection('users').document('${user.uid}').get();
  if (snapshot['role'] == 'super') {
    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClassPage(
                            className,
                            classCode,
                            user)), //ICON BUTTON NAVIGATES TO ANNOUNCEMENT PAGE AND PASSES THE CLASSNAME AND CODE
                  );
  }
  else {
    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ParentClassAnnouncementPage(
                          className,
                          classCode,
                          user)), //ICON BUTTON NAVIGATES TO ANNOUNCEMENT PAGE AND PASSES THE CLASSNAME AND CODE
                );
  }
}


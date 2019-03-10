//STANDARD MATERIAL LIBRARY AND FIRESTORE LIBRARY
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//IMPORTED PAGES
import 'package:bagcndemo/AddClasses/addClassesLogic.dart';
import 'package:bagcndemo/MyClasses/myClassesLogic.dart';
import 'package:bagcndemo/MyClasses/navDrawer.dart';

//Imported Models
import 'package:bagcndemo/Models/ClassesModel.dart';

//**MyClassList WIDGET - MY CLASSES PAGE CLASS -- HOW THE MAIN PAGE LOADS AND ITS CONTENT**\\

class MyClassList extends StatefulWidget {
  const MyClassList(this.user, this.isSuper);
  final FirebaseUser user;
  final bool isSuper;

  @override
  _MyClassList createState() {
    return _MyClassList();
  }
}

// LAYOUT OF MY CLASSES PAGE --> CALLS WIDGETS BELOW IT

class _MyClassList extends State<MyClassList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Classes ${widget.user.email}'),
      ),
      body: _buildBody(context, widget.user,
          widget.isSuper), //PAGE CONTENT --> CALLING _buildBody WIDGET
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (!widget.isSuper) {
            MyClassesLogic.navToJoinClasses(context, widget.user);
          } else {
            MyClassesLogic.navToAddClasses(context, widget.user);
          }
        },
      ),
      drawer: navDrawer(context, widget.user,
          widget.isSuper), //BUILDS MENU DRAWER BY CALLING navDrawer WIDGET
    );
  }
}

// MAIN PAGE Build //

// QUERY FIRESTORE FOR ALL CLASSES FOR A USER
Widget _buildBody(BuildContext context, FirebaseUser user, bool isSuper) {
  String userID = user.uid;

  return StreamBuilder<QuerySnapshot>(
    stream: MyClassesLogic.buildStream(userID, isSuper),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      //call to build map of database query --> see next widget
      return _buildList(context, snapshot.data.documents, user, isSuper);
    },
  );
}

// Widget to build list of classes for user based on previous widget query
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, bool isSuper) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot
        .map((data) => _buildListItem(context, data, user, isSuper))
        .toList(),
  );
}

// LIST ITEM CONTAINER
Widget _buildListItem(BuildContext context, DocumentSnapshot data,
    FirebaseUser user, bool isSuper) {
  final classes = Classes.fromSnapshot(data);
  List<String> userID = ['${user.uid}'];
  return Column(
    children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              offset: new Offset(3.0, 3.0),
              blurRadius: 1,
            ),
          ],
          borderRadius: new BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: <Widget>[
            new ClassTileWidget(
                classes: classes, userID: userID, user: user, isSuper: isSuper),
          ],
        ),
      ),
    ],
    key: ValueKey(classes.clsName),
  );
}

// CLASS TILE LAYOUT
class ClassTileWidget extends StatelessWidget {
  const ClassTileWidget({
    Key key,
    @required this.classes,
    @required this.userID,
    @required this.user,
    @required this.isSuper,
  }) : super(key: key);

  final Classes classes;
  final List<String> userID;
  final FirebaseUser user;
  final bool isSuper;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
      // CLASS TITLE AND CODE
      title: Text('${classes.clsName} - ${classes.code}',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(41, 60, 62, 1))),
      subtitle: new ClassDescriptionArea(classes: classes),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MyClassesLogic.notifyButtonRender(user, classes),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new RemoveClassAlert(
                            classes: classes,
                            isSuper: isSuper,
                            userID: userID,
                            user: user);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.chevron_right),
        color: Color(0xFF1ca5e5),
        onPressed: () {
          MyClassesLogic.navToAnnouncements(context, user, classes, isSuper);
        },
      ),
      onTap: () {
        MyClassesLogic.navToAnnouncements(context, user, classes, isSuper);
      },
    );
  }
}

// CLASS DESCRIPTION AREA (SUBTITLE OF LIST TILE)
class ClassDescriptionArea extends StatelessWidget {
  const ClassDescriptionArea({
    Key key,
    @required this.classes,
  }) : super(key: key);

  final Classes classes;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Color.fromRGBO(41, 60, 62, 1).withAlpha(180),
        ),
        children: <TextSpan>[
          new TextSpan(
              text: 'Dates: ',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: '${classes.dates}'),
          new TextSpan(
              text: '\nTimes: ',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: '${classes.times}'),
          new TextSpan(
              text: '\nLocation: ',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: '${classes.location}'),
        ],
      ),
    );
  }
}

// REMOVE CLASS ALERT DIALOG BOX
class RemoveClassAlert extends StatelessWidget {
  const RemoveClassAlert({
    Key key,
    @required this.classes,
    @required this.isSuper,
    @required this.userID,
    @required this.user,
  }) : super(key: key);

  final Classes classes;
  final bool isSuper;
  final List<String> userID;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Remove Class?',
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.normal,
            color: Color.fromRGBO(0, 162, 162, 1)),
      ),
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
            isSuper
                ? ClassMGMTLogic.closeClass(context, classes, userID, user)
                : ClassMGMTLogic.removeClass(context, classes, userID, user);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

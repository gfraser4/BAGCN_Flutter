import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';

import 'package:bagcndemo/AddClasses/addClassesLogic.dart';
import 'package:bagcndemo/Models/ClassesModel.dart';

String _search = '';

//SEARCH AND ADD CLASSES PAGE
class AddClassesPage extends StatefulWidget {
  const AddClassesPage(this.user);
  final FirebaseUser user;

  @override
  _AddClassesPage createState() {
    return _AddClassesPage();
  }
}

class _AddClassesPage extends State<AddClassesPage> {
  final _searchController =
      new TextEditingController(); //VAR TO HOLD CLASSNAME INPUT
  // final _classCodeController = new TextEditingController(); //VAR TO HOLD CLASSCODE INPUT
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Classes');

  var stream = Firestore.instance
      .collection('class')
      .orderBy('clsName')
      .snapshots(); //DEFAULT QUERY TO LIST ALL CLASSES IN DATABASE

  @override
  Widget build(BuildContext context) {
    _search = _searchController.text;
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _search = "";
        });
      } else {
        setState(() {
          _search = _searchController.text;
        });
      }
    });

//search icon is pressed toggle bvetween input and title
    void _searchPressed() {
      setState(() {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            autofocus: true,
            controller: _searchController,
            decoration: new InputDecoration(
                border: InputBorder.none,
                // prefixIcon: new Icon(Icons.search),
                hintText: 'Search...'),
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text('Search Classes');
          _searchController.clear();
        }
      });
    }

//Appbar main layout
    Widget _buildBar(BuildContext context) {
      return new AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ],
      );
    }

//******************************************\\
//*********** page scaffold *****************\\
//********************************************\\
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: _buildBar(context),
      body: _buildBody(
        context,
        stream,
        widget.user,
      ), //SEARCH RESULTS AREA IS BUILT PASSING DYNAMIC QUERY(stream)
    );
  }

//Search querey dynamic based on search criteria
  Widget _buildBody(BuildContext context, var stream, FirebaseUser user) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream, //QUERY (stream) WILL BE DEPENDENT ON SEARCH FIELDS
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents, user);
      },
    );
  }

//Build ListView for queried items based on above query
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      FirebaseUser user) {
    return ListView(
      //padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildListItem(context, data, user)).toList(),
    );
  }

//WIDGET TO BUILD WACH CLASS ITEM --> Username needed to add classes to that usres class list on their home screen (currently hardcoded as "lj@gmail.com")
  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, FirebaseUser user) {
    final classes = Classes.fromSnapshot(data);
    List<String> userID = ['${user.uid}'];
    return Padding(
      key: ValueKey(classes.clsName),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: contains(classes.clsName, _search.toUpperCase()) ||
              contains(classes.code.toString(), _search.toUpperCase())
          ? new ClassCard(classes: classes, userID: userID, user: user)
          : null,
    );
  }
}

//Class Cards
class ClassCard extends StatelessWidget {
  const ClassCard({
    Key key,
    @required this.classes,
    @required this.userID,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;
  final Classes classes;
  final List<String> userID;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF4F5F7),
      elevation: 5.0,
      child: ListTile(
        title: Text(classes.clsName),
        subtitle: Text('Course Code: ${classes.code}'),
        trailing: classes.enrolledUsers.contains(user.uid) == false
            ? new JoinButton(classes: classes, userID: userID)
            : new RemoveButton(classes: classes, userID: userID),
      ),
    );
  }
}

//Remove Button
class RemoveButton extends StatelessWidget {
  const RemoveButton({
    Key key,
    @required this.classes,
    @required this.userID,
  }) : super(key: key);

  final Classes classes;
  final List<String> userID;

  @override
  Widget build(BuildContext context) {
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
                  child: Text("Remove"),
                  onPressed: () {
                    ClassMGMTLogic.removeClass(context, classes, userID);
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

//Join Button
class JoinButton extends StatelessWidget {
  const JoinButton({
    Key key,
    @required this.classes,
    @required this.userID,
  }) : super(key: key);

  final Classes classes;
  final List<String> userID;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color.fromRGBO(123, 193, 67, 1),
      child: Text(
        'JOIN',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Class?'),
              content: Text(
                  'Are you sure you want to add ${classes.clsName} - ${classes.code} to your class list?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Add Class"),
                  onPressed: () {
                    ClassMGMTLogic.addClass(context, classes, userID);
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

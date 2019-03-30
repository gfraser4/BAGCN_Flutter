import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';
// LOGIC
import 'package:bagcndemo/AddClasses/addClassesLogic.dart';
import 'package:bagcndemo/MyClasses/myClassesLogic.dart';
// MODELS
import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Children.dart';

String _search = '';
String _passcode;
String _childName = '';

// VERIFY CODE PAGE - FOR PARENTS
class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage(this.user);
  final FirebaseUser user;

  @override
  _VerifyCodePage createState() {
    return _VerifyCodePage();
  }
}

class _VerifyCodePage extends State<VerifyCodePage> {
  @override
  Widget build(BuildContext context) {
//*********** PAGE SCAFFOLD *****************\\
    return Scaffold(
      appBar: null,
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      body: _buildBody(
        context,
        widget.user,
      ),
    );
  }

// JOIN CLASSES //

// Search querey dynamic based on search criteria
  Widget _buildBody(BuildContext context, FirebaseUser user) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('class')
          .where('pendingUsers', arrayContains: user.uid)
          //.orderBy('clsName')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents, user);
      },
    );
  }

// Build ListView for queried items based on above query
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      FirebaseUser user) {
    return ListView(
      //padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildListItem(context, data, user)).toList(),
    );
  }

// WIDGET TO BUILD WACH CLASS ITEM
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

// Class Cards
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
    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // final FocusNode _passcodeFocus = FocusNode();
    return Card(
      elevation: 5.0,
      child: ListTile(
        title: Text(classes.clsName),
        subtitle: Text('Course Code: ${classes.code}'),
        trailing: RaisedButton(
          color: Color.fromRGBO(123, 193, 67, 1),
          child: Text(
            'VERIFY',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Choose Child',
                    style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.normal,
                      color: Color.fromRGBO(0, 162, 162, 1),
                    ),
                  ),
                  content: Container(
                    width: 300,
                    child: Form(
                      //key: _formKey,
                      child: Column(
                        //shrinkWrap: true,
                        children: <Widget>[
                          Text("Choose which child belongs to this class."),
                          SizedBox(height: 30.0),
                          Expanded(
                            child: buildChildListBody(context, user, classes),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//??????????????????\\
// BUILD CHILD LIST \\
//??????????????????\\

Widget buildChildListBody(
    BuildContext context, FirebaseUser user, Classes classes) {
  //String userID = user.uid;

  return StreamBuilder<QuerySnapshot>(
    stream: MyClassesLogic.buildChildStream(user),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      //call to build map of database query --> see next widget
      return _buildChildList(context, snapshot.data.documents, user, classes);
    },
  );
}

// Widget to build list of classes for user based on previous widget query
Widget _buildChildList(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, Classes classes) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot
        .map((data) => _buildChildListItem(context, data, user, classes))
        .toList(),
  );
}

// LIST ITEM CONTAINER
Widget _buildChildListItem(BuildContext context, DocumentSnapshot data,
    FirebaseUser user, Classes classes) {
  final children = Children.fromSnapshot(data);
  List<String> userID = ['${user.uid}'];
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final FocusNode _passcodeFocus = FocusNode();
  return FlatButton(
    child: Text('${children.name}'),
    onPressed: () {
      _childName = children.name;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Verify Class Code',
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.normal,
                color: Color.fromRGBO(0, 162, 162, 1),
              ),
            ),
            content: Container(
              width: 300,
              child: Form(
                key: _formKey2,
                child: Column(
                  //shrinkWrap: true,
                  children: <Widget>[
                    Text("Enter the code to access this class."),
                    SizedBox(height: 30.0),
                    TextFormField(
                      enabled: false,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '$_childName',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.child_care,
                          color: Color.fromRGBO(123, 193, 67, 1),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(123, 193, 67, 1),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      validator: (input) {
                        if (input != classes.passcode)
                          return 'Incorrect passcode.';
                      },
                      textInputAction: TextInputAction.done,
                      focusNode: _passcodeFocus,
                      onSaved: (input) => _passcode = input,
                      autofocus: false,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Passcode',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromRGBO(123, 193, 67, 1),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(123, 193, 67, 1),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    )
                  ],
                ),
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
                child: Text("Yes"),
                onPressed: () {
                  final formState = _formKey2.currentState;
                  if (formState.validate()) {
                    //login to firebase
                    formState.save();
                    if (_passcode == classes.passcode) {
                      ClassMGMTLogic.addClassEnrolled(
                          context, classes, userID, user, _childName);
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

// CLASS TILE LAYOUT
class ChildTileWidget extends StatelessWidget {
  const ChildTileWidget({
    Key key,
    @required this.children,
    @required this.userID,
    @required this.user,
  }) : super(key: key);

  final Children children;
  final List<String> userID;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    print(children);
    //cls.add(classes);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
      // CLASS TITLE AND CODE
      title: Text('${children.name}',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(41, 60, 62, 1))),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: () {

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
        },
      ),
      onTap: () {
      },
    );
  }
}

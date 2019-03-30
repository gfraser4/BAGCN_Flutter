//STANDARD MATERIAL LIBRARY AND FIRESTORE LIBRARY
import 'package:bagcndemo/Models/Users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expandable/expandable.dart';
import 'package:validators/validators.dart';
// LOGIC
import 'package:bagcndemo/AddClasses/addClassesLogic.dart';
import 'package:bagcndemo/MyClasses/myClassesLogic.dart';
import 'package:bagcndemo/Style/customColors.dart';
// PAGES
import 'package:bagcndemo/MyClasses/navDrawer.dart';
import 'package:bagcndemo/Announcements/CreateAnnouncement/createAnnouncement.dart';
import 'package:bagcndemo/Announcements/announcementPage.dart';
// MODELS
import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Children.dart';

List<Classes> cls = new List<Classes>();
bool expandedClassesController = false;
bool expandedNewsController = true;
String _childName;

//**MyClassList WIDGET - MY CLASSES PAGE CLASS -- HOW THE MAIN PAGE LOADS AND ITS CONTENT**\\

class MyClassList extends StatefulWidget {
  const MyClassList(this.user, this.isSuper, this.isAdmin);
  final FirebaseUser user;
  final bool isSuper;
  final bool isAdmin;
  @override
  _MyClassList createState() {
    return _MyClassList();
  }
}

// LAYOUT OF MY CLASSES PAGE --> CALLS WIDGETS BELOW IT

class _MyClassList extends State<MyClassList> {
  @override
  void initState() {
    expandedClassesController = false;
    expandedNewsController = true;
    super.initState();
  }

  newsToggle() {
    if (expandedNewsController == false)
      setState(() {
        expandedClassesController = false;
        expandedNewsController = true;
      });
    else {
      setState(() {
        expandedClassesController = true;
        expandedNewsController = false;
      });
    }
  }

  kidsToggle() {
    if (expandedClassesController == false)
      setState(() {
        expandedClassesController = true;
        expandedNewsController = false;
      });
    else {
      setState(() {
        expandedClassesController = false;
        expandedNewsController = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: CustomColors.bagcBlue,
      appBar: AppBar(
        title: Text('My Classes ${widget.user.email}'),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: ExpandablePanel(
              initialExpanded: expandedClassesController == true ? false : true,
              header: Container(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        newsToggle();
                        print(expandedNewsController);
                      },
                      child: Text(
                        'Latest News',
                        style: TextStyle(
                            color: CustomColors.bagcBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text(''),
                        onPressed: () {
                          newsToggle();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        newsToggle();
                      },
                      icon: expandedClassesController == false
                          ? Icon(Icons.keyboard_arrow_up,
                              color: CustomColors.bagcBlue)
                          : Icon(Icons.keyboard_arrow_down,
                              color: CustomColors.bagcBlue),
                    ),
                  ],
                ),
              ),
              expanded: Container(
                //margin: EdgeInsets.symmetric(vertical: 10.0),
                height: queryData.size.height - 200,
                child: buildAnnouncementBody(
                    context, 'Boys and Girls Club Niagara', 0, widget.user),
              ),
              tapHeaderToExpand: false,
              hasIcon: false,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  color: CustomColors.bagcBlue,
                  child: ExpandablePanel(
                    initialExpanded:
                        expandedNewsController == true ? false : true,
                    header: Container(
                      //margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Row(
                        children: <Widget>[
                          widget.isSuper == false && widget.isAdmin == false
                              ? FlatButton(
                                  onPressed: () {
                                    kidsToggle();
                                  },
                                  child: Text(
                                    'My Kids',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              : FlatButton(
                                  onPressed: () {
                                    kidsToggle();
                                  },
                                  child: Text(
                                    'My Classes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                          Expanded(
                            child: FlatButton(
                              child: Text(''),
                              onPressed: () {
                                kidsToggle();
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              kidsToggle();
                            },
                            icon: expandedClassesController == true
                                ? Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white)
                                : Icon(Icons.keyboard_arrow_up,
                                    color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    expanded: Container(
                      height: queryData.size.height - 200,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: widget.isSuper == false
                                ? buildChildListBody(context, widget.user)
                                : _buildClassListBody(
                                    context, widget.user, widget.isSuper),
                          ),
                          addChildButton(context, widget.isSuper,
                              widget.isAdmin, widget.user),
                        ],
                      ),
                    ),
                    tapHeaderToExpand: false,
                    hasIcon: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ), //PAGE CONTENT --> CALLING _buildBody WIDGET
      floatingActionButton:
          floatingButton(context, widget.isSuper, widget.isAdmin, widget.user),
      drawer: navDrawer(context, widget.user, widget.isSuper,
          cls), //BUILDS MENU DRAWER BY CALLING navDrawer WIDGET
    );
  }
}

// Floating action button based on role of user
Widget floatingButton(
    BuildContext context, bool isSuper, bool isAdmin, FirebaseUser user) {
  if (isSuper == true) {
    return FloatingActionButton(
      backgroundColor: CustomColors.bagcGreen,
      child: Icon(Icons.add),
      onPressed: () {
        MyClassesLogic.navToAddClasses(context, user);
      },
    );
  } else if (isAdmin == true)
    return FloatingActionButton(
      backgroundColor: CustomColors.bagcGreen,
      child: Icon(Icons.create),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementPage(
                  'Boys and Girls Club Niagara',
                  0,
                  user,
                ),
          ),
        );
      },
    );
  else {
    return null;
  }
}

// add child button is user is parent
Widget addChildButton(
    BuildContext context, bool isSuper, bool isAdmin, FirebaseUser user) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _childNameFocus = FocusNode();
  final List<String> userID = [user.uid];
  if (isSuper == true) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            color: CustomColors.bagcBlue,
          ),
        ),
      ],
    );
  } else if (isAdmin == true) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            color: CustomColors.bagcBlue,
          ),
        ),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            color: CustomColors.bagcBlue,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: RaisedButton(
                padding: EdgeInsets.all(12),
                color: CustomColors.bagcGreen,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Enter your Child...',
                          style: TextStyle(
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                            color: Color.fromRGBO(0, 162, 162, 1),
                          ),
                        ),
                        content: Container(
                          width: 300,
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                Text("Enter a first name or nickname."),
                                SizedBox(height: 30.0),
                                TextFormField(
                                  validator: (input) {
                                    if (input.trim().isEmpty)
                                      return 'Name must not be empty.';
                                    else if (isAlpha(input) == false)
                                      return 'Name must only use letters (a-zA-Z)';
                                    else if (input.length > 30)
                                      return 'Name can only be 30 characters long.';
                                  },
                                  textInputAction: TextInputAction.done,
                                  focusNode: _childNameFocus,
                                  onSaved: (input) => _childName = input,
                                  autofocus: false,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: 'First Name',
                                    prefixIcon: Icon(
                                      Icons.child_care,
                                      color: Color.fromRGBO(123, 193, 67, 1),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        25.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(123, 193, 67, 1),
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
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
                            onPressed: () async {
                              final formState = _formKey.currentState;
                              if (formState.validate()) {
                                //login to firebase
                                formState.save();
                                await MyClassesLogic.createChild(
                                    context, userID, user, _childName);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Child/Group',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// MAIN PAGE Build //

// QUERY FIRESTORE FOR ALL CLASSES FOR A USER
Widget _buildClassListBody(
    BuildContext context, FirebaseUser user, bool isSuper,
    [Children children]) {
  String userID = user.uid;

  return StreamBuilder<QuerySnapshot>(
    stream: MyClassesLogic.buildStream(userID, isSuper, user, children),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      //call to build map of database query --> see next widget
      return _buildClassList(context, snapshot.data.documents, user, isSuper);
    },
  );
}

// Widget to build list of classes for user based on previous widget query
Widget _buildClassList(BuildContext context, List<DocumentSnapshot> snapshot,
    FirebaseUser user, bool isSuper) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot
        .map((data) => _buildClassListItem(context, data, user, isSuper))
        .toList(),
  );
}

// LIST ITEM CONTAINER
Widget _buildClassListItem(BuildContext context, DocumentSnapshot data,
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
    cls.add(classes);
    return classes.clsName == 'Boys and Girls Club Niagara'
        ? Text('')
        : ListTile(
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
                      // IconButton(
                      //   icon: Icon(Icons.delete),
                      //   color: Colors.grey,
                      //   onPressed: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return new RemoveClassAlert(
                      //             classes: classes,
                      //             isSuper: isSuper,
                      //             userID: userID,
                      //             user: user);
                      //       },
                      //     );
                      //   },
                      // ),
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
                MyClassesLogic.navToAnnouncements(
                    context, user, classes, isSuper);
              },
            ),
            onTap: () {
              MyClassesLogic.navToAnnouncements(
                  context, user, classes, isSuper);
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

//??????????????????\\
// BUILD CHILD LIST \\
//??????????????????\\

Widget buildChildListBody(BuildContext context, FirebaseUser user) {
  //String userID = user.uid;

  return StreamBuilder<QuerySnapshot>(
    stream: MyClassesLogic.buildChildStream(user),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      //call to build map of database query --> see next widget
      return _buildChildList(context, snapshot.data.documents, user);
    },
  );
}

// Widget to build list of classes for user based on previous widget query
Widget _buildChildList(
    BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot
        .map((data) => _buildChildListItem(context, data, user))
        .toList(),
  );
}

// LIST ITEM CONTAINER
Widget _buildChildListItem(
    BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final children = Children.fromSnapshot(data);
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
            new ChildTileWidget(children: children, userID: userID, user: user),
          ],
        ),
      ),
    ],
    key: ValueKey(user.uid),
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    bool isSuper = false;
    return ExpandablePanel(
      initialExpanded: false,
      header: Container(
        // color: Colors.white //CustomColors.bagcGreen,
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            color: Colors.redAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new RemoveChildAlert(
                      children: children, userID: userID, user: user);
                },
              );
            },
          ),

// trailing: IconButton(
//                   icon: Icon(Icons.add),
//                   color: CustomColors.bagcBlue,
//                   onPressed: () {
//                     MyClassesLogic.navToJoinClasses(context, user);
//                   },
//                 ),
          title: Text(
            '${children.name}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: CustomColors.bagcBlue,
            ),
          ),
        ),
      ),
      expanded: Column(
        children: <Widget>[
          Container(
              //margin: EdgeInsets.symmetric(vertical: 10.0),
              height: queryData.size.height - 400,
              child: _buildClassListBody(context, user, isSuper, children)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Remove Classes',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Remove Class?',
                          style: TextStyle(
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                            color: Color.fromRGBO(0, 162, 162, 1),
                          ),
                        ),
                        content:
                            Text('Remove ${children.name} from all classes?'),
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
                              ClassMGMTLogic.removeChildFromAllClass(
                                  context, userID, user, children);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  
                },
              ),
              FlatButton(
                    child: Text(
                      'Manage Classes',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: CustomColors.bagcBlue,
                    onPressed: () {
                      MyClassesLogic.navToJoinClasses(context, user);
                    },
                  ),
            ],
          ),
        ],
      ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );

    //  ListTile(
    //   contentPadding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
    //   title: Text('${children.name}',
    //       style: TextStyle(
    //           fontWeight: FontWeight.w700,
    //           color: Color.fromRGBO(41, 60, 62, 1))),
    //   leading: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Container(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             IconButton(
    //               icon: Icon(Icons.delete),
    //               color: Colors.grey,
    //               onPressed: () {
    //                 showDialog(
    //                   context: context,
    //                   builder: (BuildContext context) {
    //                     return new RemoveChildAlert(
    //                         children: children, userID: userID, user: user);
    //                   },
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    //   trailing: IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon: Icon(Icons.chevron_right),
    //     color: Color(0xFF1ca5e5),
    //     onPressed: () {
    //     },
    //   ),
    //   onTap: () {

    //   },
    // );
  }
}

// REMOVE CLASS ALERT DIALOG BOX
class RemoveChildAlert extends StatelessWidget {
  const RemoveChildAlert({
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
    return AlertDialog(
      title: Text(
        'Remove Child/Group?',
        style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.normal,
            color: Color.fromRGBO(0, 162, 162, 1)),
      ),
      content: Text('Are you sure you want to remove ${children.name}?'),
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
            MyClassesLogic.removeChild(context, userID, user, children);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

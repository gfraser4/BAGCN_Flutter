import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Comments/commentsLogic.dart';


//SEARCH AND ADD users PAGE
class EnrolledUsersPage extends StatefulWidget {
  const EnrolledUsersPage(this.user, this.code);
  final FirebaseUser user;
  final int code;

  @override
  _EnrolledUsersPage createState() {
    return _EnrolledUsersPage();
  }
}

class _EnrolledUsersPage extends State<EnrolledUsersPage> {

//******************************************\\
//*********** page scaffold *****************\\
//********************************************\\
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: null,
      body: _buildEnrolledBody(
        context,
        widget.user,
      ),
    );
  }

//Search querey dynamic based on search criteria
  Widget _buildEnrolledBody(BuildContext context, FirebaseUser user) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
      .collection('users')
      .where("enrolledIn", arrayContains: widget.code )
      .snapshots(), 
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildEnrolledList(context, snapshot.data.documents, user);
      },
    );
  }

//Build ListView for queried items based on above query
  Widget _buildEnrolledList(BuildContext context, List<DocumentSnapshot> snapshot,
      FirebaseUser user) {
    return ListView(
      //padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildEnrolledListItem(context, data, user)).toList(),
    );
  }

//WIDGET TO BUILD WACH CLASS ITEM --> Username needed to add users to that usres class list on their home screen (currently hardcoded as "lj@gmail.com")
  Widget _buildEnrolledListItem(
      BuildContext context, DocumentSnapshot data, FirebaseUser user) {
    final users = Users.fromSnapshot(data);
    List<String> userID = ['${user.uid}'];
    return Padding(
      key: ValueKey(users.id),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: UserCard(users: users, userID: userID, user: user)

    );
  }
}

//Class Cards
class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.users,
    @required this.userID,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;
  final Users users;
  final List<String> userID;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Color(0xFFF4F5F7),
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Chip(
                        //padding must be 0 or two letters can be too big
                        padding: EdgeInsets.all(0),
                        avatar: CircleAvatar(
                            backgroundColor: hexToColor(users.profileColor),
                            child: Text(
                                '${users.firstName[0]}${users.lastName[0]}',
                                style: TextStyle(color: Colors.white))),
                        label: Text(
                          '${users.firstName} ${users.lastName}\n${users.email}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle( fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
          RemoveButton(users: users, userID: userID),
          ],
         
        ),
      ),
    );
  }
}

//Remove Button
class RemoveButton extends StatelessWidget {
  const RemoveButton({
    Key key,
    @required this.users,
    @required this.userID,
  }) : super(key: key);

  final Users users;
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
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text(
        //         'Close Class?',
        //         style: TextStyle(
        //           fontSize: 30,
        //           fontStyle: FontStyle.normal,
        //           color: Color.fromRGBO(0, 162, 162, 1),
        //         ),
        //       ),
        //       content: Text(
        //           'Are you sure you want to close ${users.clsName} - ${users.code} from your class list?'),
        //       actions: <Widget>[
        //         FlatButton(
        //           child: Text("Cancel"),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //         FlatButton(
        //           child: Text("Remove"),
        //           onPressed: () {
        //             ClassMGMTLogic.removeClass(context, users, userID);
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      },
    );
  }
}

// //Open Button
// class OpenButton extends StatelessWidget {
//   const OpenButton({
//     Key key,
//     @required this.users,
//     @required this.userID,
//   }) : super(key: key);

//   final Users users;
//   final List<String> userID;

//   @override
//   Widget build(BuildContext context) {
//      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//      final FocusNode _passcodeFocus = FocusNode();
//     return RaisedButton(
//       color: Color.fromRGBO(123, 193, 67, 1),
//       child: Text(
//         'OPEN',
//         style: TextStyle(color: Colors.white),
//       ),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 'Open Class?',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontStyle: FontStyle.normal,
//                   color: Color.fromRGBO(0, 162, 162, 1),
//                 ),
//               ),
//               content: Text(
//                   'Are you sure you want to open ${users.clsName} - ${users.code}?\n\nAs the program supervisor you will be responsible for mainatining announcements and parent enrollment within this application.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text("Cancel"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 FlatButton(
//                   child: Text("Yes"),
//                   onPressed: () {
                  

//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text(
//                             'Create passcode for ${users.clsName} - ${users.code}',
//                             style: TextStyle(
//                               fontSize: 30,
//                               fontStyle: FontStyle.normal,
//                               color: Color.fromRGBO(0, 162, 162, 1),
//                             ),
//                           ),
//                           content: Container(
//                             width: 300,
//                             child: Form(
//                               key: _formKey,
//                               child: ListView(
//                                 shrinkWrap: true,
//                                 children: <Widget>[
//                                   Text(
//                                       "This code will be used to help prevent unregistered people from accessing this class and it's content."),
//                                   SizedBox(height: 30.0),
//                                   Text(
//                                       "It is critical that this code is only shared with registered parents of this class."),
//                                   SizedBox(height: 30.0),
//                                   TextFormField(
//                                     validator: (input) {
//                                       if (input.length < 6)
//                                         return 'The passcode needs to be at least 6 characters.';
//                                     },
//                                     textInputAction: TextInputAction.done,
//                                     focusNode: _passcodeFocus,
//                                     // initialValue:_password,
//                                     onSaved: (input) => _passcode = input,
//                                     autofocus: false,
//                                     //initialValue: 'password',
//                                     obscureText: true,
//                                     style: TextStyle(color: Colors.black),
//                                     decoration: InputDecoration(
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       labelText: 'Passcode',
//                                       prefixIcon: Icon(
//                                         Icons.lock,
//                                         color: Color.fromRGBO(123, 193, 67, 1),
//                                       ),
//                                       //hintText: 'Password',
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           25.0, 15.0, 20.0, 15.0),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20.0),
//                                           borderSide: BorderSide(
//                                             color:
//                                                 Color.fromRGBO(123, 193, 67, 1),
//                                             width: 2,
//                                           )),
//                                       border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20.0)),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           actions: <Widget>[
//                             FlatButton(
//                               child: Text("Cancel"),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                             FlatButton(
//                               child: Text("Create code"),
//                               onPressed: () {
//                                 final formState = _formKey.currentState;
//                             if (formState.validate()) {
//                               //login to firebase
//                               formState.save();
//                                 ClassMGMTLogic.openClass(
//                                     context, users, userID, _passcode.trim());
//                             }
                                
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

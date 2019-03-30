import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Settings/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
class SettingLogic {

  static void muteNotification(FirebaseUser user, List<Classes> classes, bool isMute) async{
    try{
      List<String> userID = [user.uid];
      for(Classes cls in classes){
        await Firestore.instance.runTransaction((transaction) {
          if (!isMute) {
            transaction.update(
                cls.reference, {"notifyUsers": FieldValue.arrayUnion(userID)});
          } else if (isMute){
            transaction.update(
                cls.reference, {"notifyUsers": FieldValue.arrayRemove(userID)});
          }
        });
      }
    }
    catch(ex){ }
  }

  static Future<void> editProfile(Users user,String email,String firstName,String lastName) async{
    Firestore db = Firestore.instance;
    QuerySnapshot profile = await db
          .collection('users')
          .where('id', isEqualTo: user.id)
          .getDocuments();
      profile.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "email": email,
          "firstName": firstName,
          "lastName": lastName
        });
      });
  }

  static void changeProfileColour(Users user,String color) async{
    Firestore db = Firestore.instance;
    QuerySnapshot profColor = await db
          .collection('users')
          .where('id', isEqualTo: user.id)
          .getDocuments();
      profColor.documents.forEach((doc) {
        db.collection('users').document(doc.documentID).updateData({
          "profileColor": color
        });
      });
    QuerySnapshot commColor = await db
          .collection('comments')
          .where('userID', isEqualTo: user.id)
          .getDocuments();
      commColor.documents.forEach((doc) {
        db.collection('comments').document(doc.documentID).updateData({
          "profileColor": color
        });
      });
      QuerySnapshot replyColor = await db
          .collection('replies')
          .where('userID', isEqualTo: user.id)
          .getDocuments();
      replyColor.documents.forEach((doc) {
        db.collection('replies').document(doc.documentID).updateData({
          "profileColor": color
        });
      });
  }

  static void sendChangePasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  
}

class MyDialogContent extends StatefulWidget {
  // const MyDialogContent(this.user);
  // final FirebaseUser user;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  Text _validation =Text("An email with reset password link will be sent to the address above.",style:TextStyle(color:Color.fromRGBO(0, 162, 162, 1)));
  TextEditingController email = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    title: Text(
      'Enter Your Email',
      style: TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
    ),
    content: Container(
      width: 250,
      child:ListView(
        shrinkWrap: true,
        children: <Widget>[
              Container(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller:email,
                  autofocus: true,
                  style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
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
              ),
              SizedBox(height: 5,),
              _validation
            ]
      )
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          email.clear();
          _validation =Text("An email with reset password link will be sent to the address above.",style:TextStyle(color:Color.fromRGBO(0, 162, 162, 1)));
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text("Send"),
        onPressed: () {
          if(email.text.length>0 && isEmail(email.text)){
            try
            {
              SettingLogic.sendChangePasswordEmail(email.text);
              setState(() {
                _validation = Text("The password reset email has been sent.",style:TextStyle(color:Color.fromRGBO(0, 162, 162, 1)));
              });
              Future.delayed(Duration(seconds: 10),(){
                email.clear();
                _validation =Text("");
                Navigator.of(context).pop();
              });
            }
            catch(ex)
            {
              setState(() {
                _validation = Text("Invalid email address.",style:TextStyle(color:Colors.red));
              });
            }
          }
          else{
            setState(() {
              _validation = Text("Invalid Email Address.",style:TextStyle(color:Colors.red));
            });
          }
        },
      ),
    ],
  );
  }
}

class GetUserDialog extends StatefulWidget {

  @override
  _GetUserDialog createState() => new _GetUserDialog();
}

class _GetUserDialog extends State<GetUserDialog> {
  Text _validation =Text("Please enter the user's email address.",style:TextStyle(color:Color.fromRGBO(0, 162, 162, 1)));
  TextEditingController email = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    title: Text(
      "Enter User's Email",
      style: TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
    ),
    content: Container(
      width: 250,
      child:ListView(
        shrinkWrap: true,
        children: <Widget>[
              Container(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller:email,
                  autofocus: true,
                  style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
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
              ),
              SizedBox(height: 5,),
              _validation
            ]
      )
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          email.clear();
          _validation =Text("Please enter the user's email address.",style:TextStyle(color:Color.fromRGBO(0, 162, 162, 1)));
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text("Submit"),
        onPressed: () {
          if(email.text.trim().length>0 && isEmail(email.text.trim())){
            getUser().then((value){
              if(value == null){
                setState(() {
                  _validation = Text("The user is not in database.",style:TextStyle(color:Colors.red));
                });
              }else{
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile(value)),
                );
              }
            });
            }
          else{
            setState(() {
              _validation = Text("Invalid Email Address.",style:TextStyle(color:Colors.red));
            });
          }
        },
      ),
    ],
  );
  }

  Future<Users> getUser() async{
    Firestore db = Firestore.instance;
    QuerySnapshot replyColor = await db
          .collection('users')
          .where('email', isEqualTo: email.text.trim())
          .getDocuments();
    try{
      return Users.fromSnapshot(replyColor.documents[0]);
    }
    catch(ex){
      return null;
    }
  }
}
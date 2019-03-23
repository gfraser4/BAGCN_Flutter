import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SettingLogic {

  static void muteNotification(FirebaseUser user, List<Classes> classes, bool isMute){
    List<String> userID = [user.uid];
      for(Classes cls in classes){
        Firestore.instance.runTransaction((transaction) {
          // final freshSnapshot = await transaction.get(cls.reference);
          // final fresh = Classes.fromSnapshot(freshSnapshot);
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

  static Future<void> sendChangePasswordEmail(String email) async {
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
  Text _validation =Text("");
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
          _validation =Text("");
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text("Send"),
        onPressed: () {
          // if(email.text==widget.user.email&&widget.user.isEmailVerified){
            try
            {
              SettingLogic.sendChangePasswordEmail(email.text);
              setState(() {
                _validation = Text("A password change email has been sent to the email address.",style:TextStyle(color:Colors.green));
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
          // }
          // else if(email.text!=widget.user.email){
          //   setState(() {
          //     _validation = Text("Wrong email address.",style:TextStyle(color:Colors.red));
          //   });
          // }
          // else{
          //   setState(() {
          //     _validation = Text("This email is not verified.",style:TextStyle(color:Colors.red));
          //   });
          // }
        },
      ),
    ],
  );
  }
}
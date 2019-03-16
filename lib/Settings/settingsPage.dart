import 'dart:async';

import 'package:bagcndemo/Models/ClassesModel.dart';
import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Settings/SettingLogic.dart';
// import 'package:bagcndemo/Settings/editProfile.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.user,this.loginUser,this.classes);
  final FirebaseUser user;
  final Users loginUser;
  final List<Classes> classes;
  @override
  _SettingsPage createState() => new _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {

TextEditingController passcode = new TextEditingController();

// AlertDialog _enterPassword(int page){
//   return 
// }

AlertDialog _signOutAlert(){
  return AlertDialog(
    title: Text(
      'Sign Out',
      style: TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
    ),
    content: Text(
      'Want to sign out? You will be directed to login page',
      style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
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
          Navigator.pop(context);
          FirebaseAuth.instance.signOut();
          Navigator.of(context)
            .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
        },
      ),
    ],
  );
}

ListTile _editProfile(){
  return ListTile(
        title: Text("Current User",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        subtitle: Text(widget.loginUser.firstName+" "+widget.loginUser.lastName,style:TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),
        // trailing: Icon(Icons.chevron_right),
        // onTap: (){
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return _enterPassword(1);
        //     }
        //   );
        // },
      );
    } 
    
ListTile _changePassword(){
  return ListTile(
        title: Text("Change Password",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        trailing: Icon(Icons.chevron_right),
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyDialogContent(widget.user);
            }
          );
        },
      );
    } 

CheckboxListTile _darkMode(){
  return CheckboxListTile(
        title: Text("Dark Mode",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        value: Theme.of(context).brightness == Brightness.dark? true: false,
        activeColor: Color.fromRGBO(123, 193, 67, 1),
        onChanged:(bool){
          DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
        } ,
      );
    } 

ListTile _muteNotification(){
  return ListTile(
        title: Text("Mute Notification",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        onTap:(){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Notification',
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.normal,
                      color: Color.fromRGBO(0, 162, 162, 1)),
                ),
                content: Text(
                  "Mute or Unmute all the classes' notification?",
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      color: Color.fromRGBO(0, 162, 162, 1)),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Mute All"),
                    onPressed: () {
                      SettingLogic.muteNotification(widget.user, widget.classes, true);
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Unmute All"),
                    onPressed: () {
                      SettingLogic.muteNotification(widget.user, widget.classes, false);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
          );
        } ,
      );
    } 

ListTile _signOut(){
  return ListTile(
        title: Text("Sign Out",style:TextStyle(fontSize: 18,color: Colors.red),maxLines: 1,overflow: TextOverflow.ellipsis,),
        trailing: Icon(Icons.chevron_right),
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _signOutAlert();
            }
          );
        },
      );
    } 


ListView settingPage(){
        return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:<Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _editProfile()
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _changePassword()
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _darkMode()
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _muteNotification()
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _signOut()
          ),
        ]
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: settingPage()
    );
  }
}

class MyDialogContent extends StatefulWidget {
  const MyDialogContent(this.user);
  final FirebaseUser user;

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
          if(email.text==widget.user.email&&widget.user.isEmailVerified){
            SettingLogic.sendChangePasswordEmail(email.text);
            setState(() {
              _validation = Text("A password change email has been sent to your email address.",style:TextStyle(color:Colors.green));
            });
          Future.delayed(Duration(seconds: 10),(){
            email.clear();
            _validation =Text("");
            Navigator.of(context).pop();
          });
          }
          else if(email.text!=widget.user.email){
            setState(() {
              _validation = Text("Wrong email address.",style:TextStyle(color:Colors.red));
            });
          }
          else{
            setState(() {
              _validation = Text("This email is not verified.",style:TextStyle(color:Colors.red));
            });
          }
        },
      ),
    ],
  );
  }
}
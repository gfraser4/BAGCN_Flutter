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
              // return MyDialogContent(widget.user);
              return MyDialogContent();
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
        },
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
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border(bottom: BorderSide(color: Colors.grey))
          //   ),
          //   child: _darkMode()
          // ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))
            ),
            child: _muteNotification()
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border(bottom: BorderSide(color: Colors.grey))
          //   ),
          //   child: _signOut()
          // ),
        ]
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Settings")),
      body: settingPage()
    );
  }
}


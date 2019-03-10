import 'dart:async';

import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Settings/changePassword.dart';
import 'package:bagcndemo/Settings/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.user);
  final FirebaseUser user;

  @override
  _SettingsPage createState() => new _SettingsPage();
}

bool isMute = false;
Users user;
String password;
String _validation = '';

class _SettingsPage extends State<SettingsPage> {

Future<void> getUser() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document('${widget.user.uid}')
        .get();
        print('doc got');
    user = Users.fromSnapshot(snapshot);
}

AlertDialog _enterPassword(int page){
  return AlertDialog(
    title: Text(
      'Enter Your Password',
      style: TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
    ),
    content: Column(
      children: <Widget>[
        TextFormField(
          textInputAction: TextInputAction.done,
          onSaved: (input) => password = input,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Password',
          )
        ),
        Text('$_validation',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),)
      ],
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text("Ok"),
        onPressed: () {
          try{
            FirebaseAuth.instance
            .signInWithEmailAndPassword(email: user.email, password: password);
            Navigator.pop(context);
            page==1?
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile(user,widget.user))
            ):
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword(widget.user))
            );
          }
        catch(ex){
          setState(() {
            _validation = "Wrong password";
          });
        } 
        },
      ),
    ],
  );
}

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
        title: Text("Edit Profile",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        subtitle: Text(user.firstName+" "+user.lastName,style:TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),
        trailing: Icon(Icons.chevron_right),
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _enterPassword(1);
            }
          );
        },
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
              return _enterPassword(2);
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

CheckboxListTile _muteNotification(){
  return CheckboxListTile(
        title: Text("Mute Notification",style:TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,),
        value: isMute,
        activeColor: Color.fromRGBO(123, 193, 67, 1),
        onChanged:(bool){
          isMute = bool;
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
    getUser();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: settingPage()
    );
  }
}
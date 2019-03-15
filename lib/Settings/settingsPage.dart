import 'dart:async';
import 'dart:math';

import 'package:bagcndemo/Models/Users.dart';
import 'package:bagcndemo/Settings/changePassword.dart';
import 'package:bagcndemo/Settings/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.user);
  final FirebaseUser user;

  @override
  _SettingsPage createState() => new _SettingsPage();
}

Users user;

class _SettingsPage extends State<SettingsPage> {

bool isMute = false;
TextEditingController email = new TextEditingController();
TextEditingController passcode = new TextEditingController();
String code = "123456";
String _validation = '';

@override
void initState() {
  super.initState();
  getUser();
}

void _randomCode(){
  Random random = new Random();
  for (int i = 0; i < 6; i++){
    code += random.nextInt(10).toString();
  }
}

Future<void> sendCode() async {
  // _randomCode();
  // String username = 'bagcn2019@gmail.com';
  // String password = 'boysandgirls2019';
  String username = 'leeczwkey@gmail.com';
  String password = 'leeczw9201554=';

  final smtpServer = gmail(username, password);
  
  final message = new Message()
    ..from = new Address(username, 'Boys&Girls Club')
    ..recipients.add(email.text)
    ..subject = 'Your pass code to change your password'
    ..text = code;
  try{
    await send(message, smtpServer);
    print('sent successful');
  }
  catch(ex){
    print('fail');
  }
}
  
Future<void> getUser() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document('${widget.user.uid}')
        .get();
    user = Users.fromSnapshot(snapshot);
}

AlertDialog _enterPassword(int page){
  return AlertDialog(
    title: Text(
      'Enter Your PassCode',
      style: TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.normal,
          color: Color.fromRGBO(0, 162, 162, 1)),
    ),
    content: Container(
      width: 300,
      child:ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 210,
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
              Container(
                width: 70,
                child: RaisedButton(
                  color: Colors.green,
                  child: Text('Send',style: TextStyle(color: Colors.white)),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  onPressed: () {
                    // email.text==user.email
                    true?sendCode():_validation="Wrong Email";
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
        TextFormField(
          textInputAction: TextInputAction.done,
          controller:passcode,
          autofocus: true,
          style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Passcode',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromRGBO(123, 193, 67, 1),
                          ),
                          //hintText: 'Password',
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
        Text('$_validation',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),)
        ],
      )
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
          if(code.length!=6){
            setState(() {
              _validation = "Please enter your email to get your pass code";
            });
          }
          else if(passcode.text==code){
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
          else{
            setState(() {
              _validation = "Wrong code";
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
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: settingPage()
    );
  }
}
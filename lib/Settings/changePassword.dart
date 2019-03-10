import 'package:bagcndemo/Models/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(this.user);
  final FirebaseUser user;

  @override
  _ChangePassword createState() => new _ChangePassword();
}

TextEditingController newPassword = new TextEditingController();
TextEditingController reenterpassword = new TextEditingController();

class _ChangePassword extends State<ChangePassword> {

ListView changePassword(){
        return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:<Widget>[
          SizedBox(height: 14,),
          ListTile(
            trailing: TextField(
              controller:newPassword,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'New Password',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextField(
              controller:reenterpassword,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Re-enter password',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
            ),
          ),
          SizedBox(height: 14,),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RaisedButton(
              color: Color.fromRGBO(123, 193, 67, 1),
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                if(newPassword.text==reenterpassword.text){
                  widget.user.updatePassword(newPassword.text);
                  print("password changed");
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          SizedBox(height: 14,),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RaisedButton(
              color: Colors.red,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ]
      );
    }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Pasword")),
      body: changePassword()
    );
  }
}
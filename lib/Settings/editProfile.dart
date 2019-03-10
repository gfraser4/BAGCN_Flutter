import 'package:bagcndemo/Models/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(this.user,this.firebaseUser);
  final Users user;
  final FirebaseUser firebaseUser;
  @override
  _EditProfile createState() => new _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  
TextEditingController _email;

ListView changeProfile(){
        return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:<Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 7, top: 7),
            // color: Color.fromRGBO(28, 165, 229, 1),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[                
                Container(
                  margin: EdgeInsets.all(5),
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'User:',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      new TextSpan(text: "${widget.user.firstName} ${widget.user.lastName}"), //ADD REAL NAME FROM DATABASE HERE
                    ],
                  ),
                ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'Email Address: ',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      new TextSpan(text: "${widget.user.email}"), //ADD Email FROM DATABASE HERE
                    ],
                  ),
                ),
                ),
              ]
            )
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'First Name',
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
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Last Name',
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
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
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
                setState(() {});
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
      appBar: AppBar(title: Text("Change Profile")),
      body: changeProfile()
    );
  }
}
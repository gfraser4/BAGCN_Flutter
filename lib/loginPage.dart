import 'package:flutter/material.dart';

import './main.dart';
import './signupPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Important: Remove any padding from the ListView.
          //padding: EdgeInsets.zero,
          children: <Widget>[
            Image.asset('assets/BGC_Niagara_logo.png'),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.lightGreen,
                  )),
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.lightGreen,
                  )),
            ),
Container(
                margin: EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                  color: Colors.lightGreen,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.lightGreen[50]),
                  ),
                  onPressed: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.lightGreen),
                  ),
                  onPressed: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

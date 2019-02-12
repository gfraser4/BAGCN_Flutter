import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}
//
class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
  //SCAFFOLD OF PAGE LAYOUT AT BOTTOM --> SEE BELOW
    
//HERO/LOGO AREA 
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
        child: Image.asset('assets/BGC_Niagara_logo.png'),
      ),
    );

//EMAIL INPUT
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'lj@gmail.com',
      decoration: InputDecoration(
        labelText: 'Username',
        icon: Icon(
          Icons.account_circle,
          color: Colors.lightGreen,
        ),
        //hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

//PASSWORD INPUT
    final password = TextFormField(
      autofocus: false,
      //initialValue: 'password',
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        icon: Icon(
          Icons.lock,
          color: Colors.lightGreen,
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

//LOGIN BUTTON
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(24),
        // ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF1ca5e5),
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

//SIGN UP BUTTON
    final signup = FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(color: Color(0xFF1ca5e5)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/signup');
      },
    );

//SCAFFOLD/LAYOUT OF LOGIN PAGE USING ITEMS CREATED ABOVE
    return WillPopScope( //DISABLES BACK BUTTON ON PHONE WHICH WOULD SEND USER TO MY CLASS LIST BYPASSING LOGIN
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFF1ca5e5),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.lightBlue[50],
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 32.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                signup
              ],
            ),
          ),
        ),
      ),
    );
  }
}

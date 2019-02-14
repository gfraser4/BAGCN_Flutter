import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './main.dart';

class SignUpPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _SignUpPage createState() => new _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    //SEE BOTTOM OF PAGE FOR LAYOUT/SCAFFOLD

//HERO/LOGO AREA
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
        child: Image.asset('assets/BGC_Niagara_logo.png'),
      ),
    );

//FIRST NAME INPUT FIELD
    final firstName = TextFormField(
      validator: (input) {
        if (input.isEmpty) return 'Please enter your first name.';
      },
      onSaved: (input) => _firstName = input,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'lj@gmail.com',
      decoration: InputDecoration(
        labelText: 'First Name',
        icon: Icon(
          Icons.account_circle,
          color: Colors.lightGreen,
        ),
        //hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

//LAST NAME INPUT FIELD
    final lastName = TextFormField(
      validator: (input) {
        if (input.isEmpty) return 'Please enter your last name.';
      },
      onSaved: (input) => _lastName = input,
      autofocus: false,
      //initialValue: 'password',

      decoration: InputDecoration(
        labelText: 'Last Name',
        icon: Icon(
          Icons.account_circle,
          color: Colors.lightGreen,
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

//EMAIL INPUT FIELD
    final email = TextFormField(
      validator: (input) {
        if (input.isEmpty) return 'Please enter a valid email.';
      },
      onSaved: (input) => _email = input,
      autofocus: false,
      //initialValue: 'password',

      decoration: InputDecoration(
        labelText: 'Email',
        icon: Icon(
          Icons.email,
          color: Colors.lightGreen,
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

//PASSWORD INPUT FIELD
    final password = TextFormField(
      validator: (input) {
        if (input.length < 6)
          return 'Your password needs to be at least 6 characters.';
      },
      onSaved: (input) => _password = input,
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

//CONFIRM PASSWORD INPUT FIELD
    // final confirmPassword = TextFormField(
    //   autofocus: false,
    //   //initialValue: 'password',
    //   obscureText: true,
    //   decoration: InputDecoration(
    //     labelText: 'Confirm Password',
    //     icon: Icon(
    //       Icons.check_box,
    //       color: Colors.lightGreen,
    //     ),
    //     //hintText: 'Password',
    //     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
    //   ),
    // );

//CHOOSE ROLE TEXT
    final choice = Text(
      'Choose your Role:',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Color(0xFF1ca5e5), fontWeight: FontWeight.w600, fontSize: 18),
    );

//SUPERVISOR AND PARENT BUTTONS
    final role = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
            //color: Colors.lightGreen,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.assignment_ind,
                    color: Color(0xFF1ca5e5),
                  ),
                ),
                Text(
                  'Supervisor',
                  style: TextStyle(color: Color(0xFF1ca5e5)),
                ),
              ],
            ),
            onPressed: () {
              superSignUp();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
            color: Color(0xFF1ca5e5),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.child_care,
                    color: Colors.lightBlue[50],
                  ),
                ),
                Text(
                  'Parent',
                  style: TextStyle(color: Colors.lightBlue[50]),
                ),
              ],
            ),
            onPressed: () {
              parentSignUp();
            },
          ),
        ),
      ],
    );

//BACK TO LOGIN BUTTON
    final loginPage = FlatButton(
      child: Text(
        'Back to Login',
        style: TextStyle(color: Color(0xFF1ca5e5)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    );

//PAGE LAYOU AND SCAFFOLD
    return WillPopScope(
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
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    logo,
                    SizedBox(height: 48.0),
                    firstName,
                    SizedBox(height: 32.0),
                    lastName,
                    SizedBox(height: 32.0),
                    email,
                    SizedBox(height: 32.0),
                    password,
                    //SizedBox(height: 24.0),
                    //confirmPassword,
                    SizedBox(height: 24.0),
                    choice,
                    role,
                    loginPage
                  ],
                ),
              )),
        ),
      ),
    );
  }

//future waiting for database response
  Future<void> parentSignUp() async {
    final formState = _formKey.currentState;
    //validate fields
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Firestore.instance.collection('users').document('${user.uid}').setData({
          'id': user.uid,
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'role': 'parent',
        });
        //Navigate to home
        //Navigator.pushReplacementNamed(context, '/');
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new MyClassList(user)));
        //Navigator.of(context).pop();
      } catch (ex) {
        print(ex.message);
      }
    }
  }

  Future<void> superSignUp() async {
    final formState = _formKey.currentState;
    //validate fields
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Firestore.instance.collection('users').document('${user.uid}').setData({
          'id': user.uid,
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'role': 'super',
        });
        //Navigate to home
        //Navigator.pushReplacementNamed(context, '/');
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new MyClassList(user)));
        //Navigator.of(context).pop();
      } catch (ex) {
        print(ex.message);
      }
    }
  }
}

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DocumentReference reference;

  Users.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['lastName'] != null),
        assert(map['email'] != null),
        assert(map['role'] != null),
        assert(map['id'] != null),
        firstName = map['firstName'],
        lastName = map['lastName'],
        id = map['id'],
        email = map['email'],
        role = map['role'];

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Record<$clsName:$title>";
}

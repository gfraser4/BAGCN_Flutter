import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bagcndemo/MyClasses/myClasses.dart';
import 'package:bagcndemo/Style/customColors.dart';

//FOCUSING
final FocusNode _passwordFocus = FocusNode();

//LOGIN PAGE INITIALIZATION
class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool isRemember = false;
  String _validation = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Remember login details
  File jsonFile;
  Directory dir;
  String fileName = 'localUser.json';
  bool fileExist = false;
  Map<String, dynamic> fileContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if (!fileExist) {
        jsonFile = new File(dir.path + '/' + fileName);
        jsonFile.createSync();
        fileExist = true;
        jsonFile.writeAsStringSync(
            json.encode({'isRemember': false, '_email': '', '_password': ''}));
      }
      setState(() {
        fileContent = json.decode(jsonFile.readAsStringSync());
        _email = fileContent['_email'];
        _password = fileContent['_password'];
        isRemember = fileContent['isRemember'];
      });
    });
  }

  void writeToFile(String email, String paw, bool isRemember) {
    jsonFile.writeAsStringSync(json
        .encode({'isRemember': isRemember, '_email': email, '_password': paw}));
  }

// LOGIN PAGE BUILD - SEPERATED BY WIDGET
  @override
  Widget build(BuildContext context) {
// HERO/LOGO AREA
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 70, top: 70, right: 70),
        child: Image.asset('assets/BGC_Niagara_Vertical.png'),
      ),
    );

// EMAIL INPUT
    final email = TextFormField(
      validator: (input) {
        if (input.isEmpty) return 'Please enter a valid email.';
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      initialValue: _email,
      onSaved: (input) => _email = input,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.account_circle,
          color: CustomColors.bagcGreen,
        ),
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: CustomColors.bagcGreen,
              width: 2,
            )),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

// PASSWORD INPUT
    final password = TextFormField(
      validator: (input) {
        if (input.length < 6)
          return 'Your password needs\nto be at least 6 characters.';
      },
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocus,
      initialValue: _password,
      onSaved: (input) => _password = input,
      autofocus: false,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Password',
        prefixIcon: Icon(
          Icons.lock,
          color: CustomColors.bagcGreen,
        ),
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: CustomColors.bagcGreen,
              width: 2,
            )),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

// CHECKBOX REMEMBER THE USER
    Checkbox checkButton = Checkbox(
      value: isRemember,
      activeColor: CustomColors.bagcGreen,
      onChanged: (bool) {
        setState(() {
          isRemember = bool;
        });
      },
    );

// LOGIN BUTTON
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: RaisedButton(
          onPressed: () {
            signIn();
          },
          padding: EdgeInsets.all(12),
          color: CustomColors.bagcBlue,
          child: Text('Log In',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0))),
    );

// SIGN UP BUTTON
    final signup = FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(color: CustomColors.bagcBlue),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/signup');
      },
    );

// SCAFFOLD/LAYOUT OF LOGIN PAGE USING ITEMS CREATED ABOVE
    return WillPopScope(
      //DISABLES BACK BUTTON ON PHONE WHICH WOULD SEND USER TO MY CLASS LIST BYPASSING LOGIN
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 15.0),
                password,
                SizedBox(height: 24.0),
                Container(
                  height: 20,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      checkButton,
                      Center(child: Text('Remember me'))
                    ],
                  ),
                ),
                Text(
                  '$_validation',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                loginButton,
                signup
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkRole(FirebaseUser user) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document('${user.uid}')
        .get();
    print('doc got');
    if (snapshot['role'] == 'super') {
      return true;
    } else {
      return false;
    }
  }

//future waiting for database response
  Future<void> signIn() async {
    final formState = _formKey.currentState;

    //validate fields
    if (formState.validate()) {
      //login to firebase
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        bool isSuper = await checkRole(user);
        print(isSuper);

        await Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new MyClassList(user, isSuper)));
      } catch (ex) {
        setState(() {
          _validation = ex.message.toString();
        });
      }
    }
    //wether user choose to auto login or not
    isRemember
        ? writeToFile(_email, _password, true)
        : writeToFile('', '', false);
  }
}

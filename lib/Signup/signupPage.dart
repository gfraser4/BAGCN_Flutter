import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';

import 'package:bagcndemo/Login/loginPage.dart';
import 'package:bagcndemo/Signup/signupLogic.dart';
import 'package:bagcndemo/MyClasses/myClasses.dart';

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
  TextEditingController _emailInput = TextEditingController();
  String _validation = '';

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
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromRGBO(123, 193, 67, 1),
        ),
        //hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Color.fromRGBO(123, 193, 67, 1),
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromRGBO(123, 193, 67, 1),
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Color.fromRGBO(123, 193, 67, 1),
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

//EMAIL INPUT FIELD
    final email = TextFormField(
      validator: (input) {
        if (input.isEmpty || isEmail(input) == false)
          return 'Please enter a valid email address.';
      },
      onSaved: (input) => _email = input,
      autofocus: false,
      //initialValue: 'password',
      controller: _emailInput,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.email,
          color: Color.fromRGBO(123, 193, 67, 1),
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Color.fromRGBO(123, 193, 67, 1),
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromRGBO(123, 193, 67, 1),
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Color.fromRGBO(123, 193, 67, 1),
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
          color: Color.fromRGBO(41, 60, 62 , 1), fontWeight: FontWeight.w600, fontSize: 18),
    );

//SUPERVISOR AND PARENT BUTTONS
    final role = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 130,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
            color: Color.fromRGBO(28, 165, 229, 1),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.assignment_ind,
                    color: Colors.white,
                  ),
                  ),
                  Text(
                    'Supervisor',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
                
              ),
              onPressed: () {
                final formState = _formKey.currentState;
                formState.validate();
                if (matches(_emailInput.text, '@bagcn.com')) {
                  superSignUp();
                  setState(() {
                    _validation = "";
                  });
                } else {
                  print(_emailInput.text);
                  print('wrong email');
                  setState(() {
                    _validation =
                        'Only valid supervisor email addresses can be used to create a supervisor account.';
                  });
                }
              }
              ),
        ),
        Container(
          width: 130,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
            color: Color.fromRGBO(28, 165, 229, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.child_care,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Parent',
                  style: TextStyle(color: Colors.white),
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
        backgroundColor: Color(0xFFF4F5F7),
        body: Center(
            child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              firstName,
              SizedBox(height: 22.0),
              lastName,
              SizedBox(height: 22.0),
              email,
              SizedBox(height: 22.0),
              password,
              //SizedBox(height: 24.0),
              //confirmPassword,
              SizedBox(height: 22.0),
              choice,
              role,
              SizedBox(height: 12.0),
              Text(
                '$_validation',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              //SizedBox(height: 12.0),
              loginPage,
            ],
          ),
        )),
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
        SignupLogic.createParent(user, _email, _password, _firstName, _lastName);
        if (user != null) {
          //Sign in Successful: Navigate to home

         await Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage()));
        } else {
          //Sign in Failed:
          //...Prompt User
        }
      } catch (ex) {
        setState(() {
          _validation = ex.message.toString();
        });
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
        SignupLogic.createSupervisor(user, _email, _password, _firstName, _lastName);
        if (user != null) {
          //Sign in Successful: Navigate to home

          await Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage()));
        } else {
          //Sign in Failed:
          //...Prompt User
        }
      } catch (ex) {
        _validation = ex.message.toString();
      }
    }
  }
}


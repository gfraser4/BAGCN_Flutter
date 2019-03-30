import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';
// LOGIC
import 'package:bagcndemo/Signup/signupLogic.dart';
// PAGES
import 'package:bagcndemo/Style/customColors.dart';
import 'package:bagcndemo/Login/loginPage.dart';


// Signup Initialization
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
// HERO/LOGO AREA
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
        child: Image.asset('assets/BGC_Niagara_logo.png'),
      ),
    );

// FIRST NAME INPUT FIELD
    final firstName = TextFormField(
      validator: (input) {
        if (input.isEmpty) 
          return 'Please enter your first name.';
        else if (isAlpha(input) == false)
          return 'First name must only use letters (a-zA-Z)';
        else if(input.length > 30)
          return 'First name must be 30 characters or less.';
      },
      onSaved: (input) => _firstName = input,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'First Name',
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

// LAST NAME INPUT FIELD
    final lastName = TextFormField(
      validator: (input) {
        if (input.isEmpty) 
          return 'Please enter your last name.';
        else if (isAlpha(input) == false)
          return 'Last name must only use letters (a-zA-Z)';
        else if(input.length > 30)
          return 'Last name must be 30 characters or less.';
      },
      onSaved: (input) => _lastName = input,
      autofocus: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Last Name',
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

// EMAIL INPUT FIELD
    final email = TextFormField(
      validator: (input) {
        if (input.isEmpty || isEmail(input) == false)
          return 'Please enter a valid email address.';
      },
      onSaved: (input) => _email = input,
      autofocus: false,
      controller: _emailInput,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.email,
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

// PASSWORD INPUT FIELD
    final password = TextFormField(
      validator: (input) {
        if (input.length < 6)
          return 'Your password needs to be at least 6 characters.';
        else if(input.length > 30)
          return 'Password must be 30 characters or less.';
      },
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

// CHOOSE ROLE TEXT
    final choice = Text(
      'Choose your Role:',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 18),
    );

// SUPERVISOR AND PARENT BUTTONS
    final role = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 130,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
              color: CustomColors.bagcBlue,
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
                validateSupervisor();
              }),
        ),
        Container(
          width: 130,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: RaisedButton(
            color: CustomColors.bagcBlue,
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

// BACK TO LOGIN BUTTON
    final loginPage = FlatButton(
      child: Text(
        'Back to Login',
        style: TextStyle(color: Color(0xFF1ca5e5)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    );

// PAGE LAYOUT AND SCAFFOLD
    return WillPopScope(
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
              firstName,
              SizedBox(height: 22.0),
              lastName,
              SizedBox(height: 22.0),
              email,
              SizedBox(height: 22.0),
              password,
              SizedBox(height: 22.0),
              choice,
              role,
              SizedBox(height: 12.0),
              Text(
                '$_validation',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              loginPage,
            ],
          ),
        )),
      ),
    );
  }

// PARENT SIGNUP FUNCTION
  Future<void> parentSignUp() async {
    final formState = _formKey.currentState;
    // validate fields
    if (formState.validate()) {
      // login to firebase
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // CREATE PARENT
        SignupLogic.createParent(
            user, _email, _password, _firstName.trim(), _lastName.trim());
        if (user != null) {
          // Sign in Successful: Navigate to home
          await Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage()));
        }
      } catch (ex) {
        setState(() {
          _validation = ex.message.toString();
        });
      }
    }
  }

// SIGNUP SUPERVISOR
  Future<void> superSignUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // CREATE SUPERVISOR
        SignupLogic.createSupervisor(
            user, _email, _password, _firstName.trim(), _lastName.trim());
        if (user != null) {
          // Sign in Successful: Navigate to home
          await Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage()));
        }
      } catch (ex) {
        setState(() {
          _validation = ex.message.toString();
        });
      }
    }
  }

  void validateSupervisor() {
    final formState = _formKey.currentState;
    formState.validate();
    if (matches(_emailInput.text, '@bagcn.com')) {
      superSignUp();
      setState(() {
        _validation = "";
      });
    } else {
      setState(() {
        _validation =
            'Unable to create account, please contact the adminstrator.';
      });
    }
  }
}

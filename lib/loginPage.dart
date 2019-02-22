import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './main.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

//
class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //SCAFFOLD OF PAGE LAYOUT AT BOTTOM --> SEE BELOW

//HERO/LOGO AREA
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 70, top: 70, right: 70),
        child: Image.asset('assets/BGC_Niagara_Vertical.png'),
      ),
    );

//EMAIL INPUT
    final email = TextFormField(
      validator: (input) {
        if (input.isEmpty) return 'Please enter a valid email.';
      },
      onSaved: (input) => _email = input,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'lj@gmail.com',
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.account_circle,
          color: Colors.bagcGreen,
        ),
        //hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Colors.bagcGreen,
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

//PASSWORD INPUT
    final password = TextFormField(
      validator: (input) {
        if (input.length < 6)
          return 'Your password needs\nto be at least 6 characters.';
      },
      onSaved: (input) => _password = input,
      autofocus: false,
      //initialValue: 'password',
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.bagcGreen,
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0), 
          borderSide: BorderSide(
              color: Colors.bagcGreen,
              width: 2,
            ) 
          ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );

//LOGIN BUTTON
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(24),
        // ),
        onPressed: () {
          signIn();
        },
        padding: EdgeInsets.all(12),
        color: Colors.bagcGreen,
        child: Text('Log In', style: TextStyle(fontSize: 18, color: Colors.white)),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
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
    return WillPopScope(
      //DISABLES BACK BUTTON ON PHONE WHICH WOULD SEND USER TO MY CLASS LIST BYPASSING LOGIN
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
                  email,
                  SizedBox(height: 15.0),
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

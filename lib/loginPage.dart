import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

//
class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool isRemember = false;
  String _validation = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  File jsonFile;
  Directory dir;
  String fileName = 'localUser.json';
  bool fileExist = false;
  Map<String,dynamic> fileContent;
  TextEditingController keyInputController = new TextEditingController();
  TextEditingController valueInputController = new TextEditingController();

@override
  void initState(){
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory){
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist =jsonFile.existsSync();
      if(!fileExist){
        jsonFile = new File(dir.path+'/'+fileName);
        jsonFile.createSync();
        fileExist = true;
        jsonFile.writeAsStringSync(json.encode({'isRemember':false,'_email':'','_password':''}));
      }
      setState(() {
        fileContent = json.decode(jsonFile.readAsStringSync());
        _email = fileContent['_email'];
        _password = fileContent['_password'];
        isRemember = fileContent['isRemember'];
      });
    });
  }

  void writeToFile(String email, String paw,bool isRemember){
    jsonFile.writeAsStringSync(json.encode({'isRemember':isRemember,'_email':email,'_password':paw}));
  }

  @override
  void dispose(){
    keyInputController.dispose();
    valueInputController.dispose();
    super.dispose();
  }


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
      initialValue:_email,
      onSaved: (input) => _email = input,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'lj@gmail.com',
      decoration: InputDecoration(
        labelText: 'Email',
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

//PASSWORD INPUT
    final password = TextFormField(
      validator: (input) {
        if (input.length < 6)
          return 'Your password needs\nto be at least 6 characters.';
      },
      initialValue:_password,
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

//CHECKBOX REMEMBER THE USER
    Checkbox checkButton = Checkbox(
      value: isRemember,activeColor: Color.fromRGBO(123, 193, 67, 1),onChanged: (bool){
        setState(() {
          isRemember = bool;
        });},
    );

//LOGIN BUTTON
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: RaisedButton(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(24),
        // ),
        onPressed: () {
          signIn();
        },
        padding: EdgeInsets.all(12),
        color: Color.fromRGBO(28, 165, 229, 1),
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
                  Container(
                    height: 20,
                    child: ListView (
                    scrollDirection: Axis.horizontal,
                    children:<Widget>[
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
        setState(() {
          _validation = ex.message.toString();
        });
        
      }
    }
    if(isRemember) writeToFile(_email,_password,true);
    else writeToFile('','',false);
  }
}

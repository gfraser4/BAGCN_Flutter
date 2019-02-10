import 'package:flutter/material.dart';

import './main.dart';

class SignUpPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _SignUpPage createState() => new _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
        child: Image.asset('assets/BGC_Niagara_logo.png'),
      ),
    );

    final firstName = TextFormField(
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

    final lastName = TextFormField(
      autofocus: false,
      //initialValue: 'password',
      obscureText: true,
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

    final email = TextFormField(
      autofocus: false,
      //initialValue: 'password',
      obscureText: true,
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

    final confirmPassword = TextFormField(
      autofocus: false,
      //initialValue: 'password',
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        icon: Icon(
          Icons.check_box,
          color: Colors.lightGreen,
        ),
        //hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF1ca5e5),
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signup = FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(color: Color(0xFF1ca5e5)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/signup');
      },
    );

    final choice = Text(
      'Choose your Role:',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Color(0xFF1ca5e5), fontWeight: FontWeight.w600, fontSize: 18),
    );

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
                  'Instructor',
                  style: TextStyle(color: Color(0xFF1ca5e5)),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
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
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ),
      ],
    );

    final loginPage = FlatButton(
      child: Text(
        'Back to Login',
        style: TextStyle(color: Color(0xFF1ca5e5)),
      ),
      onPressed: () {
        // Update the state of the app
        // ...
        // Then close the drawer
        Navigator.pushReplacementNamed(context, '/login');
      },
    );

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
                SizedBox(height: 24.0),
                confirmPassword,
                SizedBox(height: 24.0),
                choice,
                role,
                loginPage
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: true,
//       body:
//       Center(
//         child: ListView(

//           children: <Widget>[

//             Container(
//               margin: EdgeInsets.only(left: 20.0, right: 20.0),
//               child: Image.asset('assets/BGC_Niagara_logo.png'),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                   labelText: 'First Name',
//                   icon: Icon(
//                     Icons.account_circle,
//                     color: Colors.lightGreen,
//                   )),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                   labelText: 'Last Name',
//                   icon: Icon(
//                     Icons.account_circle,
//                     color: Colors.lightGreen,
//                   )),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                   labelText: 'Email',
//                   icon: Icon(
//                     Icons.email,
//                     color: Colors.lightGreen,
//                   )),
//             ),
//             TextFormField(
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: 'Password',
//                   icon: Icon(
//                     Icons.lock,
//                     color: Colors.lightGreen,
//                   )),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(top: 10, right: 10),
//                   child: RaisedButton(
//                     //color: Colors.lightGreen,
//                     child: Row(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.only(right: 5),
//                           child: Icon(
//                             Icons.assignment_ind,
//                             color: Colors.lightGreen,
//                           ),
//                         ),
//                         Text(
//                           'Instructor',
//                           style: TextStyle(color: Colors.lightGreen),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/');
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top: 10, right: 10),
//                   child: RaisedButton(
//                     color: Colors.lightGreen,
//                     child: Row(
//                       children: <Widget>[
//                         Container(
//                           margin: EdgeInsets.only(right: 5),
//                           child: Icon(
//                             Icons.child_care,
//                             color: Colors.lightGreen[50],
//                           ),
//                         ),
//                         Text(
//                           'Parent',
//                           style: TextStyle(color: Colors.lightGreen[50]),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 3.0),
//               child: FlatButton(
//                 child: Text(
//                   'Back to Login',
//                   style: TextStyle(color: Colors.lightGreen),
//                 ),
//                 onPressed: () {
//                   // Update the state of the app
//                   // ...
//                   // Then close the drawer
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),)
//       ;
//   }
// }

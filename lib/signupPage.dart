import 'package:flutter/material.dart';

import './main.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: 
      Center(
        child: ListView(
          
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Image.asset('assets/BGC_Niagara_logo.png'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'First Name',
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.lightGreen,
                  )),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Last Name',
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.lightGreen,
                  )),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email,
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
            Row(
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
                            color: Colors.lightGreen,
                          ),
                        ),
                        Text(
                          'Instructor',
                          style: TextStyle(color: Colors.lightGreen),
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
                    color: Colors.lightGreen,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.child_care,
                            color: Colors.lightGreen[50],
                          ),
                        ),
                        Text(
                          'Parent',
                          style: TextStyle(color: Colors.lightGreen[50]),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 3.0),
              child: FlatButton(
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.lightGreen),
                ),
                onPressed: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),)
      ;
  }
}
// Important: Remove any padding from the ListView.
//padding: EdgeInsets.zero,

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.all(3.0),
//                 child: RaisedButton(
//                   color: Colors.lightGreen,
//                   child: Row(
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(right:5.0),
//                         child: Icon(
//                           Icons.assignment_ind,
//                           color: Colors.lightGreen[50],
//                         ),
//                       ),
//                       Text(
//                         'Instructor',
//                         style: TextStyle(color: Colors.lightGreen[50]),
//                       ),
//                     ],
//                   onPressed: () {
//                     // Update the state of the app
//                     // ...
//                     // Then close the drawer
//                     Navigator.pushReplacementNamed(context, '/');
//                   },
//                 ),
//               ),
//             ],
//           ),
//               Container(
//                 margin: EdgeInsets.all(3.0),
//                 child: RaisedButton(
//                   color: Colors.lightGreen,
//                   child: Row(
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(right:5.0),
//                         child: Icon(
//                           Icons.child_care,
//                           color: Colors.lightGreen[50],
//                         ),
//                       ),
//                       Text(
//                         'Parent',
//                         style: TextStyle(color: Colors.lightGreen[50]),
//                       ),
//                     ],
//                   ),
//                   onPressed: () {
//                     // Update the state of the app
//                     // ...
//                     // Then close the drawer
//                     Navigator.pushReplacementNamed(context, '/');
//                   },
//                 ),
//               ),
//             ],
//           ),

//           ),

//     );
//   }
// }

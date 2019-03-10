import 'package:flutter/material.dart';

import 'package:bagcndemo/Login/loginPage.dart';
import "package:bagcndemo/Signup/signupPage.dart";

//DYNAMIC CHANGE THEME
// import 'package:dynamic_theme/dynamic_theme.dart';

///////////////////////////////////////////////////////////
//**MAIN FUNCTION TO LAUNCH APP --> CALLS MyApp() WIDGET**\\
///////////////////////////////////////////////////////////

void main(){
  runApp( MyApp());}

  // DARK THEME NOT USED FOR NOW
  //   new DynamicTheme(
  //     defaultBrightness: Brightness.light,
  //     data: (brightness) => new ThemeData(
  //                // Theme data for app *FONT NOT CURRENTLY WORKING*
  //               brightness: brightness,
  //               primaryColor: Color.fromRGBO(123, 193, 67, 1),
  //               accentColor: Color.fromRGBO(28, 165, 229, 1),
  //               hintColor: Color.fromRGBO(41, 60, 62, 0.7),
  //               errorColor: Color.fromRGBO(183, 33, 38, 1),
  //               textTheme: TextTheme(
  //                 headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //                 title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //                 body1: TextStyle(fontSize: 14.0),
  //               ),
  //             ),
  //     themedWidgetBuilder: (context, theme) {
  //       return MaterialApp(
  //         title: 'BAGC Niagara',
  //         theme:theme,
  //         // home: MyApp(),
  //         debugShowCheckedModeBanner: false,
  //         // Page routes --> defaults at login for now
  //         initialRoute: '/',
  //         routes: {
  //           //'/main': (context) => MyClassList(),
  //           '/': (context) => LoginPage(),
  //           '/signup': (context) => SignUpPage(),
  //           //'/addClasses': (context) => 
  //         },
  //       );
  //     }
  //   )
  // );
//}

//MyApp WIDGET - OVERALL APP STYLING AND ROUTES
class MyApp extends StatelessWidget {
  final appTitle = 'BAGC Niagara';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
      //Theme data for app *FONT NOT CURRENTLY WORKING*
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(123, 193, 67, 1),
        accentColor: Color.fromRGBO(28, 165, 229, 1),
        hintColor: Color.fromRGBO(41, 60, 62, 0.7),
        errorColor: Color.fromRGBO(183, 33, 38, 1),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0),
        ),
      ),
      title: appTitle,
    );
  }
}




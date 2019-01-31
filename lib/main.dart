import 'package:flutter/material.dart';

import './aboutPage.dart';
import './addClassesPage.dart';
import './messagesPage.dart';
import './settingsPage.dart';
import './classAnnouncementPage.dart';
import './loginPage.dart';
import './signupPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'My Classes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        '/': (context) => MyHomePage(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.lightGreen,
        accentColor: Colors.lightGreen,

        // Define the default Font Family
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      title: appTitle,
      //home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Classes')),
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Divider(
            color: Colors.lightGreen,
          ),
          ListTile(
              trailing: Icon(
                Icons.warning,
                color: Colors.redAccent,
              ),
              title: Text('Aquatics 101'),
              subtitle: Text('Section: 2\nInstructor: John Smith'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ClassPage('Aquatics 2 - Annoucements')),
                );
              }),
          Divider(
            color: Colors.lightGreen,
          ),
          ListTile(
              title: Text('Teen Zone'),
              subtitle: Text('Section: 1\nInstructor: Jane Doe'),
              onTap: () {}),
          Divider(
            color: Colors.lightGreen,
          ),
          ListTile(
              title: Text('Jr. Ball Hockey/Soccer'),
              subtitle: Text('Section: 1\nInstructor: Bobby Orr'),
              onTap: () {}),
          Divider(
            color: Colors.lightGreen,
          ),
          ListTile(
              title: Text('Gymnastics'),
              subtitle: Text('Section: 3\nInstructor: Laura Smith'),
              onTap: () {}),
          Divider(
            color: Colors.lightGreen,
          ),
          ListTile(
              title: Text('Kitchen Creations'),
              subtitle: Text('Section: 1\nInstructor: Julie Cook'),
              onTap: () {}),
          Divider(
            color: Colors.lightGreen,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20, bottom: 5),
                child: FittedBox(
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddClassesPage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/BGC_Niagara_logo.png'),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.announcement,
                color: Colors.redAccent,
              ),
              title: Text('Messages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesPage()),
                );
              },
            ),
            Divider(
              color: Colors.lightGreen,
            ),
            ListTile(
              title: Text('Manage Classes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddClassesPage()),
                );
              },
            ),
            Divider(
              color: Colors.lightGreen,
            ),
            ListTile(
              title: Text('Profile Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            Divider(
              color: Colors.lightGreen,
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

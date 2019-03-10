import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';

//IMPORT OTHER PAGES SO CAN BE NAVIGATED TO
import 'package:bagcndemo/About/aboutPage.dart';
import 'package:bagcndemo/AddClasses/addClassesPage.dart';
import 'package:bagcndemo/Settings/settingsPage.dart';
import "package:bagcndemo/MyClasses/myClassesLogic.dart";

//DYNAMIC CHANGE THEME
import 'package:dynamic_theme/dynamic_theme.dart';


///////////////////////////////////
//**HAMBURGER DRAWER MENU WIDGET**\\
////////////////////////////////////

Widget navDrawer(BuildContext context, FirebaseUser user, bool isSuper) {
  return Drawer(
    elevation: 50,
    child: Container(
      // color: Color(0xFFF4F5F7),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
            child: Image.asset(
              'assets/BGC_Niagara_logo.png',
            ),
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 0.7, // has the effect of extending the shadow
                  offset: Offset(
                    -1.0, // horizontal, move right 10
                    1.0, // vertical, move down 10
                  ),
                ),
              ],
              color: Colors.white,
            ),
          ),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          isSuper == true ?  //&& matches(user.email, '@bagcn.com') 
          ListTile(
            leading:
                Icon(Icons.settings, color: Color.fromRGBO(28, 165, 229, 1)),
            title: Text('Manage Classes'),
            onTap: () {
              MyClassesLogic.navToAddClasses(context, user);
            },
          ) : ListTile(
            leading:
                Icon(Icons.settings, color: Color.fromRGBO(28, 165, 229, 1)),
            title: Text('Join Classes'),
            onTap: () {
              MyClassesLogic.navToJoinClasses(context, user);
            },
          ),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          ListTile(
            leading: Icon(Icons.account_circle,
                color: Color.fromRGBO(28, 165, 229, 1)),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(user)),
              );
            },
          ),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Color.fromRGBO(28, 165, 229, 1)),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          ListTile(
            leading:
                Icon(Icons.exit_to_app, color: Color.fromRGBO(28, 165, 229, 1)),
            title: Text('Sign Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
            },
          ),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
        ],
      ),
    ),
  );
}
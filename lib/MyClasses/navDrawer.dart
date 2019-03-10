import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//IMPORT OTHER PAGES SO CAN BE NAVIGATED TO
import 'package:bagcndemo/About/aboutPage.dart';
import 'package:bagcndemo/Settings/settingsPage.dart';
import "package:bagcndemo/MyClasses/myClassesLogic.dart";

//DYNAMIC CHANGE THEME
import 'package:dynamic_theme/dynamic_theme.dart';

//**HAMBURGER DRAWER MENU WIDGET**\\

Widget navDrawer(BuildContext context, FirebaseUser user, bool isSuper) {
  return Drawer(
    elevation: 50,
    child: Container(
      // color: Color(0xFFF4F5F7),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeaderLogoArea(),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          manageClassesTile(isSuper, context, user),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          new ProfileSettingsTile(),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          new AboutTile(),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          // new DarkModeTile(),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
          new SignOutTile(),
          Divider(
            color: Color.fromRGBO(123, 193, 67, 1),
          ),
        ],
      ),
    ),
  );
}

// MANAGE CLASSES TILE
Widget manageClassesTile(
    bool isSuper, BuildContext context, FirebaseUser user) {
  if (isSuper == true) {
    return ListTile(
      leading: Icon(Icons.settings, color: Color.fromRGBO(28, 165, 229, 1)),
      title: Text('Manage Classes'),
      onTap: () {
        MyClassesLogic.navToAddClasses(context, user);
      },
    );
  } else {
    return ListTile(
      leading: Icon(Icons.settings, color: Color.fromRGBO(28, 165, 229, 1)),
      title: Text('Manage Classes'),
      onTap: () {
        MyClassesLogic.navToJoinClasses(context, user);
      },
    );
  }
}

// SIGN OUT TILE
class SignOutTile extends StatelessWidget {
  const SignOutTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Color.fromRGBO(28, 165, 229, 1)),
      title: Text('Sign Out'),
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
      },
    );
  }
}

// DARK MODE TILE
class DarkModeTile extends StatelessWidget {
  const DarkModeTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.lightbulb_outline,
        color: Color.fromRGBO(28, 165, 229, 1),
      ),
      title: Text('Dark Mode'),
      trailing: Checkbox(
        value: Theme.of(context).brightness == Brightness.dark ? true : false,
        activeColor: Color.fromRGBO(123, 193, 67, 1),
        onChanged: (bool) {
          DynamicTheme.of(context).setBrightness(
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark);
        },
      ),
    );
  }
}

// ABOUT TILE
class AboutTile extends StatelessWidget {
  const AboutTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.info, color: Color.fromRGBO(28, 165, 229, 1)),
      title: Text('About'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
      },
    );
  }
}

// PROFILE SETTINGS TILE
class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(Icons.account_circle, color: Color.fromRGBO(28, 165, 229, 1)),
      title: Text('Profile Settings'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      },
    );
  }
}

// DRAWER HEADER AREA
class DrawerHeaderLogoArea extends StatelessWidget {
  const DrawerHeaderLogoArea({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
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
    );
  }
}

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Settings')),
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            trailing: TextFormField(
              decoration: InputDecoration(
                  labelText: 'First Name',
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.lightGreen,
                  )),
            ),
          ),
          ListTile(
            trailing: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Last Name',
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.lightGreen,
                  )),
            ),
          ),
          ListTile(
            trailing: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Colors.lightGreen,
                  )),
            ),
          ),
          ListTile(
            trailing: RaisedButton(
              color: Colors.lightGreen,
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              onPressed: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

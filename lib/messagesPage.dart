import 'package:flutter/material.dart';

import './newMessagePage.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
              trailing: Icon(
                Icons.announcement,
                color: Colors.redAccent,
              ),
              title: Text('John Smith - Aquatics 101'),
              subtitle: Text('Yes, class is cancelled tomorrow.'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMessagePage()),
                );
              }),
          ListTile(
            title: Text('Jane Doe - Teen Zone'),
            subtitle: Text('Thanks for letting me know.'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

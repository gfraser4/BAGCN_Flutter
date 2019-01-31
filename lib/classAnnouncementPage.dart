import 'package:flutter/material.dart';

import './newMessagePage.dart';

class ClassPage extends StatelessWidget {
  final String title;

  ClassPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '$title',
      )),
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              trailing: Icon(
                Icons.warning,
                color: Colors.redAccent,
              ),
              title: Text(
                'Class Cancelled Tomorrow',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                '2019-01-25\n\nDue the continuing issues with the pool, class will be cancelled tomorrow. Please message me if you have any questions. Thanks.',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMessagePage()),
                );
              },
            ),
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Second pair of clothes',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                '2018-11-22\n\nWe will be doing a survival swim tomorrow so please send a second/swimmable pair of clothes tomorrow.',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMessagePage()),
                );
              },
            ),
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Arrive on time!',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                '2018-10-13\n\nPlease arrive on time as we will be starting right away.',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewMessagePage()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMessagePage()),
          );
        },
      ),
    );
  }
}

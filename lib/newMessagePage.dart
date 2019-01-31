import 'package:flutter/material.dart';

class NewMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(title: Text('John Smith')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Card(
            color: Colors.lightGreen[100],
            margin: EdgeInsets.only(top: 10.0, right: 60.0, left: 10.0),
            child: ListTile(
              title: Text(
                'You',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle: Text('So class is cancelled?'),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[100],
            margin: EdgeInsets.only(top: 10.0, right: 60.0, left: 10.0),
            child: ListTile(
              title: Text(
                'You',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle: Text('Nevermind...'),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 60.0),
            child: ListTile(
              title: Text(
                'John Smith',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle: Text('Yes, class is cancelled tomorrow.'),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[100],
            margin: EdgeInsets.only(top: 10.0, right: 60.0, left: 10.0),
            child: ListTile(
              title: Text(
                'You',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle: Text('Yeah I just saw the anouncement, thanks.'),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 60.0),
            child: ListTile(
              title: Text(
                'John Smith',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle:
                  Text("No problem, next week's class is still on schedule."),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 60.0),
            child: ListTile(
              title: Text(
                'John Smith',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle:
                  Text("No problem, next week's class is still on schedule."),
              onTap: () {},
            ),
          ),
          Card(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 60.0),
            child: ListTile(
              title: Text(
                'John Smith',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0),
              ),
              subtitle:
                  Text("No problem, next week's class is still on schedule."),
              onTap: () {},
            ),
          ),
          Container(
            color: Colors.lightGreen[50],
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'New Message...',
                filled: true,
                suffixIcon:
                    IconButton(icon: Icon(Icons.send, color: Colors.lightGreen,), onPressed: () {}),
              ),
              
            ),
          ),
        ],
      ),
    );
  }
}

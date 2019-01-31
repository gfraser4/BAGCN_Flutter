import 'package:flutter/material.dart';

class AddClassesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Classes')),
      body: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Search Classes', icon: Icon(Icons.search)),
          ),
          ListTile(
            trailing: new DropdownButton<String>(
              items: <String>[
                'Aquatics',
                'Sports & Rec',
                'Educational',
                'Child Care',
                'Youth Outreach'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            leading: Text('Program'),
            onTap: () {},
          ),
          ListTile(
            trailing: new DropdownButton<String>(
              items: <String>[
                'Aquatics 101',
                'Gymnastics',
                'Jr. Ball Hockey/Soccer',
                'Kitchen Creations',
                'Teen Zone'
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            leading: Text('Class Name'),
            onTap: () {},
          ),
          ListTile(
            trailing: new DropdownButton<String>(
              items: <String>[
                'Section 1',
                'Section 2',
                'Section 3',
              ].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            leading: Text('Section'),
            onTap: () {},
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Aqautics 101',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                'Section 2\n\nInstructor: John Smith',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {

              },
              trailing: RaisedButton(
                    child: Text('LEAVE', style: TextStyle(color: Colors.redAccent),),
                    onPressed: () {
                                      // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                    },
                  ),
            ),
          
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Gymnastics',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                'Section 2\n\nInstructor: Laura Smith',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {

              },
              trailing: RaisedButton(
                    child: Text('LEAVE', style: TextStyle(color: Colors.redAccent),),
                    onPressed: () {
                                      // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                    },
                  ),
            ),
          
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Jr. Ball Hockey/Soccer',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                'Section 2\n\nInstructor: Bobby Orr',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {

              },
              trailing: RaisedButton(
                    child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
                    onPressed: () {
                                      // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                    },
                  ),
            ),
          
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Kitchen Creations',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                'Section 2\n\nInstructor: Julie Cook',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {

              },
              trailing: RaisedButton(
                    child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
                    onPressed: () {
                                      // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                    },
                  ),
            ),
          
          ),
          Card(
            color: Colors.lightGreen[100],
            child: ListTile(
              title: Text(
                'Teen Zone',
                style: TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                'Section 2\n\nInstructor: Jane Doe',
                style: TextStyle(fontSize: 12.0),
              ),
              onTap: () {

              },
              trailing: RaisedButton(
                    child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
                    onPressed: () {
                                      // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                    },
                  ),
            ),
          
          ),

        ],
      ),
    );
  }
}

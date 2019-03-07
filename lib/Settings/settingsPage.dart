import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => new _SettingsPage();
}

bool isChange = false;

class _SettingsPage extends State<SettingsPage> {
ListView _profileDetail(){
        return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:<Widget>[
          Container(
            margin: const EdgeInsets.all(30),
            padding: EdgeInsets.only(bottom: 7, top: 7),
            // color: Color.fromRGBO(28, 165, 229, 1),
            child: GridView.extent(
              maxCrossAxisExtent: 180,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[                
                Container(
                  child: Text('User:',style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),)
                ),
                Container(
                  child: Text('John:',style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black),)
                ),
                Container(
                  child: Text('User:',style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),)
                ),
                Container(
                  child: Text('User:',style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black),)
                ),
                Container(
                  child: Text('Dark Mode:',style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),)
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 120),
                  child: Checkbox(value:Theme.of(context).brightness == Brightness.dark? true: false,activeColor: Color.fromRGBO(123, 193, 67, 1),onChanged: (bool){
                    DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
                  },
                ),
                )
              ]
            )
          ),
          SizedBox(height: 14,),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RaisedButton(
              // color: Color.fromRGBO(123, 193, 67, 1),
              color: Colors.red,
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                isChange = true;
                setState(() {});
              },
            ),
          ),
        ]
      );
    }
ListView _changeProfile(){
        return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children:<Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 7, top: 7),
            // color: Color.fromRGBO(28, 165, 229, 1),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[                
                Container(
                  margin: EdgeInsets.all(5),
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'User:',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      new TextSpan(text: 'John Smith'), //ADD REAL NAME FROM DATABASE HERE
                    ],
                  ),
                ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'Email Address: ',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                      new TextSpan(text: 'parent@gmail.com'), //ADD Email FROM DATABASE HERE
                    ],
                  ),
                ),
                ),
              ]
            )
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Change First Name',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Change Last Name',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
            ),
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Change Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
            ),
          ),
          SizedBox(height: 14,),
          ListTile(
            trailing: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Change Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color.fromRGBO(123, 193, 67, 1),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,
                    ) 
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
            ),
          ),
          SizedBox(height: 14,),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RaisedButton(
              color: Color.fromRGBO(123, 193, 67, 1),
              child: Text(
                'SAVE',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                isChange = false;
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 14,),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: RaisedButton(
              color: Colors.red,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.lightGreen[50]),
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                isChange = false;
                setState(() {});

              },
            ),
          ),
        ]
      );
    }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: isChange?_changeProfile():_profileDetail(),
    );
  }
}
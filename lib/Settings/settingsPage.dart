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
          Container(
            padding: EdgeInsets.only(bottom: 7, top: 7),
            color: Color.fromRGBO(28, 165, 229, 1),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: <Widget>[                
                new CurrentName(),
                new CurrentEmail(),
              ]
            )
          ),
          SizedBox(height: 14,),
          new ChangeFirstName(),
          SizedBox(height: 14,),
          new ChangeLastName(),
          SizedBox(height: 14,),
          new ChangeEmail(),
          SizedBox(height: 14,),
          new ChangePassword(),
          SizedBox(height: 14,),
          new SaveButtonArea(),
        ],
      ),
    );
  }
}

// SAVE BUTTON AREA
class SaveButtonArea extends StatelessWidget {
  const SaveButtonArea({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: RaisedButton(
        color: Color.fromRGBO(123, 193, 67, 1),
        child: Text(
          'SAVE',
          style: TextStyle(color: Colors.lightGreen[50]),
        ),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        onPressed: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
    );
  }
}

// CHANGE PASSWORD
class ChangePassword extends StatelessWidget {
  const ChangePassword({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

// CHANGE EMAIL
class ChangeEmail extends StatelessWidget {
  const ChangeEmail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

// CHANGE LAST NAME
class ChangeLastName extends StatelessWidget {
  const ChangeLastName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

// CHANGE FIRST NAME
class ChangeFirstName extends StatelessWidget {
  const ChangeFirstName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}

// CURRENT EMAIL
class CurrentEmail extends StatelessWidget {
  const CurrentEmail({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: 'Current Email: ',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: 'parent@gmail.com'), //ADD Email FROM DATABASE HERE
        ],
      ),
    ),
    );
  }
}

// CURRENT NAME
class CurrentName extends StatelessWidget {
  const CurrentName({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: RichText(
      textAlign: TextAlign.center,
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: 'Current Name: ',
              style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: 'John Smith'), //ADD REAL NAME FROM DATABASE HERE
        ],
      ),
    ),
    );
  }
}

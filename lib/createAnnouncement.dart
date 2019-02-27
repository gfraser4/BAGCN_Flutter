import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Models/AnnouncementsModel.dart';

//CREATE ANNOUNCEMENT PAGE --> REQUIRES title and code PASSED TO IT AS ARGUMENTS
class AnnouncementPage extends StatefulWidget {
  final String title;
  final int code;
  AnnouncementPage(this.title, this.code);
  @override
  _AnnouncementPage createState() {
    return _AnnouncementPage();
  }
}

class _AnnouncementPage extends State<AnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1ca5e5),
      appBar: AppBar(
        title: Text('Create Announcement'),
      ),
      resizeToAvoidBottomPadding: true,
      body: _buildBody(context, widget.title, widget.code), //build body of page pasing CLASS TITLE and CLASS CODE to be used for update
    );
  }
}

Widget _buildBody(BuildContext context, String title, int code) {
  //AUTO DATE FIELD --> NEEDS TO BE FORMATTED
  DateTime nowTime = new DateTime.now().toUtc();
  //INPUT FIELD FOR TITLE
  final _titleController = new TextEditingController();
  //INPUT FIELD FOR DESCRIPTION
  final _descriptionController = new TextEditingController();
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        color: Colors.lightBlue[50],
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 36.0),
            Text(
              '$title - $code',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF1ca5e5),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            SizedBox(height: 58.0),
            TextFormField(
              autofocus: false,
              controller: _titleController, //set controller for title textfield
              decoration: InputDecoration(
                labelText: 'Announcement Title',
                icon: Icon(
                  Icons.title,
                  color: Colors.lightGreen,
                ),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            SizedBox(height: 58.0),
            TextFormField(
              autofocus: false,
              controller: _descriptionController, //set controller for description textfield
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Add the announcement...',
                icon: Icon(
                  Icons.description,
                  color: Colors.lightGreen,
                ),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            SizedBox(height: 58.0),
            RaisedButton(
                color: Color(0xFF1ca5e5),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.lightBlue[50]),
                ),
                onPressed: () { //FIRESTORE CREATE ANNOUNCEMENT STATEMENT USING title, code, _titleController.text, _descriptionController.text, nowTime
                  Navigator.pop(context);
                  var newAnnouncement = Firestore.instance
                      .collection('announcements').document();
                      
                  newAnnouncement
                    .setData({ 
                    'id': newAnnouncement.documentID,  
                    'code': code,
                    'commentCount': 0,
                    'class': title,
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'created': nowTime,
                    'likes': 0,
                    'likedUsers':[],
                    'notifyUsers': [],
                  });
                }),
            SizedBox(height: 36.0),
          ],
        ),
      ),
    ),
  );
}



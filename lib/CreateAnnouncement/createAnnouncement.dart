import 'package:flutter/material.dart';

import 'package:bagcndemo/CreateAnnouncement/createLogic.dart';

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
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
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
      child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Text(
              '$title - $code',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFF4F5F7),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            Divider(color: Colors.grey, height: 10,),
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            color: Color(0xFFF4F5F7),
            child: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(20, 10.0, 20, 10),
              children: <Widget>[
                SizedBox(height: 10),
            TextFormField(
              autofocus: false,
              controller: _titleController, //set controller for title textfield
              decoration: InputDecoration(
                labelText: 'Announcement Title',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,) 
                    ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              autofocus: false,
              controller: _descriptionController, //set controller for description textfield
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Description',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0), 
                  borderSide: BorderSide(
                    color: Color.fromRGBO(123, 193, 67, 1),
                    width: 2,) 
                    ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0)),
              ),
            ),
            SizedBox(height: 30.0),
            RaisedButton(
                color: Color.fromRGBO(123, 193, 67, 1),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () { //FIRESTORE CREATE ANNOUNCEMENT STATEMENT USING title, code, _titleController.text, _descriptionController.text, nowTime
                  Navigator.pop(context);
                  CreateAnnouncementLogic.createAnnouncement(code, title, _titleController.text, _descriptionController.text, nowTime);
                }),
            SizedBox(height: 20.0),
              ]
            ),
            ),
          ],
        ),
      ),
  );
}



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/AnnouncementsModel.dart';
import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/CreateAnnouncement/createLogic.dart';

final FocusNode _descriptionFocus = FocusNode();

//CREATE ANNOUNCEMENT PAGE --> REQUIRES title and code PASSED TO IT AS ARGUMENTS
class EditAnnouncementPage extends StatefulWidget {
  final Announcements announcements;
  final user;
  EditAnnouncementPage(this.announcements, this.user);
  @override
  _EditAnnouncementPage createState() {
    return _EditAnnouncementPage();
  }
}

class _EditAnnouncementPage extends State<EditAnnouncementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime nowTime = new DateTime.now().toUtc();
// //   //INPUT FIELD FOR TITLE
//    final _titleController = new TextEditingController();
//   // //INPUT FIELD FOR DESCRIPTION
//   final _descriptionController = new TextEditingController();
  String _aTitle;
  String _aDescription;
  @override
  Widget build(BuildContext context) {
    _aTitle = widget.announcements.title;
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: AppBar(
        title: Text('Edit Announcement'),
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Text(
                '${widget.announcements.title} - ${widget.announcements.code}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFF4F5F7),
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              Divider(
                color: Colors.grey,
                height: 10,
              ),
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xFFF4F5F7),
                child: Form(
                  key: _formKey,
                  child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(20, 10.0, 20, 10),
                      children: <Widget>[
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: widget.announcements.title,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Please enter a title for the announcement.';
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _aTitle = input,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocus);
                          },
                          autofocus: false,
                          // controller:
                          //     _titleController, //set controller for title textfield
                          decoration: InputDecoration(
                            labelText: 'Announcement Title',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(123, 193, 67, 1),
                                  width: 2,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          initialValue: widget.announcements.description,
                          textInputAction: TextInputAction.done,
                          focusNode: _descriptionFocus,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Please enter the announcement.';
                          },
                          onSaved: (input) => _aDescription = input,
                          autofocus: false,
                          // controller:
                          //     _descriptionController, //set controller for description textfield
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            //alignLabelWithHint: true,
                            labelText: 'Description',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(123, 193, 67, 1),
                                  width: 2,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Color.fromRGBO(123, 193, 67, 1),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            RaisedButton(
                              color: Color.fromRGBO(123, 193, 67, 1),
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                //FIRESTORE CREATE ANNOUNCEMENT STATEMENT USING title, code, _titleController.text, _descriptionController.text, nowTime
                                final formState = _formKey.currentState;
                                if (formState.validate()) {
                                  //login to firebase
                                  formState.save();

                                  AnnouncementLogic.editAnnouncement(
                                      widget.user,
                                      _aTitle,
                                      _aDescription,
                                      widget.announcements.id);

                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ), //build body of page pasing CLASS TITLE and CLASS CODE to be used for update
    );
  }
}

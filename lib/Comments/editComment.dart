import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bagcndemo/Models/AnnouncementsModel.dart';
import 'package:bagcndemo/Announcements/announcementLogic.dart';
import 'package:bagcndemo/CreateAnnouncement/createLogic.dart';
import 'package:bagcndemo/Comments/commentsLogic.dart';
import 'package:bagcndemo/Models/Comments.dart';

final FocusNode _descriptionFocus = FocusNode();

//CREATE ANNOUNCEMENT PAGE --> REQUIRES title and code PASSED TO IT AS ARGUMENTS
class EditCommentPage extends StatefulWidget {
  final Comments comments;
  final user;
  EditCommentPage(this.comments, this.user);
  @override
  _EditCommentPage createState() {
    return _EditCommentPage();
  }
}

class _EditCommentPage extends State<EditCommentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime nowTime = new DateTime.now().toUtc();
// //   //INPUT FIELD FOR TITLE
//    final _titleController = new TextEditingController();
//   // //INPUT FIELD FOR DESCRIPTION
//   final _descriptionController = new TextEditingController();
  String _cContent;
  @override
  Widget build(BuildContext context) {
    _cContent = widget.comments.content;
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: AppBar(
        title: Text('Edit Comment'),
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
                'Edit your comment...',
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
                        SizedBox(height: 30.0),
                        TextFormField(
                          initialValue: widget.comments.content,
                          textInputAction: TextInputAction.done,
                          focusNode: _descriptionFocus,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Please enter a comment.';
                          },
                          onSaved: (input) => _cContent = input,
                          autofocus: false,
                          // controller:
                          //     _descriptionController, //set controller for description textfield
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            //alignLabelWithHint: true,
                            labelText: 'Comment',
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

                                  editComment ( context,
                                      widget.user,
                                      _cContent,
                                      widget.comments.commentID);

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

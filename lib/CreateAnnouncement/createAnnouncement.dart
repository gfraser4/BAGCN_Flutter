import 'package:flutter/material.dart';

import 'package:bagcndemo/CreateAnnouncement/createLogic.dart';

final FocusNode _descriptionFocus = FocusNode();

//CREATE ANNOUNCEMENT PAGE --> REQUIRES title and code PASSED TO IT AS ARGUMENTS
class AnnouncementPage extends StatefulWidget {
  final String title;
  final int code;
  final user;
  AnnouncementPage(this.title, this.code, this.user);
  @override
  _AnnouncementPage createState() {
    return _AnnouncementPage();
  }
}

class _AnnouncementPage extends State<AnnouncementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime nowTime = new DateTime.now().toUtc();
  String _aTitle;
  String _aDescription;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: AppBar(
        title: Text('Create Announcement'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Text(
                '${widget.title} - ${widget.code}',
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(20, 10.0, 20, 10),
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
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
                        focusNode: _descriptionFocus,
                        validator: (input) {
                          if (input.isEmpty)
                            return 'Please enter the announcement.';
                        },
                        onSaved: (input) => _aDescription = input,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
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
                      RaisedButton(
                        color: Color.fromRGBO(123, 193, 67, 1),
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          final formState = _formKey.currentState;
                          if (formState.validate()) {
                            formState.save();
                            try {
                              CreateAnnouncementLogic.createAnnouncement(
                                  widget.code,
                                  widget.title,
                                  _aTitle,
                                  _aDescription,
                                  nowTime,
                                  widget.user);
                            } catch (ex) {
                              print(ex.toString());
                            }
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

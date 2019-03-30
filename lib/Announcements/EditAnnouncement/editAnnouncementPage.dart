import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
// LOGIC
import 'package:bagcndemo/Announcements/announcementLogic.dart';
// MODELS
import 'package:bagcndemo/Models/AnnouncementsModel.dart';


final FocusNode _descriptionFocus = FocusNode();

// EDIT ANNOUNCEMENT PAGE 
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: ListView(
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
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(20, 10.0, 20, 10),
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: widget.announcements.title,
                        validator: (input) {
                          if (input.trim().isEmpty)
                            return 'Please enter a title for the announcement.';
                          else if (isAscii(input) == false)
                            return 'Title has invalid characters';
                          else if(input.length <= 3)
                            return 'Title must contain 3 characters or more.'; 
                          else if(input.length > 20)
                            return 'Title must be 20 characters or less.'; 
                        },
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _aTitle = input,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        autofocus: false,
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
                        focusNode: _descriptionFocus,
                        validator: (input) {
                          if (input.trim().isEmpty)
                            return 'Please enter the announcement.';
                          else if (isAscii(input) == false)
                            return 'Description has invalid characters';
                          else if(input.length <= 3)
                            return 'Description must contain 3 characters or more.'; 
                          else if(input.length > 200)
                            return 'Description must be 200 characters or less.'; 
                        },
                        onSaved: (input) => _aDescription = input,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(
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
                              final formState = _formKey.currentState;
                              if (formState.validate()) {
                                formState.save();
                                AnnouncementLogic.editAnnouncement(
                                    widget.user,
                                    _aTitle.trim(),
                                    _aDescription.trim(),
                                    widget.announcements.id);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
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

import 'package:flutter/material.dart';
// LOGIC
import 'package:bagcndemo/Comments/commentsLogic.dart';
// MODELS
import 'package:bagcndemo/Models/Comments.dart';

//CREATE A COMMENT REPLY
class ReplyPage extends StatefulWidget {
  final Comments comments;
  final user;
  ReplyPage(this.comments, this.user);
  @override
  _ReplyPage createState() {
    return _ReplyPage();
  }
}

class _ReplyPage extends State<ReplyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime nowTime = new DateTime.now().toUtc();
  String _cContent;
  @override
  Widget build(BuildContext context) {
    _cContent = widget.comments.content;
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 165, 229, 1),
      appBar: AppBar(
        title: Text('Reply'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Text(
                'Reply to:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFF4F5F7),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                '"${widget.comments.content}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFF4F5F7),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              ),
              Divider(
                color: Colors.transparent,
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
                    padding: EdgeInsets.fromLTRB(20, 20.0, 20, 10),
                    children: <Widget>[
                      // SizedBox(height: 10),
                      // SizedBox(height: 30.0),
                      TextFormField(
                        validator: (input) {
                          if (input.trim().isEmpty)
                            return 'Please enter the reply.';
                          else if (input.length > 60)
                            return 'Reply must be 60 characters or less.';
                        },
                        onSaved: (input) => _cContent = input,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Reply',
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
                      SizedBox(height: 10.0),
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
                                createReply(
                                    context,
                                    widget.user,
                                    _cContent.trim(),
                                    widget.comments.commentID,
                                    widget.comments.announcementID);
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

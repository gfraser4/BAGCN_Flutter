import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: _buildBody(context, widget.title, widget.code),
    );
  }
}

Widget _buildBody(BuildContext context, String title, int code) {
  DateTime nowTime = new DateTime.now().toUtc();
  final _titleController = new TextEditingController();
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
              controller: _titleController,
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
              controller: _descriptionController,
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
                onPressed: () {
                  Navigator.pop(context);
                  Firestore.instance
                      .collection('announcements')
                      .document()
                      .setData({
                    'code': code,
                    'class': title,
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'created': nowTime,
                  });
                }),
            SizedBox(height: 36.0),
          ],
        ),
      ),
    ),
  );

  // StreamBuilder<QuerySnapshot>(
  //   stream: Firestore.instance.collection('announcements').snapshots(),
  //   builder: (context, snapshot) {
  //     if (!snapshot.hasData) return LinearProgressIndicator();

  //     return _buildList(context, snapshot.data.documents);
  //   },
  // );
}

class Announcements {
  final String clsName;
  final String title;
  final String description;
  final DateTime created;
  final int code;
  final DocumentReference reference;

  Announcements.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['class'] != null),
        assert(map['description'] != null),
        assert(map['title'] != null),
        assert(map['created'] != null),
        assert(map['code'] != null),
        code = map['code'],
        clsName = map['class'],
        title = map['title'],
        created = map['created'],
        description = map['description'];

  Announcements.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$clsName:$title>";
}

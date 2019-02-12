import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './newMessagePage.dart';
import 'createAnnouncement.dart';

//ClassPage WIDGET - SHOWS ANNOUNCEMENTS FOR SPECIFIC CLASS --> REQUIRES A title AND code ARGURMENT PASSED TO IT
class ClassPage extends StatefulWidget {
  final String title;
  final int code;
  ClassPage(this.title, this.code);
  @override
  _ClassPage createState() {
    return _ClassPage();
  }
}

//HOW PAGE IS BUILT
class _ClassPage extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title), //PAGE TITLE BASED ON title THAT WAS PASSED TO PAGE
      ),
      body: _buildBody(context, widget.title, widget.code), //HOW BODY IS BUILT PASSING CLASS title AND CLASS code to _buildBody() WIDGET FOR QUERY
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AnnouncementPage(widget.title, widget.code)), //NAVIGATION TO CREATE ANNOUNCEMENT --> AGAIN PASSING title AND code SO ANNOUNCEMENT IS MADE FOR SPECIFIC CLASS
          );
        },
      ),
    );
  }
}

//QUERY FIRESTORE FOR ALL ANNOUNCEMENTS FOR A CLASS --> WHERE CLAUSE SEARCHES FOR title OF CLASS AND code FOR CLASS
Widget _buildBody(BuildContext context, String title, int code) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('announcements')
        .where('class', isEqualTo: title)
        .where('code', isEqualTo: code)
        //.orderBy('created', descending: true )
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

//widget to build list of announcements based on class and class code
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

//widget to build individual card item for each announcement from original query
Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final announcements = Announcements.fromSnapshot(data);
  return Padding(
    key: ValueKey(announcements.clsName),
    padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
    child: Card(
        elevation: 5.0,
        color: Colors.lightBlue[100],
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  announcements.title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                    'Posted to: ${announcements.clsName}\nPosted on: ${announcements.created}\n\n${announcements.description}'),
              ),
              Divider(
                color: Color(0xFF1ca5e5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          color: Color(0xFF1ca5e5),
                          onPressed: () {},
                        ),
                        Text('0',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1ca5e5),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.forum),
                          color: Color(0xFF1ca5e5),
                          onPressed: () {
                            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewMessagePage()),
                      );
                          },
                        ),
                        Text('0',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1ca5e5),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Color(0xFF1ca5e5),
                    onPressed: () {
                      
                    },
                  ),
                ],
              )
            ],
          ),
        )),
  );
}

//class used for mapping of announcements query --> essentially has fields initialized and then mapped to their field in the database
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


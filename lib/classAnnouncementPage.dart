import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './newMessagePage.dart';
import 'createAnnouncement.dart';

class ClassPage extends StatefulWidget {
  final String title;
  final int code;
  ClassPage(this.title, this.code);
  @override
  _ClassPage createState() {
    return _ClassPage();
  }
}

class _ClassPage extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(context, widget.title, widget.code),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AnnouncementPage(widget.title, widget.code)),
          );
        },
      ),
    );
  }
}

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

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 8.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final announcements = Announcements.fromSnapshot(data);
  final _likesCountController = new TextEditingController();
  int likes = 0;
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

// class ClassPage extends StatelessWidget {
//   final String title;

//   ClassPage(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(
//         '$title',
//       )),
//       body: ListView(
//         // Important: Remove any padding from the ListView.
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           Card(
//             color: Colors.lightGreen[100],
//             child: ListTile(
//               trailing: Icon(
//                 Icons.warning,
//                 color: Colors.redAccent,
//               ),
//               title: Text(
//                 'Class Cancelled Tomorrow',
//               ),
//               subtitle: Text(
//                 '2019-01-25\n\nDue the continuing issues with the pool, class will be cancelled tomorrow. Please message me if you have any questions. Thanks.',
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewMessagePage()),
//                 );
//               },
//             ),
//           ),
//           Card(
//             color: Colors.lightGreen[100],
//             child: ListTile(
//               title: Text(
//                 'Second pair of clothes',
//               ),
//               subtitle: Text(
//                 '2018-11-22\n\nWe will be doing a survival swim tomorrow so please send a second/swimmable pair of clothes tomorrow.',
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewMessagePage()),
//                 );
//               },
//             ),
//           ),
//           Card(
//             color: Colors.lightGreen[100],
//             child: ListTile(
//               title: Text(
//                 'Arrive on time!',
//               ),
//               subtitle: Text(
//                 '2018-10-13\n\nPlease arrive on time as we will be starting right away.',
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NewMessagePage()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.message),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NewMessagePage()),
//           );
//         },
//       ),
//     );
//   }
// }

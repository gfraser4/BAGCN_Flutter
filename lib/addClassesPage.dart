import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClassesPage extends StatefulWidget {
  @override
  _AddClassesPage createState() {
    return _AddClassesPage();
  }
}

class _AddClassesPage extends State<AddClassesPage> {
  final _classNameController = new TextEditingController();
  final _classCodeController = new TextEditingController();
  String className;
  var stream =
      Firestore.instance.collection('class').orderBy('clsName').snapshots();

  Stream<QuerySnapshot> _nameSearch() {
    if (_classNameController.text.length > 0) {
      stream = Firestore.instance
          .collection('class')
          .where('clsName', isEqualTo: _classNameController.text.toUpperCase())
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots();
    }
  }

  Stream<QuerySnapshot> _codeSearch() {
    if (_classCodeController.text.length > 0) {
      stream = Firestore.instance
          .collection('class')
          .where('code', isEqualTo: int.parse(_classCodeController.text))
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots();
    }
  }

  Stream<QuerySnapshot> _clear() {
    _selected = _dropitems[0];
    _classNameController.text = '';
    _classCodeController.text = '';
    stream =
        Firestore.instance.collection('class').orderBy('clsName').snapshots();
    return stream;
  }

  Stream<QuerySnapshot> _ddlClassSearch() {
    if (_selected == 'Class Name') {
      stream = Firestore.instance.collection('class').snapshots();
    } else {
      stream = Firestore.instance
          .collection('class')
          .where('clsName', isEqualTo: _selected)
          .snapshots();
    }
    return stream;
  }

  List<String> _dropitems = ['Class Name'];
  String _selected = 'Class Name';

  // var classList = Firestore.instance
  //     .collection('class')
  //     .snapshots()
  //     .listen((data) => data.documents.forEach((doc) => _dropitems.add(doc["clsName"])));

  @override
  void initState() {
    Firestore.instance
        .collection('class')
        .orderBy('clsName')
        .snapshots()
        .listen((data) =>
            data.documents.forEach((doc) => _dropitems.add(doc["clsName"])));
    super.initState();
  }

  // @override
  // void setState(fn) {
  //   Firestore.instance
  //     .collection('class')
  //     .snapshots()
  //     .listen((data) => data.documents.forEach((doc) => _dropitems.add(doc["clsName"])));
  //   super.setState(fn);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1ca5e5),
      appBar: AppBar(
        title: Text('Manage Classes'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.lightBlue[50],
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Search by Class Name',
                      icon: Icon(Icons.search)),
                  controller: _classNameController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Search by Course Code',
                      icon: Icon(Icons.filter_1)),
                  controller: _classCodeController,
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  trailing: new DropdownButton<String>(
                      items: _dropitems.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: Text(_selected),
                      onChanged: (String val) {
                        _selected = val;
                        _ddlClassSearch();
                        setState(() {});
                      }),
                  //leading: Text('Class Name'),
                  onTap: () {
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      //color: Colors.redAccent,
                      child: Text(
                        'Clear',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () {
                        setState(() {
                          _clear();
                        });
                      },
                    ),
                    RaisedButton(
                      color: Color(0xFF1ca5e5),
                      child: Text(
                        'Search',
                        style: TextStyle(color: Colors.lightBlue[50]),
                      ),
                      onPressed: () {
                        setState(() {
                          _nameSearch();
                          _codeSearch();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Color(0xFF1ca5e5),
          ),
          Expanded(
            child: _buildBody(context, stream),
          ),
        ],
      ),
    );
  }
}

//Search querey dynamic based on search criteria
Widget _buildBody(BuildContext context, var stream) {
  return StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents);
    },
  );
}

//Build ListView for queried items
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

//Username needed to add classes to that parent
Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final classes = Classes.fromSnapshot(data);
  List<String> user = ['lj@gmail.com'];
  return Padding(
    key: ValueKey(classes.clsName),
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Card(
      color: Colors.lightBlue[50],
      elevation: 5.0,
      child: ListTile(
        title: Text(classes.clsName),
        subtitle: Text('Course Code: ${classes.code}'),
        trailing: RaisedButton(
            child: Text(
              'JOIN',
              style: TextStyle(color: Color(0xFF1ca5e5)),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Class?'),
                    content: Text(
                        'Are you sure you want to add ${classes.clsName} - ${classes.code} to your class list?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Accept"),
                        onPressed: () {
                          classes.reference.updateData({
                            "parents": FieldValue.arrayUnion(user),
                          });
                          Navigator.of(context).pushNamed('/');
                        },
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    ),
  );
}

class Classes {
  final String clsName;
  final String location;
  final String dates;
  final String times;
  final int code;
  final DocumentReference reference;

  Classes.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['clsName'] != null),
        assert(map['code'] != null),
        assert(map['dates'] != null),
        assert(map['times'] != null),
        assert(map['location'] != null),
        clsName = map['clsName'],
        location = map['location'],
        dates = map['dates'],
        times = map['times'],
        code = map['code'];

  Classes.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$clsName:$code>";
}

// class MyClassList extends StatelessWidget {
// @override
// String searchText;
// String username = 'lj@gmail.com';
// List<String> user = ['lj@gmail.com'];

// CollectionReference collectionReference =
//       Firestore.instance.collection('class');

//   Widget build(BuildContext context) {
//     return

//      StreamBuilder<QuerySnapshot>(
//       stream: collectionReference
//           .where("section", isEqualTo: searchText)
//           .orderBy("clsName")
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return Text('Loading...');
//           default:
//             return ListView(
//               children:
//                   snapshot.data.documents.map((DocumentSnapshot document) {
//                 return Card(
//                   color: Colors.lightGreen[100],
//                   child: ListTile(
//                     title: Text(document['clsName']),
//                     subtitle: Text(
//                         'Section: ${document['section']}\nLocation: ${document['location']}'),
//                     trailing: RaisedButton(
//                       child: Text(
//                         'JOIN',
//                         style: TextStyle(color: Colors.lightGreen),
//                       ),
//                       onPressed: () {
//                         Firestore.instance.collection('class').document('YbFnaQ8SQd3fRjOmV9Bb').updateData({"parents": FieldValue.arrayUnion(user)});
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 );

//               }).toList(),
//             );
//         }
//       },
//     );
//   }
// }

class ClassSearch extends StatefulWidget {
  //ClassSearch({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _ClassSearch createState() => _ClassSearch();
}

class _ClassSearch extends State<ClassSearch> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Search Classes', icon: Icon(Icons.search)),
    );
  }
}

//ListView(
//   // Important: Remove any padding from the ListView.
//   padding: EdgeInsets.zero,
//   children: <Widget>[
//     TextFormField(
//       decoration: InputDecoration(labelText: 'Search Classes', icon: Icon(Icons.search)),
//     ),
//     ListTile(
//       trailing: new DropdownButton<String>(
//         items: <String>[
//           'Aquatics',
//           'Sports & Rec',
//           'Educational',
//           'Child Care',
//           'Youth Outreach'
//         ].map((String value) {
//           return new DropdownMenuItem<String>(
//             value: value,
//             child: new Text(value),
//           );
//         }).toList(),
//         onChanged: (_) {},
//       ),
//       leading: Text('Program'),
//       onTap: () {},
//     ),
//     ListTile(
//       trailing: new DropdownButton<String>(
//         items: <String>[
//           'Aquatics 101',
//           'Gymnastics',
//           'Jr. Ball Hockey/Soccer',
//           'Kitchen Creations',
//           'Teen Zone'
//         ].map((String value) {
//           return new DropdownMenuItem<String>(
//             value: value,
//             child: new Text(value),
//           );
//         }).toList(),
//         onChanged: (_) {},
//       ),
//       leading: Text('Class Name'),
//       onTap: () {},
//     ),
//     ListTile(
//       trailing: new DropdownButton<String>(
//         items: <String>[
//           'Section 1',
//           'Section 2',
//           'Section 3',
//         ].map((String value) {
//           return new DropdownMenuItem<String>(
//             value: value,
//             child: new Text(value),
//           );
//         }).toList(),
//         onChanged: (_) {},
//       ),
//       leading: Text('Section'),
//       onTap: () {},
//     ),

// Card(
//   color: Colors.lightGreen[100],
//   child: ListTile(
//     title: Text(
//       'Aqautics 101',
//       style: TextStyle(fontSize: 14.0),
//     ),
//     subtitle: Text(
//       'Section 2\n\nInstructor: John Smith',
//       style: TextStyle(fontSize: 12.0),
//     ),
//     onTap: () {

//     },
//     trailing: RaisedButton(
//           child: Text('LEAVE', style: TextStyle(color: Colors.redAccent),),
//           onPressed: () {
//                             // Update the state of the app
//       // ...
//       // Then close the drawer
//       Navigator.pop(context);
//           },
//         ),
//   ),

// ),
// Card(
//   color: Colors.lightGreen[100],
//   child: ListTile(
//     title: Text(
//       'Gymnastics',
//       style: TextStyle(fontSize: 14.0),
//     ),
//     subtitle: Text(
//       'Section 2\n\nInstructor: Laura Smith',
//       style: TextStyle(fontSize: 12.0),
//     ),
//     onTap: () {

//     },
//     trailing: RaisedButton(
//           child: Text('LEAVE', style: TextStyle(color: Colors.redAccent),),
//           onPressed: () {
//                             // Update the state of the app
//       // ...
//       // Then close the drawer
//       Navigator.pop(context);
//           },
//         ),
//   ),

// ),
// Card(
//   color: Colors.lightGreen[100],
//   child: ListTile(
//     title: Text(
//       'Jr. Ball Hockey/Soccer',
//       style: TextStyle(fontSize: 14.0),
//     ),
//     subtitle: Text(
//       'Section 2\n\nInstructor: Bobby Orr',
//       style: TextStyle(fontSize: 12.0),
//     ),
//     onTap: () {

//     },
//     trailing: RaisedButton(
//           child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
//           onPressed: () {
//                             // Update the state of the app
//       // ...
//       // Then close the drawer
//       Navigator.pop(context);
//           },
//         ),
//   ),

// ),
// Card(
//   color: Colors.lightGreen[100],
//   child: ListTile(
//     title: Text(
//       'Kitchen Creations',
//       style: TextStyle(fontSize: 14.0),
//     ),
//     subtitle: Text(
//       'Section 2\n\nInstructor: Julie Cook',
//       style: TextStyle(fontSize: 12.0),
//     ),
//     onTap: () {

//     },
//     trailing: RaisedButton(
//           child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
//           onPressed: () {
//                             // Update the state of the app
//       // ...
//       // Then close the drawer
//       Navigator.pop(context);
//           },
//         ),
//   ),

// ),
// Card(
//   color: Colors.lightGreen[100],
//   child: ListTile(
//     title: Text(
//       'Teen Zone',
//       style: TextStyle(fontSize: 14.0),
//     ),
//     subtitle: Text(
//       'Section 2\n\nInstructor: Jane Doe',
//       style: TextStyle(fontSize: 12.0),
//     ),
//     onTap: () {

//     },
//     trailing: RaisedButton(
//           child: Text('JOIN', style: TextStyle(color: Colors.lightGreen),),
//           onPressed: () {
//                             // Update the state of the app
//       // ...
//       // Then close the drawer
//       Navigator.pop(context);
//           },
//         ),
//   ),

// ),

//         ],
//       ),
//     );
//   }
// }

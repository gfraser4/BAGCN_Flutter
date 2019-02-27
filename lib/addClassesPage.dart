import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './main.dart';
import 'Models/ClassesModel.dart';

//SEARCH AND ADD CLASSES PAGE
class AddClassesPage extends StatefulWidget {

  const AddClassesPage(this.user);
  final FirebaseUser user;

  @override
  _AddClassesPage createState() {
    return _AddClassesPage();
  }
}

class _AddClassesPage extends State<AddClassesPage> {
  final _classNameController = new TextEditingController(); //VAR TO HOLD CLASSNAME INPUT
  final _classCodeController = new TextEditingController(); //VAR TO HOLD CLASSCODE INPUT
  String className;  
  var stream =
      Firestore.instance.collection('class').orderBy('clsName').snapshots(); //DEFAULT QUERY TO LIST ALL CLASSES IN DATABASE

//QUERY FOR CLASS NAME SEARCH
  Stream<QuerySnapshot> _nameSearch() {
    if (_classNameController.text.length > 0) { //CHECK IF THERE IS INPUT IN CLASS NAME SEARCH
      stream = Firestore.instance
          .collection('class')
          .where('clsName', isEqualTo: _classNameController.text.toUpperCase()) //WHERE CLASS NAME IS EQUAL TO THE INPUT
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots(); //ELSE DEFAULT QUERY
    }
  }

  Stream<QuerySnapshot> _codeSearch() {
    if (_classCodeController.text.length > 0) { //CHECK IF THERE IS INPUT IN CLASS CODE SEARCH
      stream = Firestore.instance
          .collection('class')
          .where('code', isEqualTo: int.parse(_classCodeController.text)) //WHERE CLASS CODE IS EQUAL TO THE INPUT
          .snapshots();
      return stream;
    } else {
      return stream =
          Firestore.instance.collection('class').orderBy('clsName').snapshots(); //ELSE DEFAULT QUERY
    }
  }

//CLEAR BUTTON CLEARS INPUTS AND SETS QUERY BACK TO DEFAULT TO LIST ALL CLASSES
  Stream<QuerySnapshot> _clear() {
    _selected = _dropitems[0];
    _classNameController.text = '';
    _classCodeController.text = '';
    stream =
        Firestore.instance.collection('class').orderBy('clsName').snapshots();
    return stream;
  }

//DROPDOWN LIST QUERY --> WHERE CLASS IS EQUAL TO SELECTED DROPWDOWN ITEM
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

//SET DEFAULT DROPDOWN LIST ARRAY WITH ONLY 'Class Name' AND SET _selected ITEM TO 'Class Name'
  List<String> _dropitems = ['Class Name'];
  String _selected = 'Class Name';

//INITIALIZE STATE AND ADD EACH ITEM TO THE DROPDOWN LIST ARRAY
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(123, 193, 67, 1),
      appBar: AppBar(
        title: Text('Manage Classes'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Color(0xFFF4F5F7),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column( //SEARCH AREA BEGINS
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
                  onTap: () {
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
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
          Expanded(
            child: _buildBody(context, stream, widget.user), //SEARCH RESULTS AREA IS BUILT PASSING DYNAMIC QUERY(stream)
          ),
        ],
      ),
    );
  }
}

//Search querey dynamic based on search criteria
Widget _buildBody(BuildContext context, var stream, FirebaseUser user) {
  return StreamBuilder<QuerySnapshot>(
    stream: stream, //QUERY (stream) WILL BE DEPENDENT ON SEARCH FIELDS
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents, user);
    },
  );
}

//Build ListView for queried items based on above query
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, FirebaseUser user) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data, user)).toList(),
  );
}

//WIDGET TO BUILD WACH CLASS ITEM --> Username needed to add classes to that usres class list on their home screen (currently hardcoded as "lj@gmail.com")
Widget _buildListItem(BuildContext context, DocumentSnapshot data, FirebaseUser user) {
  final classes = Classes.fromSnapshot(data);
  List<String> userID = ['${user.uid}'];
  return Padding(
    key: ValueKey(classes.clsName),
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Card(
      color: Color(0xFFF4F5F7),
      elevation: 5.0,
      child: ListTile(
        title: Text(classes.clsName),
        subtitle: Text('Course Code: ${classes.code}'),
        trailing: RaisedButton(
          color: Color.fromRGBO(28, 165, 229, 1),
            child: Text(
              'JOIN',
              style: TextStyle(color: Colors.white),
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
                        child: Text("Add Class"),
                        onPressed: () {
                          classes.reference.updateData({
                            "enrolledUsers": FieldValue.arrayUnion(userID), //UPDATE CLASS FIELD ADDING USER TO enrolledUsers ARRAY
                          });
                            Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new MyClassList(user)));
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




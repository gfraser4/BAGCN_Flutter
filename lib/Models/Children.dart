import 'package:cloud_firestore/cloud_firestore.dart';

// MAP OF USERS QUERY
class Children {
  final String childID;
  final String parentID;
  final String name;
    final List<dynamic> enrolledIn;

  final DocumentReference reference;

  Children.fromMap(Map<String, dynamic> map, {this.reference})
      : //assert(map['childID'] != null),
        assert(map['parentID'] != null),
        assert(map['Name'] != null),
        name = map['Name'],
        childID = map['childID'],
        enrolledIn = map['enrolledIn'],
        parentID = map['parentID'];

  Children.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}
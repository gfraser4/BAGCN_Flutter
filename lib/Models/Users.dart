import 'package:cloud_firestore/cloud_firestore.dart';

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final DocumentReference reference;

  Users.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['lastName'] != null),
        assert(map['email'] != null),
        assert(map['role'] != null),
        assert(map['id'] != null),
        firstName = map['firstName'],
        lastName = map['lastName'],
        id = map['id'],
        email = map['email'],
        role = map['role'];

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Record<$clsName:$title>";
}

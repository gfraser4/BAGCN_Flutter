import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//CLASS MAP BASED ON FIRESTORE ANNOUNCEMENT TABLE
class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String profileColor;
  final List<dynamic> enrolledIn;
  final DocumentReference reference;

  Users.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['email'] != null),
        assert(map['role'] != null),
        assert(map['profileColor'] != null),
        assert(map['id'] != null),
        firstName = map['firstName'],
        enrolledIn = map['enrolledIn'],
        lastName = map['lastName'],
        id = map['id'],
        profileColor = map['profileColor'],
        email = map['email'],
        role = map['role'];

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  // @override
  // String toString() => "Record<$clsName:$title>";
}
